public enum CMSError: Error {
    case invalidDERData
    case serializationFailed(reason: String)
    case unsupportedTypeDecoding(oid: ObjectIdentifier)
    case failedToDetermineType
    case operationNotImplemented
    case unexpectedCMSType
}
