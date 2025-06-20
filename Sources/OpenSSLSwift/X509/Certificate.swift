internal import OpenSSL

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

public final class Certificate {
    let x509: OpaquePointer

    public init(owning x509: OpaquePointer) throws {
        self.x509 = x509
    }

    public init(copying x509: OpaquePointer) throws {
        guard X509_up_ref(x509) == 1 else {
            throw CryptoError.internalError()
        }
        self.x509 = x509
    }

    public static func decode(FromDER data: Data) throws -> Self {
        guard !data.isEmpty else {
            throw CertificateError.invalidDERData
        }

        let x509 = try data.withUnsafeBytes { pointer in
            var buffer = pointer.bindMemory(to: UInt8.self).baseAddress
            guard let rawX509 = d2i_X509(nil, &buffer, numericCast(data.count)) else {
                throw CryptoError.internalError()
            }
            return rawX509
        }
        return try Self(owning: x509)
    }

    public static func decode(FromPEM data: Data) throws -> Self {
        guard !data.isEmpty else {
            throw CertificateError.invalidPEMDocument
        }

        let x509 = try data.withReadOnlyMemoryBIO { bio in
            guard let x509 = PEM_read_bio_X509(bio, nil, nil, nil) else {
                throw CryptoError.internalError()
            }
            return x509
        }
        return try Self(owning: x509)
    }

    /// De-initialize
    deinit {
        X509_free(x509)
    }

    public func serialNumberAsHexString() throws -> String {
        return try withSerialNumber { bn in
            bn.hexString
        }
    }

    public func serialNumberAsDecimalString() throws -> String {
        return try withSerialNumber { bn in
            bn.decimalString
        }
    }

    public func serialNumberAsBytes() throws -> [UInt8] {
        return try withSerialNumber { bn in
            bn.rawBytes
        }
    }

    private func withSerialNumber<T>(_ closure: (BigNumber) throws -> T) throws -> T {
        guard let serial = X509_get0_serialNumber(x509), let bn = ASN1_INTEGER_to_BN(serial, nil) else {
            throw CryptoError.internalError()
        }
        defer { BN_free(bn) }
        return try closure(BigNumber(copying: bn))
    }
}

public extension Certificate {
    var version: Version {
        return Version(rawValue: X509_get_version(x509))
    }

    var issuerName: DistinguishedName? {
        guard let x509Name = X509_get_issuer_name(x509) else {
            return nil
        }
        return DistinguishedName(x509Name)
    }

    var subjectName: DistinguishedName? {
        guard let x509Name = X509_get_subject_name(x509) else {
            return nil
        }
        return DistinguishedName(x509Name)
    }

    var isSelfSigned: Bool {
        X509_NAME_cmp(X509_get_subject_name(x509), X509_get_issuer_name(x509)) == 0
    }

    /// The date before which this certificate is not valid.
    var notValidBefore: Date? {
        guard let notBefore = X509_get0_notBefore(x509) else {
            return nil
        }
        return notBefore.asGeneralizedDate()
    }

    /// The date after which this certificate is not valid.
    var notValidAfter: Date? {
        guard let notBefore = X509_get0_notAfter(x509) else {
            return nil
        }
        return notBefore.asGeneralizedDate()
    }
}
