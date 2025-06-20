//
//  Algorithm.swift
//  OpenSSL-Swift
//
//  Created by 𝗠𝗮𝗿𝘁𝗶𝗻 𝗟𝗮𝘂 on 2025-06-20.
//

public extension ObjectIdentifier {
    static let RSA_SM3 = ObjectIdentifier(rawValue: "1.2.156.10197.1.504", shortName: "RSA-SM3", longName: "sm3WithRSAEncryption")
    static let id_ecPublicKey = ObjectIdentifier(rawValue: "1.2.840.10045.2.1", shortName: "id-ecPublicKey")

    static let MD2 = ObjectIdentifier(rawValue: "1.2.840.113549.2.2", shortName: "MD2", longName: "md2")
    static let MD5 = ObjectIdentifier(rawValue: "1.2.840.113549.2.5", shortName: "MD5", longName: "md5")
    static let RC4 = ObjectIdentifier(rawValue: "1.2.840.113549.3.4", shortName: "RC4", longName: "rc4")
    static let DSA = ObjectIdentifier(rawValue: "1.2.840.10040.4.1", shortName: "DSA", longName: "dsaEncryption")

    static let shaWithRSAEncryption = ObjectIdentifier(rawValue: "1.3.14.3.2.15", shortName: "RSA-SHA", longName: "shaWithRSAEncryption")
    static let rsaEncryption = ObjectIdentifier(rawValue: "1.2.840.113549.1.1.1", shortName: "rsaEncryption")
    static let md2WithRSAEncryption = ObjectIdentifier(rawValue: "1.2.840.113549.1.1.2", shortName: "RSA-MD2", longName: "md2WithRSAEncryption")
    static let RSA_MD4 = ObjectIdentifier(rawValue: "1.2.840.113549.1.1.3", shortName: "RSA-MD4", longName: "md4WithRSAEncryption")
    static let md5WithRSAEncryption = ObjectIdentifier(rawValue: "1.2.840.113549.1.1.4", shortName: "RSA-MD5", longName: "md5WithRSAEncryption")
    static let sha1WithRSAEncryption = ObjectIdentifier(rawValue: "1.2.840.113549.1.1.5", shortName: "RSA-SHA1", longName: "sha1WithRSAEncryption")
    static let sha256WithRSAEncryption = ObjectIdentifier(rawValue: "1.2.840.113549.1.1.11", shortName: "RSA-SHA256", longName: "sha256WithRSAEncryption")
    static let sha384WithRSAEncryption = ObjectIdentifier(rawValue: "1.2.840.113549.1.1.12", shortName: "RSA-SHA384", longName: "sha384WithRSAEncryption")
    static let sha512WithRSAEncryption = ObjectIdentifier(rawValue: "1.2.840.113549.1.1.13", shortName: "RSA-SHA512", longName: "sha512WithRSAEncryption")
    static let sha224WithRSAEncryption = ObjectIdentifier(rawValue: "1.2.840.113549.1.1.14", shortName: "RSA-SHA224", longName: "sha224WithRSAEncryption")
    static let RSA_SHA512_224 = ObjectIdentifier(rawValue: "1.2.840.113549.1.1.15", shortName: "RSA-SHA512/224", longName: "sha512-224WithRSAEncryption")
    static let RSA_SHA512_256 = ObjectIdentifier(rawValue: "1.2.840.113549.1.1.16", shortName: "RSA-SHA512/256", longName: "sha512-256WithRSAEncryption")

    static let hmacWithSHA512_224 = ObjectIdentifier(rawValue: "1.2.840.113549.2.12", shortName: "hmacWithSHA512-224")
    static let hmacWithSHA512_256 = ObjectIdentifier(rawValue: "1.2.840.113549.2.13", shortName: "hmacWithSHA512-256")
}
