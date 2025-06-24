public extension Certificate {
    enum CertificateError: Error, CustomStringConvertible {
        case invalidDERData
        case invalidPEMDocument

        case unexpectedError

        public var description: String {
            switch self {
            case .invalidDERData:
                return "Invalid DER encoding data"
            case .invalidPEMDocument:
                return "invalid PEM document"
            default:
                return "Unexpected Error"
            }
        }
    }
}
