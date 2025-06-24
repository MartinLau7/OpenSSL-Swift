//
//  CMSDataContentInfo.swift
//  OpenSSL-Swift
//
//  Created by 𝗠𝗮𝗿𝘁𝗶𝗻 𝗟𝗮𝘂 on 2025-06-24.
//

internal import OpenSSL

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

public class CMSDataContentInfo: CMSPayload {
    let cms: OpaquePointer

    public var asn1Identifier: ObjectIdentifier {
        return .pkcs7_data
    }

    init(owning cms: OpaquePointer) {
        self.cms = cms
    }

    deinit {
        CMS_ContentInfo_free(cms)
    }

    public func readPayload() throws -> Data {
        throw CMSError.operationNotImplemented
    }
}
