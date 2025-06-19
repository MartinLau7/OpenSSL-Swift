internal import COpenSSL

extension BigNumber: Comparable {
    public static func == (lhs: BigNumber, rhs: BigNumber) -> Bool {
        return lhs.compare(with: rhs) == 0
    }

    public static func != (lhs: BigNumber, rhs: BigNumber) -> Bool {
        return lhs.compare(with: rhs) != 0
    }

    public static func > (lhs: BigNumber, rhs: BigNumber) -> Bool {
        return lhs.compare(with: rhs) > 0
    }

    public static func < (lhs: BigNumber, rhs: BigNumber) -> Bool {
        return lhs.compare(with: rhs) < 0
    }

    public static func >= (lhs: BigNumber, rhs: BigNumber) -> Bool {
        return lhs.compare(with: rhs) >= 0
    }

    public static func <= (lhs: BigNumber, rhs: BigNumber) -> Bool {
        return lhs.compare(with: rhs) <= 0
    }

    private func compare(with other: BigNumber) -> Int32 {
        return BN_cmp(bigNum, other.bigNum)
    }
}
