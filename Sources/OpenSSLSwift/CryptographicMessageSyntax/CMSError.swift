public enum CMSError: Error {
    case invalidDERData
    case payloadIsEmpty
    case unsupportedTypeDecoding(oid: ObjectIdentifier)
    case failedToDetermineType
    case operationNotImplemented
    case unexpectedCMSType
}
