@testable import COpenSSL
@testable import OpenSSLSwift
import Testing

import Foundation

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
        let appleRootDerString = "MIIEuzCCA6OgAwIBAgIBAjANBgkqhkiG9w0BAQUFADBiMQswCQYDVQQGEwJVUzETMBEGA1UEChMKQXBwbGUgSW5jLjEmMCQGA1UECxMdQXBwbGUgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxFjAUBgNVBAMTDUFwcGxlIFJvb3QgQ0EwHhcNMDYwNDI1MjE0MDM2WhcNMzUwMjA5MjE0MDM2WjBiMQswCQYDVQQGEwJVUzETMBEGA1UEChMKQXBwbGUgSW5jLjEmMCQGA1UECxMdQXBwbGUgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxFjAUBgNVBAMTDUFwcGxlIFJvb3QgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDkkakJH5HbHkdQ6wXtXnmELes2oldMVeyLGYne+Uts9QerIjAC6Bg++FAJ039BqJj50cpmnCRrEdCju+QbKsMflZ56DKRHi1vUFjczy8QPTc4UadHJGXL1XQ7Vf1+b8iUDulWPTV0N8WQ1IxVLFVkds5T39pyez1C6wVhQZ48ItCD3y6wsIG9wtj8BMIy3Q88PnT3zK0koGsj+zrW5DtleHNbLPbU6rfQPDgCSC7EhFi501TwN22IWq6NxkkdTVcGvL0Gz+PvjcM3mo0xFfh9Ma1CWQYnEdGILEINBhzOKgbEwWOxaBDKMaLOPHd5lc/9nXmW8Sdh2nzMUZaF3lMktAgMBAAGjggF6MIIBdjAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUK9BpR5R2Cf70a40uQKb3R01/CF4wHwYDVR0jBBgwFoAUK9BpR5R2Cf70a40uQKb3R01/CF4wggERBgNVHSAEggEIMIIBBDCCAQAGCSqGSIb3Y2QFATCB8jAqBggrBgEFBQcCARYeaHR0cHM6Ly93d3cuYXBwbGUuY29tL2FwcGxlY2EvMIHDBggrBgEFBQcCAjCBthqBs1JlbGlhbmNlIG9uIHRoaXMgY2VydGlmaWNhdGUgYnkgYW55IHBhcnR5IGFzc3VtZXMgYWNjZXB0YW5jZSBvZiB0aGUgdGhlbiBhcHBsaWNhYmxlIHN0YW5kYXJkIHRlcm1zIGFuZCBjb25kaXRpb25zIG9mIHVzZSwgY2VydGlmaWNhdGUgcG9saWN5IGFuZCBjZXJ0aWZpY2F0aW9uIHByYWN0aWNlIHN0YXRlbWVudHMuMA0GCSqGSIb3DQEBBQUAA4IBAQBcNplMLXi37Yyb3PN3m/J20ncwT8EfhYOFG5k9RzfyqZtAjizUsZAS2L70c5vu0mQPy3lPNNiiPvl4/2vIB+x9OYOLUyDTOMSxv5pPCmv/K/xZpwUJfBdAVhEedNO3iyM7R6PVbyTi69G3cN8PReEnyvFteO3ntRcXqNx+IjXKJdXZD9Zr1KIkIxH3oayPc4FgxhtbCS+SsvhESPBgOJ4V9T0mZyCKM2r3DYLP3uujL/lTaltkwGMzd/c6ByxW69oPIQ7aunMZT7XZNn/Bh1XZp5m5MkL72NVxnn6hUrcbvZNCJBIqxw8dtk2cXmPIS4AXUKqK1drk/NAJBzewdXUh"
        let ca = try Certificate.loadCertificateFromDer(Data(base64Encoded: appleRootDerString)!)
        print(ca.issuerName.description)
        #expect(ca.issuerName.countryName == "US")
    }

    @Test("临时测试")
    func oid() throws {
        struct Oid: CustomStringConvertible {
            let nid: Int32
            let oid: String
            let shortName: String
            let longName: String

            var description: String {
                return "nid: \(nid), oid: \(oid ?? "-"), shortName: \(shortName ?? "-"), longName: \(longName ?? "-")"
            }
        }

        var oids: [Oid] = []
        let max_nid = OBJ_new_nid(0)

        for id in 0 ..< max_nid {
            let obj = OBJ_nid2obj(id)
            var len: Int32 = 0
            guard OBJ_obj2nid(obj) != NID_undef else {
                continue
            }

            let sn = OBJ_nid2sn(id) // short name
            let ln = OBJ_nid2ln(id) // long name
            len = OBJ_obj2txt(nil, 0, obj, 1)
            guard len > 0 else {
                if len == 0 {
                    if let sn, let ln {
                        print("# None-OID object: \(String(cString: sn)), \(String(cString: ln))")
                    }
                    continue
                } else {
                    break
                }
            }

            var buffer = [CChar](repeating: 0, count: Int(len) + 1)
            if OBJ_obj2txt(&buffer, Int32(buffer.count), obj, 1) < 0 {
                // error
                break
            }
            if let sn, let ln {
                // print(" \(String(cString: sn)) == \(String(cString: ln)), \(String(validating: buffer, as: UTF8.self)!)")
                let oid = Oid(nid: id, oid: String(cString: buffer), shortName: String(cString: sn), longName: String(cString: ln))
                oids.append(oid)
            }
        }

        for oid in oids {
            print(" \(oid.shortName) == \(oid.longName), \(oid.oid)")
        }
        print("oids count: \(oids.count)")
    }

    private func ss() {}
}
