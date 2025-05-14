
// public final class PrivateKey: Key {
//     public let evpKey: OpaquePointer
//     public let ownsKey: Bool

//     public init(pemString: String, passphrase: String? = nil) throws {
//         let bio = BIO_new_mem_buf(pemString, Int32(pemString.utf8.count))
//         defer { BIO_free(bio) }

//         let callback: password_cb = { buf, size, _, userdata in
//             guard let passphrase = userdata?.assumingMemoryBound(to: String.self).pointee else {
//                 return 0
//             }
//             let count = min(size, passphrase.utf8.count)
//             passphrase.withCString { cstr in
//                 memcpy(buf, cstr, count)
//             }
//             return Int32(count)
//         }

//         var passphraseRef = passphrase
//         let userdata = passphrase != nil ? withUnsafeMutablePointer(to: &passphraseRef) { UnsafeMutableRawPointer($0) } : nil

//         guard let key = PEM_read_bio_PrivateKey(bio, nil, callback, userdata) else {
//             throw KeyError.keyLoadFailed(OpenSSLWrapper.getLastError())
//         }
//         evpKey = key
//         ownsKey = true
//     }

//     public init(derData: Data) throws {
//         let bio = BIO_new_mem_buf(derData.withUnsafeBytes { $0.baseAddress }, Int32(derData.count))
//         defer { BIO_free(bio) }

//         guard let key = d2i_PrivateKey_bio(bio, nil) else {
//             throw KeyError.keyLoadFailed(OpenSSLWrapper.getLastError())
//         }
//         evpKey = key
//         ownsKey = true
//     }

//     public init(borrowing evpKey: OpaquePointer, ownsKey: Bool = false) {
//         self.evpKey = evpKey
//         self.ownsKey = ownsKey
//     }

//     deinit {
//         EVP_PKEY_free(evpKey)
//     }

//     public func toPEM() throws -> String {
//         return try toPEM(passphrase: nil)
//     }

//     public func toPEM(passphrase: String?) throws -> String {
//         let bio = BIO_new(BIO_s_mem())
//         defer { BIO_free(bio) }

//         let enc: Int32
//         let cipher: UnsafePointer<EVP_CIPHER>?
//         let passphrasePtr: UnsafePointer<Int8>?

//         if let passphrase = passphrase {
//             enc = 1
//             cipher = EVP_aes_256_cbc()
//             passphrasePtr = passphrase.withCString { UnsafePointer($0) }
//         } else {
//             enc = 0
//             cipher = nil
//             passphrasePtr = nil
//         }

//         guard PEM_write_bio_PrivateKey(bio, evpKey, cipher, passphrasePtr, Int32(passphrase?.count ?? 0), nil, nil) == 1 else {
//             throw KeyError.keyExportFailed(OpenSSLWrapper.getLastError())
//         }

//         var ptr: UnsafeMutablePointer<Int8>?
//         let len = BIO_get_mem_data(bio, &ptr)

//         guard let ptr = ptr, len > 0 else {
//             throw KeyError.keyExportFailed("No data in BIO")
//         }

//         return String(cString: ptr)
//     }

//     public func toDER() throws -> Data {
//         let bio = BIO_new(BIO_s_mem())
//         defer { BIO_free(bio) }

//         guard i2d_PrivateKey_bio(bio, evpKey) == 1 else {
//             throw KeyError.keyExportFailed(OpenSSLWrapper.getLastError())
//         }

//         var ptr: UnsafeMutablePointer<UInt8>?
//         let len = BIO_get_mem_data(bio, &ptr)

//         guard let ptr = ptr, len > 0 else {
//             throw KeyError.keyExportFailed("No data in BIO")
//         }

//         return Data(bytes: ptr, count: Int(len))
//     }

//     public func extractPublicKey() throws -> PublicKey {
//         let bio = BIO_new(BIO_s_mem())
//         defer { BIO_free(bio) }

//         guard PEM_write_bio_PUBKEY(bio, evpKey) == 1 else {
//             throw KeyError.keyConversionFailed(OpenSSLWrapper.getLastError())
//         }

//         guard let pubKey = PEM_read_bio_PUBKEY(bio, nil, nil, nil) else {
//             throw KeyError.keyConversionFailed("Failed to extract public key")
//         }

//         return PublicKey(borrowing: pubKey, ownsKey: true)
//     }
// }
