internal import OpenSSL

public struct ObjectIdentifier: RawRepresentable, Sendable, Hashable {
    public typealias RawValue = String

    public let rawValue: String
    public let shortName: String
    public let longName: String

    public var numericId: Int32 {
        Self.numericIdentifier(for: rawValue)
    }

    public init(rawValue: String) {
        self.rawValue = rawValue
        self.shortName = Self.shortName(for: rawValue)
        self.longName = Self.longName(for: rawValue)
    }

    public init(rawValue: String, shortName: String? = nil, longName: String? = nil) {
        self.rawValue = rawValue
        self.shortName = shortName ?? Self.shortName(for: rawValue)
        self.longName = longName ?? Self.longName(for: rawValue)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }

    private static func shortName(for oid: String) -> String {
        let numericId = numericIdentifier(for: oid)
        guard numericId != NID_undef, let sn = OBJ_nid2sn(numericId) else {
            return ""
        }
        return String(cString: sn)
    }

    private static func longName(for oid: String) -> String {
        let numericId = numericIdentifier(for: oid)
        guard numericId != NID_undef, let ln = OBJ_nid2ln(numericId) else {
            return ""
        }
        return String(cString: ln)
    }

    private static func numericIdentifier(for oid: String) -> Int32 {
        guard let obj = asn1Object(from: oid) else {
            return NID_undef
        }
        defer {
            ASN1_OBJECT_free(obj)
        }
        return OBJ_obj2nid(obj)
    }

    private static func asn1Object(from oid: String) -> OpaquePointer? {
        let encodedLength = a2d_ASN1_OBJECT(nil, 0, oid, -1)
        guard encodedLength > 0 else {
            return nil
        }
        return OBJ_txt2obj(oid, 1)
    }
}
