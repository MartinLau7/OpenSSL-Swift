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

public struct PublicKey: ~Copyable {
    var owned: Bool
    let evpKey: OpaquePointer

    // public init(pemData _: Data) throws {
    //     let bio = BIO_new_mem_buf(pemString, Int32(pemString.utf8.count))
    //     defer { BIO_free(bio) }

    //     guard let key = PEM_read_bio_PUBKEY(bio, nil, nil, nil) else {
    //         throw KeyError.keyLoadFailed(OpenSSLWrapper.getLastError())
    //     }
    //     evpKey = key
    // }

    // public init(derData: Data) throws {
    //     let bio = BIO_new_mem_buf(derData.withUnsafeBytes { $0.baseAddress }, Int32(derData.count))
    //     defer { BIO_free(bio) }

    //     guard let key = d2i_PUBKEY_bio(bio, nil) else {
    //         throw KeyError.keyLoadFailed(OpenSSLWrapper.getLastError())
    //     }
    //     evpKey = key
    // }

    public init(owning evpKey: OpaquePointer) {
        self.evpKey = evpKey
        owned = true
    }

    public init(borrowing evpKey: OpaquePointer) {
        self.evpKey = evpKey
        owned = false
    }

    deinit {
        if owned {
            EVP_PKEY_free(evpKey)
        }
    }

    public func toPEM() throws -> String {
        let bio = BIO_new(BIO_s_mem())
        defer { BIO_free(bio) }

        guard PEM_write_bio_PUBKEY(bio, evpKey) == 1 else {
            guard let error = OpenSSLError.readError() else {
                throw KeyError.exceptionWithMessage("Unknown error")
            }
            throw KeyError.exception(error)
        }

        var ptr: UnsafeMutablePointer<Int8>?
        let len = c_BIO_get_mem_data(bio, &ptr)

        guard let ptr = ptr, len > 0 else {
            throw KeyError.keyExportFailed("No data in BIO")
        }

        return String(cString: ptr)
    }

    // public func toDER() throws -> Data {
    //     let bio = BIO_new(BIO_s_mem())
    //     defer { BIO_free(bio) }

    //     guard i2d_PUBKEY_bio(bio, evpKey) == 1 else {
    //         guard let error = OpenSSLError.readError() else {
    //             throw KeyError.exceptionWithMessage("Unknown error")
    //         }
    //         throw KeyError.exception(error)
    //     }

    //     var ptr: UnsafeMutablePointer<UInt8>?
    //     let len = c_BIO_get_mem_data(bio, &ptr)

    //     guard let ptr = ptr, len > 0 else {
    //         throw KeyError.keyExportFailed("No data in BIO")
    //     }

    //     return Data(bytes: ptr, count: Int(len))
    // }
}
