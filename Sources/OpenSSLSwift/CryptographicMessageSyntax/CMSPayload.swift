//
//  CMSPayload.swift
//  OpenSSL-Swift
//
//  Created by 𝗠𝗮𝗿𝘁𝗶𝗻 𝗟𝗮𝘂 on 2025-06-24.
//

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

public protocol CMSPayload {
    func readPayload() throws -> Data
}
