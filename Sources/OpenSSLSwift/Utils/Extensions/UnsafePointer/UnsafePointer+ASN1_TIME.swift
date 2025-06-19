internal import COpenSSL

import Foundation

extension UnsafePointer where Pointee == ASN1_TIME {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "yyyyMMddHHmmssZ"
        return dateFormatter
    }()

    func asGeneralizedDate() -> Date? {
        var _generalizedTimePtr: UnsafeMutablePointer<ASN1_GENERALIZEDTIME>?
        ASN1_TIME_to_generalizedtime(self, &_generalizedTimePtr)
        guard let generalizedTimePtr = _generalizedTimePtr else { return nil }
        defer { ASN1_GENERALIZEDTIME_free(generalizedTimePtr) }

        let data = Data(bytes: pointee.data, count: Int(pointee.length))
        guard let timeString = String(data: data, encoding: .ascii) else {
            return nil
        }
        return Self.dateFormatter.date(from: timeString)
    }
}
