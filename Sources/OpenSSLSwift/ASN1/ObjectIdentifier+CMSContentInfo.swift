//
//  ObjectIdentifier+CMSContentInfo.swift
//  OpenSSL-Swift
//
//  Created by 𝗠𝗮𝗿𝘁𝗶𝗻 𝗟𝗮𝘂 on 2025-06-23.
//

public extension ObjectIdentifier {
    static let pkcs7 = ObjectIdentifier(rawValue: "1.2.840.113549.1.7", shortName: "pkcs7")

    static let pkcs7_data = ObjectIdentifier(rawValue: "1.2.840.113549.1.7.1", shortName: "pkcs7-data")

    static let pkcs7_signedData = ObjectIdentifier(rawValue: "1.2.840.113549.1.7.2", shortName: "pkcs7-signedData")

    static let pkcs7_envelopedData = ObjectIdentifier(rawValue: "1.2.840.113549.1.7.3", shortName: "pkcs7-envelopedData")

    static let pkcs7_signedAndEnvelopedData = ObjectIdentifier(rawValue: "1.2.840.113549.1.7.4", shortName: "pkcs7-signedAndEnvelopedData")

    static let pkcs7_digestData = ObjectIdentifier(rawValue: "1.2.840.113549.1.7.5", shortName: "pkcs7-digestData")

    static let pkcs7_encryptedData = ObjectIdentifier(rawValue: "1.2.840.113549.1.7.6", shortName: "pkcs7-encryptedData")
}
