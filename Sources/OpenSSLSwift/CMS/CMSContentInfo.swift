#if compiler(>=6)
    internal import OpenSSL
    internal import COpenSSL
#else
    @_implementationOnly import COpenSSL
    @_implementationOnly import OpenSSL
#endif

import Foundation

/// CMSContentInfo
public final class CMSContent: BIOLoadable, OpenSSLErrReadable {
    let cms: OpaquePointer

    /// De-initialize
    deinit {
        CMS_ContentInfo_free(cms)
    }

    public init() {
        cms = CMS_ContentInfo_new()
    }

    public init(owningNoCopy cms: OpaquePointer) {
        self.cms = cms
    }

    init(data: Data) throws {
        cms = try Self.load(buffer: data) { buffIO in
            d2i_CMS_bio(buffIO, nil)
        }
    }

    convenience init(contentOf url: URL) throws {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw CocoaError(.fileNoSuchFile, userInfo: [NSURLErrorKey: url])
        }
        let data = try Data(contentsOf: url)
        try self.init(data: data)
    }
}

public extension CMSContent {
    func readASN1StringContent() throws -> Data {
        guard let contentPtr = CMS_get0_content(cms).pointee else {
            var errorMessage = "Undefined error"
            if let error = readError() {
                errorMessage = "\(error.errorDescription) [\(error.errCode)]"
            }
            throw CMSError.exception(errorDescription: errorMessage)
        }
        return Data(bytesNoCopy: UnsafeMutableRawPointer(contentPtr.pointee.data), count: numericCast(contentPtr.pointee.length), deallocator: .none)
    }
}
