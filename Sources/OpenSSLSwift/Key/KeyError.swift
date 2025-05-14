public enum KeyError: Error {
    case keyLoadFailed(String)
    case keyExportFailed(String)
    case keyGenerationFailed(String)
    case keyConversionFailed(String)
    case keyOperationFailed(String)
    case unsupportedKeyType(String)

    case exception(OpenSSLError)
    case exceptionWithMessage(String)
}
