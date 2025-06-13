internal import OpenSSL

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

public enum ByteIO {
    public enum ByteIOError: Error {
        case fileNotFound
        case fileIsNotRegularFile

        case failedToLoadBIO
        case discontiguousDataRegions

        case exception(OpenSSLError)
    }

    static func load(buffer data: Data) throws -> OpaquePointer {
        guard data.regions.count <= 1 else { throw ByteIOError.discontiguousDataRegions }
        guard let region = data.regions.first else { throw ByteIOError.failedToLoadBIO }

        return try region.withUnsafeBytes { ptr in
            guard let bio = BIO_new_mem_buf(ptr.baseAddress, numericCast(ptr.count)) else {
                throw ByteIOError.failedToLoadBIO
            }
            return bio
        }
    }

    static func load(derFile path: String) throws -> OpaquePointer {
        guard let bio = BIO_new_file(path, "rb") else {
            throw ByteIOError.fileNotFound
        }
        return bio
    }

    static func load(pemFile path: String) throws -> OpaquePointer {
        guard let bio = BIO_new_file(path, "rb") else {
            throw ByteIOError.fileNotFound
        }
        return bio
    }
}
