//
//  Attributes.swift
//  OpenSSL-Swift
//
//  Created by 𝗠𝗮𝗿𝘁𝗶𝗻 𝗟𝗮𝘂 on 2025-06-20.
//

public extension ObjectIdentifier {
    static let CN = ObjectIdentifier(rawValue: "2.5.4.3", shortName: "CN", longName: "commonName")
    static let SN = ObjectIdentifier(rawValue: "2.5.4.4", shortName: "SN", longName: "surname")
    static let serialNumber = ObjectIdentifier(rawValue: "2.5.4.5", shortName: "serialNumber")
    static let C = ObjectIdentifier(rawValue: "2.5.4.6", shortName: "C", longName: "countryName")
    static let L = ObjectIdentifier(rawValue: "2.5.4.7", shortName: "L", longName: "localityName")
    static let ST = ObjectIdentifier(rawValue: "2.5.4.8", shortName: "ST", longName: "stateOrProvinceName")
    static let street = ObjectIdentifier(rawValue: "2.5.4.9", shortName: "street", longName: "streetAddress")
    static let O = ObjectIdentifier(rawValue: "2.5.4.10", shortName: "O", longName: "organizationName")
    static let OU = ObjectIdentifier(rawValue: "2.5.4.11", shortName: "OU", longName: "organizationalUnitName")
    static let title = ObjectIdentifier(rawValue: "2.5.4.12", shortName: "title", longName: "title")
    static let description = ObjectIdentifier(rawValue: "2.5.4.13", shortName: "description", longName: "description")
    static let postalCode = ObjectIdentifier(rawValue: "2.5.4.17", shortName: "postalCode")
}
