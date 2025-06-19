internal import COpenSSL

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

extension UnsafePointer where Pointee == ASN1_STRING {
    func asFoundationString(encoding: String.Encoding = .utf8) -> String? {
        let data = Data(bytes: pointee.data, count: Int(pointee.length))
        return String(data: data, encoding: encoding)
    }
}

extension UnsafeMutablePointer where Pointee == ASN1_STRING {
    func asFoundationString(encoding: String.Encoding = .utf8) -> String? {
        let data = Data(bytes: pointee.data, count: Int(pointee.length))
        return String(data: data, encoding: encoding)
    }
}
