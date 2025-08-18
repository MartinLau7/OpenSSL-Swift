//
//  OpenSSL.swift
//  OpenSSL-Swift
//
//  Created by 𝗠𝗮𝗿𝘁𝗶𝗻 𝗟𝗮𝘂 on 2025-07-09.
//

internal import OpenSSL

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

public actor OpenSSLInitializer {
    public static let shared = OpenSSLInitializer()

    private var initialized = false
    private var defaultProvider: OpaquePointer?
    private var legacyProvider: OpaquePointer?

    private init() {}

    public func loadAllProvider() throws {
        guard !initialized else {
            return
        }
        guard defaultProvider == nil, legacyProvider == nil else {
            return
        }

        // load default provider
        guard let defaultProv = OSSL_PROVIDER_load(nil, "default") else {
            throw CryptoError.internalError()
        }

        // load legacy provider
        guard let legacyProv = OSSL_PROVIDER_load(nil, "legacy") else {
            throw CryptoError.internalError()
        }

        defaultProvider = defaultProv
        legacyProvider = legacyProv
        initialized = true
    }

    public func unloadAllProvider() throws {
        if let legacyProv = legacyProvider {
            OSSL_PROVIDER_unload(legacyProv)
            legacyProvider = nil
        }

        if let defaultProv = defaultProvider {
            OSSL_PROVIDER_unload(defaultProv)
            defaultProvider = nil
        }
    }

    /// 清除載入的 providers，通常用於應用結束時
    public func cleanup() throws {
        try unloadAllProvider()

        initialized = false
    }
}
