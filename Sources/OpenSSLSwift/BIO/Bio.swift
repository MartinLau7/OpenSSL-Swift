#if compiler(>=6)
    internal import OpenSSL
    internal import COpenSSL
#else
    @_implementationOnly import COpenSSL
    @_implementationOnly import OpenSSL
#endif

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

public final class Bio {
    public enum BioError: Error {
        case fileNotFound
        case fileIsNotRegularFile

        case failedToLoadBIO
        case discontiguousDataRegions

        case exception(OpenSSLError)
    }

    var owned: Bool
    let bio: OpaquePointer

    public init() {
        bio = BIO_new(BIO_s_mem())
        owned = true
    }

    public init(owning bio: OpaquePointer) {
        self.bio = bio
        owned = true
    }

    public init(borrowing bio: OpaquePointer) {
        self.bio = bio
        owned = false
    }

    public init(contentsOf url: URL) throws {
        let path = url.path
        guard !path.isEmpty else {
            throw BioError.fileNotFound
        }
        guard let bio = BIO_new_file(path, FileMode.readWrite.rawValue) else {
            guard let error = OpenSSLError.readError() else {
                throw BioError.failedToLoadBIO
            }
            throw BioError.exception(error)
        }
        self.bio = bio
        owned = true
    }

    public init(contentsOfFile path: String) throws {
        guard let bio = BIO_new_file(path, FileMode.readWrite.rawValue) else {
            guard let error = OpenSSLError.readError() else {
                throw BioError.failedToLoadBIO
            }
            throw BioError.exception(error)
        }
        self.bio = bio
        owned = true
    }

    deinit {
        if owned {
            BIO_free(bio)
        }
    }

    public func write(_ data: Data) throws -> Int {
        return data.withUnsafeBytes { ptr in

            let result = BIO_write(bio, ptr.baseAddress?.assumingMemoryBound(to: UInt8.self), Int32(data.count))
            if result < 0 {
                return -1
            }
            return Int(result)
        }
    }

    public func read() throws -> Data {
        guard let bio = bio else { throw OpenSSLError.invalidState }
        var buffer = [UInt8](repeating: 0, count: count)
        let bytesRead = BIO_read(bio, &buffer, Int32(count))

        if bytesRead <= 0 {
            if BIO_should_retry(bio) == 0 {
                throw OpenSSLError.operationFailed
            }
            return Data()
        }

        return Data(buffer[0 ..< Int(bytesRead)])
    }

    public func readAllData() throws -> Data {
        var buf: UnsafeMutablePointer<CChar>?
        let len = c_BIO_get_mem_data(bio, &buf)
        guard len > 0 else {
            throw BioError.failedToReadData
        }
    }

    public func readAll() throws -> Data {
        var result = Data()
        while pendingBytes > 0 {
            let chunk = try read(count: min(pendingBytes, 4096))
            result.append(chunk)
        }
        return result
    }

    public func flush() throws {
        guard let bio = bio else { throw OpenSSLError.invalidState }
        if BIO_flush(bio) <= 0 {
            throw OpenSSLError.operationFailed
        }
    }
}

public extension Bio {
    static func load(buffer data: Data) throws -> Bio {
        guard data.regions.count <= 1 else { throw BioError.discontiguousDataRegions }
        guard let region = data.regions.first else { throw BioError.failedToLoadBIO }

        return try region.withUnsafeBytes { ptr in
            guard let bio = BIO_new_mem_buf(ptr.baseAddress, numericCast(ptr.count)) else {
                throw BioError.failedToLoadBIO
            }
            return Bio(owning: bio)
        }
    }

    static func load(derFile path: String) throws -> Bio {
        guard let bio = BIO_new_file(path, "rb") else {
            throw BioError.fileNotFound
        }
        return Bio(owning: bio)
    }

    static func load(pemFile path: String) throws -> Bio {
        guard let bio = BIO_new_file(path, "r") else {
            throw BioError.fileNotFound
        }
        return Bio(owning: bio)
    }
}
