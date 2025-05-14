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

public final class Pkcs12Store {
    let p12: OpaquePointer
    var privateKey: OpaquePointer?
    var x509: OpaquePointer?

    public init(owning p12: OpaquePointer) {
        self.p12 = p12
    }

    public init(der: Data, password: String? = nil) throws {
        p12 = try der.withUnsafeBytes { derBytes in
            var derDataPtr = derBytes.bindMemory(to: UInt8.self).baseAddress

            guard let p12 = d2i_PKCS12(nil, &derDataPtr, numericCast(der.count)) else {
                throw Pkcs12Error.invalidDERData
            }
            return p12
        }

        guard PKCS12_parse(p12, password, &privateKey, &x509, nil) == 1 else {
            var errorMessage = "Undefined error"
            let errCode = ERR_get_error()
            if errCode != 0 {
                if let errorString = ERR_error_string(errCode, nil) {
                    errorMessage = String(cString: errorString)
                }
            }
            throw Pkcs12Error.parseError(error: errorMessage)
        }
    }

    public convenience init(contentof url: URL, password: String? = nil) throws {
        let data = try Data(contentsOf: url)
        try self.init(der: data, password: password)
    }

    deinit {
        EVP_PKEY_free(privateKey)
        PKCS12_free(p12)
    }

    public var certificate: Certificate? {
        guard let x509 else {
            return nil
        }
        return try? Certificate(owning: x509)
    }

    public func changePassword(_ old: String, to newPassword: String) -> Bool {
        return PKCS12_newpass(p12, old, newPassword) == 1
    }
}
