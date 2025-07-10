internal import COpenSSL

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

public final class BigNumber {
    public typealias BIGNUM = OpaquePointer

    let bigNum: OpaquePointer

    public init() {
        bigNum = BN_new()
    }

    init(owning original: BIGNUM) {
        bigNum = original
    }

    init(copying original: BIGNUM) {
        bigNum = BN_new()
        _ = BN_copy(bigNum, original)
    }

    public init(_ decimal: String) throws {
        var bigNum = BN_new()
        guard BN_dec2bn(&bigNum, decimal) == 1 else {
            throw CryptoError.internalError()
        }
        self.bigNum = bigNum!
    }

    public init(hex: String) throws {
        var bigNum = BN_new()
        guard BN_hex2bn(&bigNum, hex) == 1 else {
            throw CryptoError.internalError()
        }
        self.bigNum = bigNum!
    }

    deinit {
        BN_clear_free(bigNum)
    }

    public var rawBytes: [UInt8] {
        let size = (BN_num_bits(bigNum) + 7) / 8
        var bytes = [UInt8](repeating: 0, count: Int(size))
        bytes.withUnsafeMutableBytes { bytes in
            if let p = bytes.baseAddress?.assumingMemoryBound(to: UInt8.self) {
                BN_bn2bin(bigNum, p)
            }
        }
        return bytes
    }

    public var rawData: Data {
        var data = Data(count: Int((BN_num_bits(bigNum) + 7) / 8))
        data.withUnsafeMutableBytes { bytes in
            if let p = bytes.baseAddress?.assumingMemoryBound(to: UInt8.self) {
                BN_bn2bin(bigNum, p)
            }
        }
        return data
    }

    public var decimalString: String {
        return String(validatingCString: BN_bn2dec(bigNum)) ?? ""
    }

    public var hexString: String {
        return String(validatingCString: BN_bn2hex(bigNum)) ?? ""
    }
}

public extension BigNumber {
    var isZero: Bool {
        return BN_is_zero(bigNum) == 1
    }
}

extension BigNumber: CustomStringConvertible {
    public var description: String {
        return decimalString
    }
}
