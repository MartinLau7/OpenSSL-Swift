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

// public extension CMS.ContentInfo {
//     func getContent() throws -> Data {
//         guard let cms = cms else {
//             throw CMSError.invalidState("CMS structure not initialized")
//         }

//         let bio = BIO_new(BIO_s_mem())
//         defer { BIO_free(bio) }

//         guard CMS_dataInit(cms, bio) == 1 else {
//             throw CMSError.contentAccessFailed(OpenSSLWrapper.getLastError())
//         }

//         var ptr: UnsafeMutablePointer<UInt8>?
//         let len = BIO_get_mem_data(bio, &ptr)

//         guard let ptr = ptr, len > 0 else {
//             return Data()
//         }

//         return Data(bytes: ptr, count: Int(len))
//     }

//     func serializeToDER() throws -> Data {
//         guard let cms = cms else {
//             throw CMSError.invalidState("CMS structure not initialized")
//         }

//         let bio = BIO_new(BIO_s_mem())
//         defer { BIO_free(bio) }

//         guard i2d_CMS_bio(bio, cms) == 1 else {
//             throw CMSError.serializationFailed(OpenSSLWrapper.getLastError())
//         }

//         var ptr: UnsafeMutablePointer<UInt8>?
//         let len = BIO_get_mem_data(bio, &ptr)

//         guard let ptr = ptr, len > 0 else {
//             throw CMSError.serializationFailed("No data in BIO")
//         }

//         return Data(bytes: ptr, count: Int(len))
//     }

//     private func determineContentType(cms: OpaquePointer) throws -> ContentType {
//         guard let contentTypeObj = CMS_get0_type(cms) else {
//             throw CMSError.parseFailed("Failed to get content type")
//         }

//         var oidBuffer = [Int8](repeating: 0, count: 256)
//         _ = OBJ_obj2txt(&oidBuffer, Int32(oidBuffer.count), contentTypeObj, 1)
//         let oidString = String(cString: oidBuffer)

//         guard let contentType = ContentType(rawValue: oidString) else {
//             throw CMSError.unsupportedType("Unsupported content type: \(oidString)")
//         }

//         return contentType
//     }
// }
