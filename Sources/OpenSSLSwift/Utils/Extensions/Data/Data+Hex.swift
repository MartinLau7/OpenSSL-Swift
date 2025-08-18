#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

extension DataProtocol {
    func hexEncodedString(uppercase: Bool = false, separator: String = "") -> String {
        return map {
            if $0 < 16 {
                return "0" + String($0, radix: 16, uppercase: uppercase)
            } else {
                return String($0, radix: 16, uppercase: uppercase)
            }
        }.joined(separator: separator)
    }
}
