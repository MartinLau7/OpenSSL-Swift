internal import OpenSSL

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

public enum CMSContentInfo {
    case data(_ data: CMSDataContentInfo)
    case signedData(_ data: CMSSignedDataContentInfo)
    case envelopedData
    case signedAndEnvelopedData
    case digestData
    case encryptedData
    case unsupportedTypeDecoding(_ id: ObjectIdentifier)

    public var asn1Identifier: ObjectIdentifier {
        switch self {
        case .data:
            return .pkcs7_data
        case .signedData:
            return .pkcs7_signedData
        case .envelopedData:
            return .pkcs7_envelopedData
        case .signedAndEnvelopedData:
            return .pkcs7_signedAndEnvelopedData
        case .digestData:
            return .pkcs7_digestData
        case .encryptedData:
            return .pkcs7_encryptedData
        case let .unsupportedTypeDecoding(id):
            return id
        }
    }

    public var payload: CMSPayload? {
        switch self {
        case let .data(p):
            return p
        case let .signedData(p):
            return p
        case .envelopedData:
            return nil
        case .signedAndEnvelopedData:
            return nil
        case .digestData:
            return nil
        case .encryptedData:
            return nil
        case .unsupportedTypeDecoding:
            return nil
        }
    }

    public static func decode(fromDER data: Data) throws -> Self {
        guard !data.isEmpty else {
            throw CMSError.invalidDERData
        }
        let cms = try data.withReadOnlyMemoryBIO { bio in
            guard let rawCMS = d2i_CMS_bio(bio, nil) else {
                throw CryptoError.internalError()
            }
            return rawCMS
        }

        guard let asn1Object = CMS_get0_type(cms) else {
            throw CryptoError.internalError()
        }
        let objectIdentifier = try ObjectIdentifier.from(asn1Object: asn1Object)

        switch objectIdentifier {
        case .pkcs7_data:
            return .data(CMSDataContentInfo(owning: cms))
        case .pkcs7_signedData:
            return .signedData(CMSSignedDataContentInfo(owning: cms))
        default:
            return .unsupportedTypeDecoding(objectIdentifier)
        }
    }
}
