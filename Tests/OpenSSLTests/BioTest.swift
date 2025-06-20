@testable import COpenSSL
@testable import OpenSSLSwift
import Testing

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

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

    @Test func certificate() throws {
//        let appleRootDerString = "MIIEuzCCA6OgAwIBAgIBAjANBgkqhkiG9w0BAQUFADBiMQswCQYDVQQGEwJVUzETMBEGA1UEChMKQXBwbGUgSW5jLjEmMCQGA1UECxMdQXBwbGUgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxFjAUBgNVBAMTDUFwcGxlIFJvb3QgQ0EwHhcNMDYwNDI1MjE0MDM2WhcNMzUwMjA5MjE0MDM2WjBiMQswCQYDVQQGEwJVUzETMBEGA1UEChMKQXBwbGUgSW5jLjEmMCQGA1UECxMdQXBwbGUgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxFjAUBgNVBAMTDUFwcGxlIFJvb3QgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDkkakJH5HbHkdQ6wXtXnmELes2oldMVeyLGYne+Uts9QerIjAC6Bg++FAJ039BqJj50cpmnCRrEdCju+QbKsMflZ56DKRHi1vUFjczy8QPTc4UadHJGXL1XQ7Vf1+b8iUDulWPTV0N8WQ1IxVLFVkds5T39pyez1C6wVhQZ48ItCD3y6wsIG9wtj8BMIy3Q88PnT3zK0koGsj+zrW5DtleHNbLPbU6rfQPDgCSC7EhFi501TwN22IWq6NxkkdTVcGvL0Gz+PvjcM3mo0xFfh9Ma1CWQYnEdGILEINBhzOKgbEwWOxaBDKMaLOPHd5lc/9nXmW8Sdh2nzMUZaF3lMktAgMBAAGjggF6MIIBdjAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUK9BpR5R2Cf70a40uQKb3R01/CF4wHwYDVR0jBBgwFoAUK9BpR5R2Cf70a40uQKb3R01/CF4wggERBgNVHSAEggEIMIIBBDCCAQAGCSqGSIb3Y2QFATCB8jAqBggrBgEFBQcCARYeaHR0cHM6Ly93d3cuYXBwbGUuY29tL2FwcGxlY2EvMIHDBggrBgEFBQcCAjCBthqBs1JlbGlhbmNlIG9uIHRoaXMgY2VydGlmaWNhdGUgYnkgYW55IHBhcnR5IGFzc3VtZXMgYWNjZXB0YW5jZSBvZiB0aGUgdGhlbiBhcHBsaWNhYmxlIHN0YW5kYXJkIHRlcm1zIGFuZCBjb25kaXRpb25zIG9mIHVzZSwgY2VydGlmaWNhdGUgcG9saWN5IGFuZCBjZXJ0aWZpY2F0aW9uIHByYWN0aWNlIHN0YXRlbWVudHMuMA0GCSqGSIb3DQEBBQUAA4IBAQBcNplMLXi37Yyb3PN3m/J20ncwT8EfhYOFG5k9RzfyqZtAjizUsZAS2L70c5vu0mQPy3lPNNiiPvl4/2vIB+x9OYOLUyDTOMSxv5pPCmv/K/xZpwUJfBdAVhEedNO3iyM7R6PVbyTi69G3cN8PReEnyvFteO3ntRcXqNx+IjXKJdXZD9Zr1KIkIxH3oayPc4FgxhtbCS+SsvhESPBgOJ4V9T0mZyCKM2r3DYLP3uujL/lTaltkwGMzd/c6ByxW69oPIQ7aunMZT7XZNn/Bh1XZp5m5MkL72NVxnn6hUrcbvZNCJBIqxw8dtk2cXmPIS4AXUKqK1drk/NAJBzewdXUh"

        let developDerString = "MIIFwjCCBKqgAwIBAgIQEX6Xi1z8IQFSXKVFJHn8TDANBgkqhkiG9w0BAQsFADB1MUQwQgYDVQQDDDtBcHBsZSBXb3JsZHdpZGUgRGV2ZWxvcGVyIFJlbGF0aW9ucyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTELMAkGA1UECwwCRzMxEzARBgNVBAoMCkFwcGxlIEluYy4xCzAJBgNVBAYTAlVTMB4XDTIxMDkwNjA5NDYzNFoXDTIyMDkwNjA5NDYzM1owgYgxGjAYBgoJkiaJk/IsZAEBDApDTTVCWEFCVVIyMTMwMQYDVQQDDCpBcHBsZSBEZXZlbG9wbWVudDogSnVuSmllIExpdSAoMzZOMjhSNDJUQSkxEzARBgNVBAsMCko5Njg3RExXNDIxEzARBgNVBAoMCkp1bkppZSBMaXUxCzAJBgNVBAYTAlVTMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvM8FvKic5sgOgjPieC2LHLNgBsHaHSStQ6nYjObxa59atSejqSmesRP9weT1SsMVpVfOauimO1w/w2rLkrfWkOhq+BKQJVtSISzpOiZBu1FpgR9I/xcAA4zrnH5LOidM7zk2b1VvPPiUhOxgVx0wf88jxAQFhE8IMoQfEFRdquFxonQ+Q2eOnhebX1OZbbqVpQCD7W9Oo6LKvDpWZZTwexYS+ON+cFSn6KHKpa5xI6UR8SDD+QEEnF06BrVUwwhrVNhqTWqfMdNIwQZqyE+3fROYvYIRN/Ll5bnlB2OTNdy/IMUEjgFWui7SbB1CS7bvUp+xBoqmlQ9ILqlznDRllQIDAQABo4ICODCCAjQwDAYDVR0TAQH/BAIwADAfBgNVHSMEGDAWgBQJ/sAVkPmvZAqSErkmKGMMl+ynsjBwBggrBgEFBQcBAQRkMGIwLQYIKwYBBQUHMAKGIWh0dHA6Ly9jZXJ0cy5hcHBsZS5jb20vd3dkcmczLmRlcjAxBggrBgEFBQcwAYYlaHR0cDovL29jc3AuYXBwbGUuY29tL29jc3AwMy13d2RyZzMwNDCCAR4GA1UdIASCARUwggERMIIBDQYJKoZIhvdjZAUBMIH/MIHDBggrBgEFBQcCAjCBtgyBs1JlbGlhbmNlIG9uIHRoaXMgY2VydGlmaWNhdGUgYnkgYW55IHBhcnR5IGFzc3VtZXMgYWNjZXB0YW5jZSBvZiB0aGUgdGhlbiBhcHBsaWNhYmxlIHN0YW5kYXJkIHRlcm1zIGFuZCBjb25kaXRpb25zIG9mIHVzZSwgY2VydGlmaWNhdGUgcG9saWN5IGFuZCBjZXJ0aWZpY2F0aW9uIHByYWN0aWNlIHN0YXRlbWVudHMuMDcGCCsGAQUFBwIBFitodHRwczovL3d3dy5hcHBsZS5jb20vY2VydGlmaWNhdGVhdXRob3JpdHkvMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMDMB0GA1UdDgQWBBRS9D0pZ+Fm7bu3opJfBgDT2ohm5zAOBgNVHQ8BAf8EBAMCB4AwEwYKKoZIhvdjZAYBAgEB/wQCBQAwEwYKKoZIhvdjZAYBDAEB/wQCBQAwDQYJKoZIhvcNAQELBQADggEBAMmazTFgSIbP2rYg3+0ZMr1bGWpoMn4AAG9VKnFdeGW3wJ+itzgmf+zRtultgGnt2UMH5L8WvWmmyx4iArX/ReXVKRv6lhkxwdYbgen6BmPIvM8qIBpwiB/cP4yGErnVtDILYj1BCnxEQnKJoFAZYFJGIQSb7sEPGM4Gq/xoZa3NC/zJTpa1NM3moIFmoDJng+14WvoyVUVWGYsCH9NDjVnPvVo9EwOZ2NvzMDDrZo2qzNJrSN58zXnWVfFxxPeXkaXqU3WTBmaDXS7zAQ0n9/odaasfRKYxpqnALKOlNnmFWD2n24ZJFnoaEYkwsi7ShBmLXhzo+p7Z4yJvNPU9dCc="
        let ca = try Certificate.decode(FromDER: Data(base64Encoded: developDerString)!)
        if let subjectName = ca.subjectName {
            if let countryName = subjectName.attributes.first(where: { $0.type == .C }) {
                #expect(countryName.value == "US")
            }
            print("subjectName: \(subjectName.description)")
        }

        if let notValidBefore = ca.notValidBefore {
            print(notValidBefore.description(with: .current))
        }
        if let notValidAfter = ca.notValidAfter {
            print(notValidAfter.description(with: .current))
        }
//        2021-09-06 09:46:34 +0000
//        2022-09-06 09:46:33 +0000
        print("isSelfSigned: \(ca.isSelfSigned)")
    }

    private func ss() {}
}
