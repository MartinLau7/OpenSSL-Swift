public extension Bio {
    enum FileMode: String {
        case read = "rb"
        case write = "wb"
        case append = "ab"
        case readWrite = "rb+"
        case readWriteTruncate = "wb+"
        case readWriteAppend = "ab+"
    }
}
