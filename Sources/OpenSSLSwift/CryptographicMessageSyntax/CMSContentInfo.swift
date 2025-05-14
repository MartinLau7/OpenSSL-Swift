// #if compiler(>=6)
//     internal import OpenSSL
//     internal import COpenSSL
// #else
//     @_implementationOnly import COpenSSL
//     @_implementationOnly import OpenSSL
// #endif

// import Foundation

// /// CMSContentInfo
// public final class CMSContent: OpenSSLErrReadable {
//     let cms: OpaquePointer

//     public init() {
//         cms = CMS_ContentInfo_new()
//     }

//     public init(owning cms: OpaquePointer) {
//         self.cms = cms
//     }

//     public init(data: Data) throws {
//         let bio = try Bio.load(buffer: data)
//         cms = d2i_CMS_bio(bio.bio, nil)
//     }

//     public convenience init(contentOf url: URL) throws {
//         guard FileManager.default.fileExists(atPath: url.path) else {
//             throw CocoaError(.fileNoSuchFile, userInfo: [NSURLErrorKey: url])
//         }
//         let data = try Data(contentsOf: url)
//         try self.init(data: data)
//     }

//     /// De-initialize
//     deinit {
//         CMS_ContentInfo_free(cms)
//     }
// }

// public extension CMSContent {
//     func readASN1StringContent() throws -> Data {
//         guard let contentPtr = CMS_get0_content(cms).pointee else {
//             var errorMessage = "Undefined error"
//             if let error = readError() {
//                 errorMessage = "\(error.errorDescription) [\(error.errCode)]"
//             }
//             throw CMSError.exception(errorDescription: errorMessage)
//         }
//         return Data(bytesNoCopy: UnsafeMutableRawPointer(contentPtr.pointee.data), count: numericCast(contentPtr.pointee.length), deallocator: .none)
//     }
// }
