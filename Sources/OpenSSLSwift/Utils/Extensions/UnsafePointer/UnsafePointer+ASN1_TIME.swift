internal import COpenSSL

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

extension UnsafePointer where Pointee == ASN1_TIME {
    func asGeneralizedDate() -> Date? {
        var _generalizedTimePtr: UnsafeMutablePointer<ASN1_GENERALIZEDTIME>?
        ASN1_TIME_to_generalizedtime(self, &_generalizedTimePtr)
        guard let generalizedTimePtr = _generalizedTimePtr else { return nil }
        defer { ASN1_GENERALIZEDTIME_free(generalizedTimePtr) }
        
        let data = Data(bytes: generalizedTimePtr.pointee.data, count: Int(generalizedTimePtr.pointee.length))
        guard let timeString = String(data: data, encoding: .ascii) else {
            return nil
        }
        
        // ASN1_GENERALIZEDTIME 格式預期為：yyyyMMddHHmmssZ
        guard timeString.count >= 15 else {
            return nil
        }
        
        let year = Int(timeString.prefix(4))
        let month = Int(timeString.dropFirst(4).prefix(2))
        let day = Int(timeString.dropFirst(6).prefix(2))
        let hour = Int(timeString.dropFirst(8).prefix(2))
        let minute = Int(timeString.dropFirst(10).prefix(2))
        let second = Int(timeString.dropFirst(12).prefix(2))
        
        guard let y = year, let m = month, let d = day,
              let h = hour, let min = minute, let s = second
        else {
            return nil
        }
        
        var dateComponents = DateComponents()
        dateComponents.year = y
        dateComponents.month = m
        dateComponents.day = d
        dateComponents.hour = h
        dateComponents.minute = min
        dateComponents.second = s
        dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
        return Calendar(identifier: .gregorian).date(from: dateComponents)
    }
}
