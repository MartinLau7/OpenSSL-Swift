//
//  Pkcs12StoreTests.swift
//  OpenSSL-Swift
//
//  Created by 𝗠𝗮𝗿𝘁𝗶𝗻 𝗟𝗮𝘂 on 2025-07-09.
//

@testable import OpenSSLSwift
import Testing

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

@Suite("Pkcs12Store Tests")
struct Pkcs12StoreTests {
    let pkcs12FilePath = "/Users/martinlau/Downloads/hazqabhatti@gmail.com/test.p12"
    let password = "tutuapp"

    init() async throws {
        try await OpenSSLInitializer.shared.loadAllProvider()
    }

    @Test("test Pkcs12Store Decode")
    func pkcs12StoreDecode() throws {
        let p12 = try Pkcs12Store.load(atPath: pkcs12FilePath, password: password)
        if let certificate = p12.certificate {
            print(certificate.subjectName?.description ?? "-")
        }

        let ca = try p12.getCertificateChain()
        for item in ca {
            print(item.subjectName ?? "--")
        }
    }
}
