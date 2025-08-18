import Logging

internal import OpenSSL
internal import COpenSSL

#if canImport(FoundationNetworking)
    import FoundationNetworking
#else
    import Foundation
#endif

public struct OCSPClient: Sendable {
    private let logger: Logger

    public init(logger: Logger = Logger(label: "OpenSSLSwift.OCSPClient")) {
        self.logger = logger
    }

    public static func supportsOCSP(certificate: Certificate) -> Bool {
        let ocspURLs = X509_get1_ocsp(certificate.x509)
        defer { cc_sk_OPENSSL_STRING_free(ocspURLs) }

        return cc_sk_OPENSSL_STRING_num(ocspURLs) > 0
    }

    /// Request Certificate Status
    /// - Parameters:
    ///   - certificate: the certificate
    ///   - issuer: the certificate issuer
    /// - Returns: OCSP Status
    public func requestCertificateStatus(_ certificate: Certificate, issuer: Certificate) async throws -> OCSPStatus {
        guard Self.supportsOCSP(certificate: issuer) else {
            throw OCSPError.unSupportsOCSP
        }

        let ocspRequest = try OCSPRequest(certificate: certificate, issuer: issuer)
        var request = URLRequest(url: ocspRequest.endpoint, timeoutInterval: 30)
        request.addValue("application/ocsp-request", forHTTPHeaderField: "Content-Type")
        request.httpBody = ocspRequest.requestDER
        request.httpMethod = "POST"

        let (repsonseBody, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OCSPError.badResponse
        }
        guard httpResponse.statusCode == 200 else {
            logger.error("OCSP BadResponse: \(httpResponse.statusCode)")
            throw OCSPError.requestError(statusCode: httpResponse.statusCode)
        }
        guard let contentType = response.mimeType, contentType == "application/ocsp-response" else {
            throw OCSPError.badResponse
        }
        guard !repsonseBody.isEmpty else {
            throw OCSPError.emptyResponseBody
        }

        let resp = try OCSPResponse(der: repsonseBody, cert: certificate, issuer: issuer)
        guard resp.responseStatus == .successful else {
            throw OCSPError.responseError(statusCode: resp.responseStatus.rawValue)
        }
        return resp.ocspStatus
    }
}
