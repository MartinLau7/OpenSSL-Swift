internal import COpenSSL

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

/// OCSP Response
public class OCSPResponse: @unchecked Sendable {
    public enum OCSPResponseStatus: Int32 {
        case successful = 0
        case malformedRequest = 1
        case internalError = 2
        case tryLater = 3
        case sigRequired = 4
        case unauthorized = 5
    }

    public enum OCSPResponseError: Error {
        case producedAtNotFound
        case responseTypeWasNotOCSPBasic
        case unknownSignatureAlgorithm(Int32)
        case unknownHashAlgorithm(Int32)
        case nextUpdateDateWasNotPresent
        case unknownCertStatus(Int32)
    }

    let ocspResp: OpaquePointer
    let responseStatus: OCSPResponseStatus
    let ocspStatus: OCSPStatus

    /// Initialize a OCSP Response from DER representation
    ///
    /// - Parameter derRepresentation: raw DER bytes
    /// - Throws:  `OCSPResponseError` when the response could not be initialized
    init(der: Data, cert: Certificate, issuer: Certificate) throws {
        ocspResp = try der.withUnsafeBytes { buffer in
            var bytesPtr = buffer.bindMemory(to: UInt8.self).baseAddress
            guard let raw = d2i_OCSP_RESPONSE(nil, &bytesPtr, buffer.count) else {
                throw OCSPError.responseConversionFailure
            }
            return raw
        }

        if let respStatus = OCSPResponseStatus(rawValue: OCSP_response_status(ocspResp)) {
            responseStatus = respStatus
        } else {
            responseStatus = .internalError
        }

        let certId: OpaquePointer = OCSP_cert_to_id(EVP_sha1(), cert.x509, issuer.x509)
        defer {
            OCSP_CERTID_free(certId)
        }
        let basic = OCSP_response_get1_basic(ocspResp)
        defer {
            OCSP_BASICRESP_free(basic)
        }

        var status: CInt = -1
        var reason: Int32 = -1
        var thisUpdateTime: UnsafeMutablePointer<ASN1_GENERALIZEDTIME>?
        var nextUpdateTime: UnsafeMutablePointer<ASN1_GENERALIZEDTIME>?
        var revocationTime: UnsafeMutablePointer<ASN1_GENERALIZEDTIME>?

        guard OCSP_resp_find_status(basic, certId, &status, &reason, &revocationTime, &thisUpdateTime, &nextUpdateTime) == 1 else {
            throw OCSPError.requestedCertificateNotInResponse
        }
        let serialNumber = try Self.withSerialNumber(from: certId) { bigNum in
            if let hex = BN_bn2hex(bigNum) {
                return String(cString: hex)
            }
            return ""
        }
        var isExpired = false
        if let expirationTime = cert.notAfter {
            isExpired = Date() > expirationTime
        }
        ocspStatus = OCSPStatus(certStatus: .init(rawValue: status)!,
                                reason: reason,
                                serialNumber: serialNumber,
                                isExpired: isExpired,
                                thisUpdate: thisUpdateTime?.asFoundationDate(),
                                nextUpdate: nextUpdateTime?.asFoundationDate(),
                                revocationAt: revocationTime?.asFoundationDate())
    }

    /// De-initialize
    deinit {
        OCSP_RESPONSE_free(ocspResp)
    }

    /// Extract the *producedAt* field from the basis response.
    ///
    /// - Returns: `Date` from the *producedAt* field
    public var producedAt: Date? {
        let basic = OCSP_response_get1_basic(ocspResp)
        defer { OCSP_BASICRESP_free(basic) }

        guard let producedAt = OCSP_resp_get0_produced_at(basic) else {
            return nil
        }
        return producedAt.asFoundationDate()
    }

    private static func withSerialNumber<T>(from certId: OpaquePointer, _ closure: (OpaquePointer) throws -> T) throws -> T {
        var serialNumberPtr: UnsafeMutablePointer<ASN1_INTEGER>?
        guard OCSP_id_get0_info(nil, nil, nil, &serialNumberPtr, certId) == 1, let bigNum = ASN1_INTEGER_to_BN(serialNumberPtr, nil) else {
            // throw CertificateError.failedToGetSerialNumber
            throw OCSPError.responseConversionFailure
        }
        defer {
            BN_free(bigNum)
        }
        return try closure(bigNum)
    }
}
