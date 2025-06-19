internal import COpenSSL

public struct DistinguishedName: CustomStringConvertible {
    typealias X509Name = OpaquePointer

    let x509Name: X509Name

    init(_ name: X509Name) {
        x509Name = name
    }

    public var commonName: String? {
        readEntryName(with: .CN)
    }

    public var countryName: String? {
        readEntryName(with: .C)
    }

    public var localityName: String? {
        readEntryName(with: .L)
    }

    public var stateOrProvinceName: String? {
        readEntryName(with: .ST)
    }

    public var organizationName: String? {
        readEntryName(with: .O)
    }

    public var organizationalUnitName: String? {
        readEntryName(with: .OU)
    }

    public var streetAddress: String? {
        readEntryName(with: .street)
    }

    public var hash: UInt {
        return cc_X509_NAME_hash(x509Name)
    }

    public var description: String {
        guard let name = X509_NAME_oneline(x509Name, nil, 0) else { return "" }
        defer {
            free(name)
        }
        return String(cString: name)
    }

    private func readEntryName(with oid: OId) -> String {
        guard let oid = OBJ_txt2obj(oid.oId, 1) else {
            return ""
        }

        var lastpos: Int32 = -1
        lastpos = X509_NAME_get_index_by_OBJ(x509Name, oid, lastpos)
        guard lastpos != -1 && lastpos != -2 else {
            return ""
        }

        let entry = X509_NAME_get_entry(x509Name, lastpos)
        let asn1_str = X509_NAME_ENTRY_get_data(entry)
        var encodedName: UnsafeMutablePointer<UInt8>? = nil
        let stringLength = ASN1_STRING_to_UTF8(&encodedName, asn1_str)
        defer {
            encodedName?.deallocate()
        }
        return String(bytes: UnsafeBufferPointer(start: encodedName, count: numericCast(stringLength)), encoding: .utf8) ?? ""
    }
}
