//
//  CMSSignedDataContentInfo.swift
//  OpenSSL-Swift
//
//  Created by 𝗠𝗮𝗿𝘁𝗶𝗻 𝗟𝗮𝘂 on 2025-06-24.
//

internal import OpenSSL
internal import COpenSSL

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

public class CMSSignedDataContentInfo: CMSPayload {
    let cms: OpaquePointer

    public var type: ObjectIdentifier {
        return .pkcs7_signedData
    }

    init(owning cms: OpaquePointer) {
        self.cms = cms
    }

    deinit {
        CMS_ContentInfo_free(cms)
    }

    public func readPayload() throws -> Data {
//        let out = BIO_new(BIO_s_mem())
//        let flags: UInt32 = numericCast(CMS_NO_SIGNER_CERT_VERIFY | CMS_BINARY)
//        let success = CMS_verify(cms, nil, nil, nil, out, flags)
//        if success == 1 {
//            var dataPtr: UnsafeMutablePointer<CChar>?
//            let length = cc_BIO_get_mem_data(out, &dataPtr)
//            guard let ptr = dataPtr, length > 0 else {
//                return Data()
//            }
//            let data = Data(bytes: ptr, count: Int(length))
//            print(String(data: data, encoding: .utf8) ?? "-")
//        }

//        let signerInfoStack = CMS_get0_SignerInfos(cms)
//        let count = sk_CMS_SignerInfo_num(signerInfoStack)

//        if let signedInfo = CMS_get0_SignerInfos(cms) {
//            defer {
//                CMS_SignedData_free(signedInfo)
//            }
//        }

        guard let contentPtr = CMS_get0_content(cms).pointee else {
            throw CryptoError.internalError()
        }
        return Data(bytesNoCopy: UnsafeMutableRawPointer(contentPtr.pointee.data), count: numericCast(contentPtr.pointee.length), deallocator: .none)
    }
}
