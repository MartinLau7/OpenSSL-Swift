@testable import OpenSSLSwift
import Test

@Suite("BIO Tests")
final class BIOTests {
    // @Test("BIO Creation and Data I/O")
    // func testBIOCreation() async throws {
    //     // 创建一个新的内存 BIO
    //     let bio = BIO.createMemoryBIO()
    //     try AssertNotNil(bio, "BIO creation failed")

    //     // 写入数据到 BIO
    //     let data = "Hello, OpenSSL!"
    //     let written = BIO.write(to: bio, data: data)
    //     try AssertTrue(written > 0, "Failed to write data to BIO")

    //     // 读取数据从 BIO
    //     var buffer = [CChar](repeating: 0, count: 1024)
    //     let read = BIO.read(from: bio, buffer: &buffer, size: Int32(buffer.count))
    //     try AssertTrue(read > 0, "Failed to read data from BIO")

    //     // 验证读取的数据是否与写入的数据一致
    //     let result = String(cString: buffer)
    //     try AssertEqual(result, data, "Data mismatch after reading from BIO")

    //     // 释放 BIO
    //     BIO.free(bio)
    // }

    private func ss() {}
}
