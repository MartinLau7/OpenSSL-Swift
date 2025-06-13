internal import OpenSSL
internal import COpenSSL

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

struct OCSPRequest {
    enum OCSPRequestError: Error {
        case failedToGetIssuerPublicKey
        case failedToGetIssuerSubject
        case failedToGetSerialNumber
        case failedToGenerateRequest
    }

    /// The OCSP server endpoint (fetched from leaf)
    let endpoint: URL
    /// The OCSP request ASN1 as DER encoded bytes.
    let requestDER: Data

    init(certificate: Certificate, issuer: Certificate) throws {
        let ocspURLs = X509_get1_ocsp(issuer.x509)
        defer { OPENSSL_sk_free(ocspURLs) }

        let ocspURLCount = cc_sk_OPENSSL_STRING_num(ocspURLs)
        guard ocspURLCount >= 1 else {
            throw OCSPError.badURL
        }
        var ocspURL: URL?
        for index in 0 ..< ocspURLCount {
            guard let urlStr = cc_sk_OPENSSL_STRING_value(ocspURLs, numericCast(index)),
                  let url = String(validatingCString: urlStr).flatMap({ URL(string: $0) })
            else {
                continue
            }
            ocspURL = url
            break
        }
        guard let ocspURL else { throw OCSPError.badURL }
        endpoint = ocspURL

        // Construct the OCSP request
        let digest = EVP_sha1()
        let certid = OCSP_cert_to_id(digest, certificate.x509, issuer.x509)
        let request = OCSP_REQUEST_new()
        defer { OCSP_REQUEST_free(request) }

        guard OCSP_request_add0_id(request, certid) != nil else {
            throw OCSPRequestError.failedToGenerateRequest
        }

        // Write the request binary to memory bio
        let bio = BIO_new(BIO_s_mem())
        defer { BIO_free(bio) }

        guard cc_i2d_OCSP_REQUEST_bio(bio, request) > 0 else {
            throw OCSPRequestError.failedToGenerateRequest
        }

        // Copy from bio to byte array then convert to Data
        let bufferSize: CInt = 128
        var buffer = [UInt8](repeating: 0x0, count: Int(bufferSize))
        var requestData = Data()
        var readBytes: CInt = 0

        repeat {
            readBytes = BIO_read(bio, &buffer, bufferSize)
            if readBytes > 0 {
                requestData.append(contentsOf: buffer[0 ..< Int(readBytes)])
            }
        } while readBytes > 0

        requestDER = requestData
    }
}
