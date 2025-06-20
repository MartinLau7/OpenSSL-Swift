//
//  CertificateVersion.swift
//  OpenSSL-Swift
//
//  Created by 𝗠𝗮𝗿𝘁𝗶𝗻 𝗟𝗮𝘂 on 2025-06-21.
//

public extension Certificate {
    /// The X.509 certificate version.
    struct Version {
        @usableFromInline
        var rawValue: Int

        @usableFromInline
        init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Corresponds to an X.509 v1 certificate.
        public static let v1 = Self(rawValue: 0)

        /// Corresponds to an X.509 v2 certificate.
        public static let v2 = Self(rawValue: 1)

        /// Corresponds to an X.509 v3 certificate
        public static let v3 = Self(rawValue: 2)
    }
}

extension Certificate.Version: Hashable {}

extension Certificate.Version: Sendable {}

extension Certificate.Version: Comparable {
    @inlinable
    public static func < (lhs: Certificate.Version, rhs: Certificate.Version) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension Certificate.Version: CustomStringConvertible {
    public var description: String {
        switch self {
            case .v1:
                return "X509v1"
            case .v2:
                return "X509v2"
            case .v3:
                return "X509v3"
            case let unknown:
                return "X509v\(unknown.rawValue + 1)"
        }
    }
}
