public extension Certificate {
    // TODO: 参考 https://github.com/apple/swift-crypto/blob/3ef6559/Sources/_CryptoExtras/Util/CryptoKitErrors_boring.swift 进行改进
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
