// #if compiler(>=6)
//     internal import OpenSSL
//     internal import COpenSSL
// #else
//     @_implementationOnly import COpenSSL
//     @_implementationOnly import OpenSSL
// #endif

// #if canImport(FoundationEssentials)
//     import FoundationEssentials
// #else
//     import Foundation
// #endif

// public final class CMS: OpenSSLErrReadable {
//     public struct ContentInfo {
//         // OID
//         public enum ContentType: String {
//             case data = "1.2.840.113549.1.7.1"
//             case signedData = "1.2.840.113549.1.7.2"
//             case envelopedData = "1.2.840.113549.1.7.3"
//             case signedAndEnvelopedData = "1.2.840.113549.1.7.4"
//             case digestedData = "1.2.840.113549.1.7.5"
//             case encryptedData = "1.2.840.113549.1.7.6"
//             case compressedData = "1.2.840.113549.1.9.16.1.9"
//             case authenticatedData = "1.2.840.113549.1.9.16.1.2"
//             case authEnvelopedData = "1.2.840.113549.1.9.16.1.23"
//             case timestampedData = "1.2.840.113549.1.9.16.1.31"
//         }

//         var cms: OpaquePointer?
//         public private(set) var contentType: ContentType
//         var contentCache: Data?
//         var ownsCMSObject: Bool

//         init(cmsPtr: OpaquePointer?, owns: Bool) throws {
//             guard let cmsPtr = cmsPtr else {
//                 throw CMSError.invalidPointer
//             }
//             cms = cmsPtr
//             ownsCMSObject = owns
//             contentType = try determineContentType(cms: cmsPtr)
//         }

//         deinit {
//             if ownsCMSObject, let cms = cms {
//                 CMS_ContentInfo_free(cms)
//             }
//         }
//     }

//     private var contentInfo: ContentInfo
//     private let certificate: OpaquePointer
//     private let privateKey: OpaquePointer?

//     public init(certificatePEM: String, privateKeyPEM: String? = nil) throws {
//         OpenSSLWrapper.initialize()

//         guard let cert = OpenSSLWrapper.loadCertificate(fromPEM: certificatePEM) else {
//             throw CMSError.certificateLoadFailed(OpenSSLWrapper.getLastError())
//         }
//         certificate = cert

//         if let privateKeyPEM = privateKeyPEM {
//             guard let key = OpenSSLWrapper.loadPrivateKey(fromPEM: privateKeyPEM) else {
//                 throw CMSError.privateKeyLoadFailed(OpenSSLWrapper.getLastError())
//             }
//             privateKey = key
//         } else {
//             privateKey = nil
//         }

//         contentInfo = try ContentInfo(cmsPtr: nil, owns: true)
//     }

//     deinit {
//         X509_free(certificate)
//         if let privateKey = privateKey {
//             EVP_PKEY_free(privateKey)
//         }
//     }
// }

// public extension CMS {
//     func encrypt(data: Data, recipientCertificates: [OpaquePointer]) throws {
//         guard !recipientCertificates.isEmpty else {
//             throw CMSError.encryptionFailed("No recipient certificates provided")
//         }

//         let cms = CMS_encrypt(recipientCertificates,
//                               data.withUnsafeBytes { $0.baseAddress },
//                               Int32(data.count),
//                               nil,
//                               UInt32(CMS_STREAM))
//         guard cms != nil else {
//             throw CMSError.encryptionFailed(OpenSSLWrapper.getLastError())
//         }

//         // 更新 ContentInfo
//         contentInfo = try ContentInfo(cmsPtr: cms, owns: true)
//     }

//     func decrypt() throws -> Data {
//         guard let cms = contentInfo.cmsPtr else {
//             throw CMSError.decryptionFailed("No encrypted content available")
//         }

//         guard let privateKey = privateKey else {
//             throw CMSError.decryptionFailed("No private key available")
//         }

//         let bio = BIO_new(BIO_s_mem())
//         defer { BIO_free(bio) }

//         guard CMS_decrypt(cms, privateKey, certificate, nil, bio, UInt32(CMS_STREAM)) == 1 else {
//             throw CMSError.decryptionFailed(OpenSSLWrapper.getLastError())
//         }

//         var ptr: UnsafeMutablePointer<UInt8>?
//         let len = BIO_get_mem_data(bio, &ptr)

//         guard let ptr = ptr, len > 0 else {
//             throw CMSError.decryptionFailed("No decrypted data")
//         }

//         return Data(bytes: ptr, count: Int(len))
//     }

//     // MARK: - 签名功能

//     func sign(data: Data) throws {
//         guard let privateKey = privateKey else {
//             throw CMSError.signingFailed("No private key available")
//         }

//         let cms = CMS_sign(certificate, privateKey, nil, nil, UInt32(CMS_STREAM | CMS_DETACHED))
//         guard cms != nil else {
//             throw CMSError.signingFailed(OpenSSLWrapper.getLastError())
//         }

//         let bio = BIO_new_mem_buf(data.withUnsafeBytes { $0.baseAddress }, Int32(data.count))
//         defer { BIO_free(bio) }

//         guard CMS_dataFinal(cms, bio) == 1 else {
//             CMS_ContentInfo_free(cms)
//             throw CMSError.signingFailed(OpenSSLWrapper.getLastError())
//         }

//         // 更新 ContentInfo
//         contentInfo = try ContentInfo(cmsPtr: cms, owns: true)
//     }

//     func verify() throws -> (data: Data, valid: Bool) {
//         guard let cms = contentInfo.cmsPtr else {
//             throw CMSError.verificationFailed("No signed content available")
//         }

//         let bio = BIO_new(BIO_s_mem())
//         defer { BIO_free(bio) }

//         let result = CMS_verify(cms, nil, nil, nil, bio, UInt32(CMS_STREAM))

//         var ptr: UnsafeMutablePointer<UInt8>?
//         let len = BIO_get_mem_data(bio, &ptr)

//         guard let ptr = ptr, len > 0 else {
//             throw CMSError.verificationFailed("No data in BIO")
//         }

//         let data = Data(bytes: ptr, count: Int(len))
//         return (data, result == 1)
//     }
// }
