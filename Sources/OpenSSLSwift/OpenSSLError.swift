internal import OpenSSL

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

public enum CryptoError: Error {
    case outOfMemory
    case nidUndefined
    case unspecifiedError
    case cryptographicError(ex: CryptoErrorException)

    static func internalError() -> Self {
        #if DEBUG
            return readError(useFullMessage: true)
        #else
            return readError(useFullMessage: false)
        #endif
    }

    private static func readError(useFullMessage: Bool = false) -> Self {
        let errorCode = ERR_get_error()
        guard errorCode != 0 else { return .unspecifiedError }

        let shortReason = opensslErrorReason(for: errorCode)
        let fullMessage = useFullMessage ? opensslFullErrorMessage(for: errorCode) : nil

        return CryptoError.cryptographicError(
            ex: CryptoErrorException(code: errorCode, reason: shortReason, fullMessage: fullMessage)
        )
    }

    private static func opensslErrorReason(for errorCode: UInt) -> String? {
        guard errorCode != 0 else { return nil }
        guard let cStr = ERR_reason_error_string(errorCode) else {
            return nil
        }
        return String(cString: cStr)
    }

    private static func opensslFullErrorMessage(for errorCode: UInt, bufferSize: Int = 1024) -> String? {
        guard errorCode != 0 else { return nil }

        var buffer = [CChar](repeating: 0, count: bufferSize)
        ERR_error_string_n(errorCode, &buffer, buffer.count)
        return String(cString: buffer, encoding: .utf8)
    }
}

public struct CryptoErrorException: Sendable, CustomStringConvertible, CustomDebugStringConvertible {
    public private(set) var code: UInt
    public private(set) var reason: String?
    public private(set) var fullMessage: String?

    public var description: String {
        reason ?? "Unknown OpenSSL error (code: \(code))"
    }

    public var debugDescription: String {
        fullMessage ?? description
    }

    public var localizedDescription: String {
        description
    }

    public init(code: UInt, reason: String?, fullMessage: String? = nil) {
        self.code = code
        self.reason = reason
        self.fullMessage = fullMessage
    }
}

extension CryptoError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .outOfMemory:
            "Insufficient memory to continue the execution of the program."

        case let .cryptographicError(ex):
            ex.reason ?? "Unknown OpenSSL error (code: \(ex.code))"

        default:
            "Unspecified error"
        }
    }
}
