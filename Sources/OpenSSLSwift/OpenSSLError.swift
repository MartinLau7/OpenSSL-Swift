internal import OpenSSL

public struct OpenSSLError: Sendable {
    private(set) var code: UInt
    private(set) var reason: String

    static func readLastError() -> OpenSSLError? {
        let errorCode = ERR_peek_last_error()
        guard errorCode != 0 else { return nil }

        var buffer = [CChar](repeating: 0, count: 256)
        ERR_error_string_n(errorCode, &buffer, buffer.count)
        let errorMessage = String(utf8String: buffer) ?? "Unknown error"
        return OpenSSLError(code: errorCode, reason: errorMessage)
    }

    static func readError() -> OpenSSLError? {
        let errorCode = ERR_get_error()
        guard errorCode != 0 else { return nil }

        var buffer = [CChar](repeating: 0, count: 256)
        ERR_error_string_n(errorCode, &buffer, buffer.count)
        let errorMessage = String(utf8String: buffer) ?? "Unknown error"
        return OpenSSLError(code: errorCode, reason: errorMessage)
    }
}
