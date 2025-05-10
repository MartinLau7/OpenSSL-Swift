#if compiler(>=6)
    internal import OpenSSL
#else
    @_implementationOnly import OpenSSL
#endif

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

public protocol BIOLoadable {}

public enum BIOLoadableError: Error {
    case failedToLoadBIO
}

extension BIOLoadable {
    static func load<Data, T>(buffer data: Data, _ closure: (OpaquePointer) -> T?) throws -> T where Data: DataProtocol {
        precondition(data.regions.count <= 1, "There is no such thing as data that has discontiguous regions")
        guard let region = data.regions.first else { throw BIOLoadableError.failedToLoadBIO }

        return try region.withUnsafeBytes { ptr in
            let bio = BIO_new_mem_buf(ptr.baseAddress, numericCast(ptr.count))
            guard let bioPtr = bio else { throw BIOLoadableError.failedToLoadBIO }
            defer { BIO_free(bio) }
            guard let result = closure(bioPtr) else { throw BIOLoadableError.failedToLoadBIO }
            return result
        }
    }

    static func load<Data, T>(buffer data: Data, _ closure: (OpaquePointer) throws -> T?) throws -> T where Data: DataProtocol {
        precondition(data.regions.count <= 1, "There is no such thing as data that has discontiguous regions")
        guard let region = data.regions.first else { throw BIOLoadableError.failedToLoadBIO }

        return try region.withUnsafeBytes { ptr in
            let bio = BIO_new_mem_buf(ptr.baseAddress, numericCast(ptr.count))
            guard let bioPtr = bio else { throw BIOLoadableError.failedToLoadBIO }
            defer { BIO_free(bio) }
            guard let result = try closure(bioPtr) else { throw BIOLoadableError.failedToLoadBIO }
            return result
        }
    }
}
