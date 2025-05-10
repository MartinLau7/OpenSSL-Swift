public enum CertificateError: Error, CustomStringConvertible {
    case invalidCertificate
    case invalidDERData
    case invalidPEMDocument
    case failedToGetSerialNumber
    case exception(mesage: String)
    case unexpectedError

    public var description: String {
        switch self {
        case .invalidCertificate:
            return "Invalid certificate"
        case .invalidDERData:
            return "Invalid DER encoding data"
        case .invalidPEMDocument:
            return "invalid PEM document"
        case let .exception(mesage):
            return "X509 Exception: \(mesage)"
        default:
            return "Unexpected Error"
        }
    }
}
