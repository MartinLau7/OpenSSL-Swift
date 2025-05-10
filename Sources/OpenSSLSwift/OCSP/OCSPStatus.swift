#if compiler(>=6)
    internal import OpenSSL
#else
    @_implementationOnly import OpenSSL
#endif

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

public struct OCSPStatus: Codable {
    public enum CertState: Int32, Codable {
        case good = 0
        case revoked = 1
        case unknown = 2
        case requestedCertificateNotInResponse = 99
    }

    var certStatus: CertState
    var reason: Int32
    var serialNumber: String

    var isExpired = false
    var thisUpdateDate: Date?
    var nextUpdateDate: Date?
    var revocationDate: Date?

    init(certStatus: CertState, reason: Int32, serialNumber: String = "", isExpired: Bool = false, thisUpdate: Date? = nil, nextUpdate: Date? = nil, revocationAt: Date? = nil) {
        self.certStatus = certStatus
        self.serialNumber = serialNumber
        self.reason = reason

        self.isExpired = isExpired
        thisUpdateDate = thisUpdate
        nextUpdateDate = nextUpdate
        revocationDate = revocationAt
    }
}
