//
//  PrivateKey.swift
//  OpenSSL-Swift
//
//  Created by 𝗠𝗮𝗿𝘁𝗶𝗻 𝗟𝗮𝘂 on 2025-07-02.
//

internal import OpenSSL
internal import COpenSSL

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

public final class PrivateKey {
    let key: OpaquePointer

    init(owning evpKey: OpaquePointer) {
        self.key = evpKey
    }

    init(copying evpKey: OpaquePointer) throws {
        guard EVP_PKEY_up_ref(evpKey) == 1 else {
            throw CryptoError.internalError()
        }
        self.key = evpKey
    }

    deinit {
        EVP_PKEY_free(key)
    }

    public static func decode(fromDER data: Data) throws -> Self {
        guard !data.isEmpty else {
            throw KeyError.invalidDERData
        }

        return try data.withReadOnlyMemoryBIO { bio in
            guard let key = d2i_PrivateKey_bio(bio, nil) else {
                throw CryptoError.internalError()
            }
            return Self(owning: key)
        }
    }

    public static func decode(fromPEM data: Data, passphrase: String? = nil) throws -> Self {
        guard !data.isEmpty else {
            throw KeyError.invalidPEMDocument
        }

        return try data.withReadOnlyMemoryBIO { bio in
            var passphrasePtr: UnsafeMutableRawPointer? = nil
            defer {
                passphrasePtr?.deallocate()
            }
            if let passphrase {
                let data = Data(passphrase.utf8)
                passphrasePtr = UnsafeMutableRawPointer.allocate(byteCount: data.count, alignment: 1)
                data.copyBytes(to: passphrasePtr!.assumingMemoryBound(to: UInt8.self), count: data.count)
            }
            guard let key = PEM_read_bio_PrivateKey(bio, nil, nil, passphrasePtr) else {
                throw CryptoError.internalError()
            }
            return Self(owning: key)
        }
    }
}

public extension PrivateKey {
    enum PrivateKeyType: Equatable {
        case rsa
//        case ecdsa(curve: String?) // 可选曲线名，如 "prime256v1", "secp384r1"
        case ed25519
        case unknown(Int32)
    }

    var keyType: PrivateKeyType {
        let type = EVP_PKEY_get_id(key)

        switch type {
            case EVP_PKEY_RSA:
                return .rsa
//            case EVP_PKEY_EC:
//                // 获取 EC 密钥的曲线 OID
//                var groupName = [CChar](repeating: 0, count: 256)
//                var nameLen: size_t = 0
//
//                let result = EVP_PKEY_get_group_name(key, &groupName, groupName.count, &nameLen)
//
//                let curveName = String(cString: groupName)
//                return .ecdsa(curve: curveName)
            case EVP_PKEY_ED25519:
                return .ed25519
            default:
                return .unknown(type)
        }
    }
}
