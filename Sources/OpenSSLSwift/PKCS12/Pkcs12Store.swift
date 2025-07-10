//
//  Pkcs12Store.swift
//  OpenSSL-Swift
//
//  Created by 𝗠𝗮𝗿𝘁𝗶𝗻 𝗟𝗮𝘂 on 2025-06-25.
//

internal import OpenSSL
internal import COpenSSL

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

public final class Pkcs12Store {
    let p12: OpaquePointer
    var evpKey: OpaquePointer?
    var x509: OpaquePointer?
    var ca: OpaquePointer?

    init(owning p12: OpaquePointer, evpKey: OpaquePointer? = nil, x509: OpaquePointer? = nil, ca: OpaquePointer? = nil) {
        self.p12 = p12
        self.evpKey = evpKey
        self.x509 = x509
        self.ca = ca
    }

    deinit {
        if let ca {
            cc_sk_X509_pop_free(ca)
        }
        if let evpKey {
            EVP_PKEY_free(evpKey)
        }
        if let x509 {
            X509_free(x509)
        }
        PKCS12_free(p12)
    }

    public static func load(atPath path: String, password: String) throws -> Pkcs12Store {
        guard let content = FileManager.default.contents(atPath: path) else {
            throw CocoaError(.coderReadCorrupt)
        }

        return try content.withUnsafeBytes { buffer in
            var bufferPtr = buffer.bindMemory(to: UInt8.self).baseAddress

            guard let p12 = d2i_PKCS12(nil, &bufferPtr, numericCast(content.count)) else {
                throw CryptoError.internalError()
            }
            var evpKey: OpaquePointer?
            var x509: OpaquePointer?
            var ca: OpaquePointer?
            guard PKCS12_parse(p12, password, &evpKey, &x509, &ca) == 1 else {
                var errorMessage = "Undefined error"
                let errCode = ERR_get_error()
                if errCode != 0 {
                    if let errorString = ERR_error_string(errCode, nil) {
                        errorMessage = String(cString: errorString)
                    }
                }
                throw Pkcs12Error.parseError(error: errorMessage)
            }
            return Pkcs12Store(owning: p12, evpKey: evpKey, x509: x509, ca: ca)
        }
    }

    public func changePassword(_ oldPassword: String, to newPassword: String) -> Bool {
        return PKCS12_newpass(p12, oldPassword, newPassword) == 1
    }

//    private static func
}

public extension Pkcs12Store {
    var certificate: Certificate? {
        guard let x509 else {
            return nil
        }
        return try? Certificate(copying: x509)
    }

    var privateKey: PrivateKey? {
        guard let evpKey else {
            return nil
        }
        return PrivateKey(owning: evpKey)
    }

    func getCertificateChain() throws -> [Certificate] {
        var items = [Certificate]()
        guard let ca else {
            return items
        }

        let numCerts = cc_sk_X509_num(ca)
        for i in 0 ..< numCerts {
            if let x509 = cc_sk_X509_value(ca, Int32(i)) {
                let cert = try Certificate(copying: x509)
                items.append(cert)
            }
        }
        return items
    }
}
