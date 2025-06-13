internal import OpenSSL
internal import COpenSSL

typealias X509Name = OpaquePointer

public final class DistinguishedName: CustomStringConvertible {
    public struct NameIdentifier: Sendable {
        let value: Int32

        init(_ value: Int32) {
            self.value = value
        }

        static let commonName = NameIdentifier(NID_commonName)
        static let countryName = NameIdentifier(NID_countryName)
        static let localityName = NameIdentifier(NID_localityName)
        static let stateOrProvinceName = NameIdentifier(NID_stateOrProvinceName)
        static let organizationName = NameIdentifier(NID_organizationName)
        static let organizationalUnitName = NameIdentifier(NID_organizationalUnitName)
        static let streetAddress = NameIdentifier(NID_streetAddress)
    }

    let x509Name: X509Name

    init(_ name: X509Name) {
        x509Name = name
    }

    deinit {
        // X509_NAME_free(x509Name)
    }

    private func readEntryName(with nid: NameIdentifier) -> String? {
        var lastpos: Int32 = -1
        lastpos = X509_NAME_get_index_by_NID(x509Name, nid.value, lastpos)
        guard lastpos != -1 && lastpos != -2 else {
            return nil
        }

        let entry = X509_NAME_get_entry(x509Name, lastpos)
        let asn1_str = X509_NAME_ENTRY_get_data(entry)
        var encodedName: UnsafeMutablePointer<UInt8>? = nil
        let stringLength = ASN1_STRING_to_UTF8(&encodedName, asn1_str)
        guard let namePointer = encodedName else { return nil }
        defer { namePointer.deallocate() }
        return String(bytes: UnsafeBufferPointer(start: namePointer, count: numericCast(stringLength)), encoding: .utf8)
    }

    public var commonName: String? {
        readEntryName(with: .commonName)
    }

    public var countryName: String? {
        readEntryName(with: .countryName)
    }

    public var localityName: String? {
        readEntryName(with: .localityName)
    }

    public var stateOrProvinceName: String? {
        readEntryName(with: .stateOrProvinceName)
    }

    public var organizationName: String? {
        readEntryName(with: .organizationName)
    }

    public var organizationalUnitName: String? {
        readEntryName(with: .organizationalUnitName)
    }

    public var streetAddress: String? {
        readEntryName(with: .streetAddress)
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
}
