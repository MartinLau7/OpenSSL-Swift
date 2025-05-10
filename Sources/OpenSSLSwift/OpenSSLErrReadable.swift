#if compiler(>=6)
    internal import OpenSSL
#else
    @_implementationOnly import OpenSSL
#endif

public protocol OpenSSLErrReadable {}

extension OpenSSLErrReadable {
    func readError() -> (errCode: UInt, errorDescription: String)? {
        let errCode = ERR_peek_last_error()
        defer {
            ERR_clear_error()
        }
        if errCode != 0 {
            if let errorDescription = ERR_error_string(errCode, nil) {
                return (errCode, String(cString: errorDescription))
            }
        }
        return nil
    }
}
