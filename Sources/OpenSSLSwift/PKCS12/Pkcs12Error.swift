public enum Pkcs12Error: Error {
    case invalidDERData
    case invalidPEMDocument
    case parseError(error: String)
}
