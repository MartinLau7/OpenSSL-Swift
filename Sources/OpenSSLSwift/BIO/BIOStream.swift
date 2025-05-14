#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

public protocol BIOStream {
    func read(count: Int) throws -> Data
    func write(_ data: Data) throws -> Int
    func flush() throws

    var pendingBytes: Int { get }
}
