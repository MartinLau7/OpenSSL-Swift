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

public final class Certificate: BIOLoadable {
    /// (Incomplete collection of) signature algorithm types of `X.509` certificates.
    public enum SignatureAlgorithm {
        /// ECDSA with SHA 256
        case ecdsaWithSHA256
        /// RSA with SHA 256 and MGF1
        case sha256WithRsaEncryption
        /// Not supported by this class
        case unsupported
    }

    let x509: OpaquePointer

    public init(owning x509: OpaquePointer) throws {
        guard X509_up_ref(x509) == 1 else {
            throw CertificateError.invalidCertificate
        }
        self.x509 = x509
    }

    public init(der: Data) throws {
        x509 = try der.withUnsafeBytes { derBytes in
            var derDataPtr = derBytes.bindMemory(to: UInt8.self).baseAddress
            guard let rawX509 = d2i_X509(nil, &derDataPtr, numericCast(der.count)) else {
                throw CertificateError.invalidDERData
            }
            return rawX509
        }
    }

    public init(pem: Data) throws {
        x509 = try Self.load(buffer: pem) { bio in
            PEM_read_bio_X509(bio, nil, nil, nil)
        }
    }

    /// De-initialize
    deinit {
        X509_free(x509)
    }

    public func serialNumberData() throws -> Data {
        return try withSerialNumber { bn in
            let bn_len = (BN_num_bits(bn) + 7) / 8
            let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(bn_len))
            defer { ptr.deallocate() }
            let leafSerialNumberSize = BN_bn2bin(bn, ptr)
            let leafSerialNumberBytes = [UInt8](UnsafeMutableBufferPointer(start: ptr, count: Int(leafSerialNumberSize)))
            return Data(leafSerialNumberBytes)
        }
    }

    private func withSerialNumber<T>(_ closure: (OpaquePointer) throws -> T) throws -> T {
        guard let serial = X509_get0_serialNumber(x509), let bn = ASN1_INTEGER_to_BN(serial, nil) else {
            throw CertificateError.failedToGetSerialNumber
        }
        defer {
            BN_clear_free(bn)
        }
        return try closure(bn)
    }

    private func withDistinguishedName() throws {}
}

public extension Certificate {
    var version: Int {
        return X509_get_version(x509) + 1
    }

    var issuerName: DistinguishedName {
        DistinguishedName(X509_get_issuer_name(x509))
    }

    var subjectName: DistinguishedName {
        DistinguishedName(X509_get_subject_name(x509))
    }

    var issuerNameHash: UInt {
        return X509_issuer_name_hash(x509)
    }

    var subjectNameHash: UInt {
        return X509_subject_name_hash(x509)
    }

    var serialNumber: String {
        return (try? withSerialNumber { bn in
            guard let hex = BN_bn2hex(bn) else { return "" }
            return String(cString: hex)
        }) ?? ""
    }

    var notBefore: Date? {
        guard let notBefore = X509_get0_notBefore(x509) else {
            return nil
        }
        return notBefore.asGeneralizedDate()
    }

    var notAfter: Date? {
        guard let notBefore = X509_get0_notAfter(x509) else {
            return nil
        }
        return notBefore.asGeneralizedDate()
    }

    /// Returns the signature algorithm that validates this certificate
    ///
    /// - Returns: `SignatureAlgorithm`
    var signatureAlgorithm: SignatureAlgorithm {
        switch X509_get_signature_nid(x509) {
        case NID_ecdsa_with_SHA256: return .ecdsaWithSHA256
        case NID_sha256WithRSAEncryption: return .sha256WithRsaEncryption
        default: return .unsupported
        }
    }
}
