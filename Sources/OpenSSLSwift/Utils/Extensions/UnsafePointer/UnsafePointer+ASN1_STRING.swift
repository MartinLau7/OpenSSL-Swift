#if compiler(>=6)
    internal import OpenSSL
#else
    @_implementationOnly import OpenSSL
#endif

import Foundation

extension UnsafePointer where Pointee == ASN1_GENERALIZEDTIME {
    // When handling ASN1_TIME, we always assume the format MMM DD HH:MM:SS YYYY [GMT]
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "yyyyMMddHHmmssZ"
        return dateFormatter
    }()

    func asFoundationDate() -> Date? {
        let data = Data(bytes: pointee.data, count: Int(pointee.length))
        guard let timeString = String(data: data, encoding: .ascii) else {
            return nil
        }
        return Self.dateFormatter.date(from: timeString)
    }
}

extension UnsafeMutablePointer where Pointee == ASN1_GENERALIZEDTIME {
    // When handling ASN1_TIME, we always assume the format MMM DD HH:MM:SS YYYY [GMT]
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "yyyyMMddHHmmssZ"
        return dateFormatter
    }()

    func asFoundationDate() -> Date? {
        let data = Data(bytes: pointee.data, count: Int(pointee.length))
        guard let timeString = String(data: data, encoding: .ascii) else {
            return nil
        }
        return Self.dateFormatter.date(from: timeString)
    }
}
