//
//  CMSVersion.swift
//  OpenSSL-Swift
//
//  Created by 𝗠𝗮𝗿𝘁𝗶𝗻 𝗟𝗮𝘂 on 2025-06-23.
//

/// ``CMS.Version`` is defined in ASN1. as:
/// ```
///  CMS.Version ::= INTEGER
///                 { v0(0), v1(1), v2(2), v3(3), v4(4), v5(5) }
/// ```
public struct CMSVersion {
    @usableFromInline
    var rawValue: Int

    @usableFromInline
    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let v0 = Self(rawValue: 0)
    public static let v1 = Self(rawValue: 1)
    public static let v2 = Self(rawValue: 2)
    public static let v3 = Self(rawValue: 3)
    public static let v4 = Self(rawValue: 4)
    public static let v5 = Self(rawValue: 5)
}

extension CMSVersion: Hashable {}

extension CMSVersion: Sendable {}

extension CMSVersion: Comparable {
    @inlinable
    public static func < (lhs: CMSVersion, rhs: CMSVersion) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension CMSVersion: CustomStringConvertible {
    public var description: String {
        "CMSv\(rawValue)"
    }
}
