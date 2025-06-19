internal import COpenSSL

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

public enum ByteIO {
    public enum ByteIOError: Error {
        case fileNotFound

        case failedToLoadBIO
        case discontiguousDataRegions
    }

    static func loadFromData(_ data: Data) throws -> OpaquePointer {
        guard data.regions.count <= 1 else { throw ByteIOError.discontiguousDataRegions }
        guard let region = data.regions.first else { throw ByteIOError.failedToLoadBIO }

        return try region.withUnsafeBytes { ptr in
            guard let bio = BIO_new_mem_buf(ptr.baseAddress, numericCast(ptr.count)) else {
                throw ByteIOError.failedToLoadBIO
            }
            return bio
        }
    }

    static func loadFromPEM(atPath path: String) throws -> OpaquePointer {
        guard let bio = BIO_new_file(path, "rb") else {
            throw ByteIOError.fileNotFound
        }

        return bio
    }
}

public extension Data {
    func withReadOnlyMemoryBIO<ReturnValue>(_ block: (OpaquePointer) throws -> ReturnValue) rethrows -> ReturnValue {
        return try withUnsafeBytes { pointer in
            let bio = BIO_new_mem_buf(pointer.baseAddress, numericCast(pointer.count))
            guard let bio else { throw ByteIO.ByteIOError.failedToLoadBIO }
            defer { BIO_free(bio) }

            return try block(bio)
        }
    }
}
