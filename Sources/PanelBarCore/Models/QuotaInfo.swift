import Foundation

/// `Quota::get_quota_info`. Field names verified against cPanel's own UAPI reference example:
/// https://api.docs.cpanel.net/openapi/cpanel/operation/get_quota_info/
public struct QuotaInfo: Codable, Sendable, Equatable {
    @NumericString public var megabytesUsed: Double
    /// "0.00" (as a string) means unlimited in cPanel's own convention, not zero.
    @NumericString public var megabyteLimit: Double
    public var inodesUsed: Int
    @NumericString public var inodeLimit: Double

    enum CodingKeys: String, CodingKey {
        case megabytesUsed = "megabytes_used"
        case megabyteLimit = "megabyte_limit"
        case inodesUsed = "inodes_used"
        case inodeLimit = "inode_limit"
    }

    public init(megabytesUsed: Double, megabyteLimit: Double, inodesUsed: Int, inodeLimit: Double) {
        self.megabytesUsed = megabytesUsed
        self.megabyteLimit = megabyteLimit
        self.inodesUsed = inodesUsed
        self.inodeLimit = inodeLimit
    }

    /// cPanel represents "no limit" as a limit of 0, not as a large number or `null`.
    public var isUnlimited: Bool { megabyteLimit <= 0 }

    public var usedFraction: Double? {
        guard !isUnlimited else { return nil }
        return min(1, megabytesUsed / megabyteLimit)
    }
}
