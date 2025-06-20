internal import COpenSSL

public struct DistinguishedName: CustomStringConvertible {
    typealias X509Name = OpaquePointer

    private let x509Name: X509Name

    public struct RelativeDistinguishedName: CustomStringConvertible {
        public let type: ObjectIdentifier
        public let value: String

        public var description: String {
            if !type.shortName.isEmpty {
                return "\(type.shortName)=\(value)"
            } else if !type.longName.isEmpty {
                return "\(type.longName)=\(value)"
            } else {
                return "\(type.rawValue)=\(value)"
            }
        }
    }

    public var attributes: [RelativeDistinguishedName] = []

    public var hash: UInt {
        return cc_X509_NAME_hash(x509Name)
    }

    public var description: String {
        if attributes.isEmpty {
            guard let name = X509_NAME_oneline(x509Name, nil, 0) else { return "" }
            defer {
                free(name)
            }
            return String(cString: name)
        }
        return attributes.map { $0.description }
            .joined(separator: ", ")
    }

    init(_ name: X509Name) {
        let entryCount = X509_NAME_entry_count(name)
        for i in 0 ..< entryCount {
            guard let entry = X509_NAME_get_entry(name, i) else {
                continue
            }

            let oid = X509_NAME_ENTRY_get_object(entry)
            let asn1_str = X509_NAME_ENTRY_get_data(entry)
            let len = OBJ_obj2txt(nil, 0, oid, 1)
            guard len > 0 else {
                continue
            }

            let bufferSize = Int(len) + 1
            let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: bufferSize)
            defer {
                buffer.deallocate()
            }
            buffer.initialize(repeating: 0, count: bufferSize)
            guard OBJ_obj2txt(buffer, len + 1, oid, 1) >= 0 else {
                continue
            }

            let oidRawValue = String(cString: buffer)
            var encodedName: UnsafeMutablePointer<UInt8>? = nil
            let stringLength = ASN1_STRING_to_UTF8(&encodedName, asn1_str)
            defer {
                encodedName?.deallocate()
            }
            let entryNameValue = String(bytes: UnsafeBufferPointer(start: encodedName, count: numericCast(stringLength)), encoding: .utf8) ?? ""
            attributes.append(RelativeDistinguishedName(type: ObjectIdentifier(rawValue: oidRawValue), value: entryNameValue))
        }
        x509Name = name
    }
}
