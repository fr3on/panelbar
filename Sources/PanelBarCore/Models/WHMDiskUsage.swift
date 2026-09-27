import Foundation

/// One entry from `get_disk_usage`. Field names verified against real output from a live server:
/// `user`, `blocks_used`, `blocks_limit`, `inodes_used`, `inodes_limit`. `blocks_used`/`inodes_used`
/// arrive as bare JSON numbers; the limit fields arrive as either a numeric string or JSON `null`
/// (no limit) in the same response, so both are decoded leniently.
///
/// "Blocks" follow the standard Unix quota convention of 1024-byte units, consistent with the real
/// sample (a `blocks_limit` of "10240000" alongside a `blocks_used` of 952228 is a sensible ~10 GB
/// quota with under 1 GB used) — not separately confirmed in cPanel's own documentation.
public struct WHMDiskUsageAccount: Codable, Sendable, Equatable, Identifiable {
    public var id: String { user }
    public let user: String
    public let blocksUsed: Int64
    public let blocksLimit: Int64?
    public let inodesUsed: Int64
    public let inodesLimit: Int64?

    enum CodingKeys: String, CodingKey {
        case user
        case blocksUsed = "blocks_used"
        case blocksLimit = "blocks_limit"
        case inodesUsed = "inodes_used"
        case inodesLimit = "inodes_limit"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decode(String.self, forKey: .user)
        blocksUsed = Self.flexibleInt(container, .blocksUsed) ?? 0
        blocksLimit = Self.flexibleInt(container, .blocksLimit)
        inodesUsed = Self.flexibleInt(container, .inodesUsed) ?? 0
        inodesLimit = Self.flexibleInt(container, .inodesLimit)
    }

    public init(user: String, blocksUsed: Int64, blocksLimit: Int64?, inodesUsed: Int64, inodesLimit: Int64?) {
        self.user = user
        self.blocksUsed = blocksUsed
        self.blocksLimit = blocksLimit
        self.inodesUsed = inodesUsed
        self.inodesLimit = inodesLimit
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(user, forKey: .user)
        try container.encode(blocksUsed, forKey: .blocksUsed)
        try container.encodeIfPresent(blocksLimit, forKey: .blocksLimit)
        try container.encode(inodesUsed, forKey: .inodesUsed)
        try container.encodeIfPresent(inodesLimit, forKey: .inodesLimit)
    }

    /// Null decodes to nil cleanly for either attempt below, so this only needs to try Int64 then String.
    private static func flexibleInt(_ container: KeyedDecodingContainer<CodingKeys>, _ key: CodingKeys) -> Int64? {
        if let value = try? container.decodeIfPresent(Int64.self, forKey: key) { return value }
        if let text = try? container.decodeIfPresent(String.self, forKey: key) { return Int64(text) }
        return nil
    }

    public var blocksUsedMB: Double { Double(blocksUsed) / 1024 }
    public var blocksLimitMB: Double? { blocksLimit.map { Double($0) / 1024 } }
}

public struct WHMDiskUsageResult: Codable, Sendable, Equatable {
    public let accounts: [WHMDiskUsageAccount]

    public init(accounts: [WHMDiskUsageAccount]) {
        self.accounts = accounts
    }

    /// Summed across every account on the server, in megabytes.
    public var totalUsedMB: Double { accounts.reduce(0) { $0 + $1.blocksUsedMB } }
}
