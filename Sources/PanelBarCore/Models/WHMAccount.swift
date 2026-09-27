import Foundation

/// One entry from WHM API 1's `listaccts`. Field names verified against cPanel's own documentation and
/// cross-referenced against independent WHM API wrappers: user, domain, disklimit, diskused, suspended,
/// plan, email, ip. `disklimit`/`diskused` are size strings such as "500M" or "unlimited", WHM's own
/// convention, not bytes.
public struct WHMAccount: Codable, Sendable, Equatable, Identifiable {
    public var id: String { user }
    public let user: String
    public let domain: String
    public let disklimit: String
    public let diskused: String
    public let suspended: Int
    public let plan: String?
    public let email: String?
    public let suspendreason: String?
    public let suspendtime: String?
    public let ip: String?
    public let owner: String?
    public let startdate: String?
    public let theme: String?
    public let maxaddons: String?
    public let maxsub: String?
    public let maxpop: String?
    public let maxsql: String?
    public let inodesused: String?
    public let inodeslimit: String?

    public init(
        user: String,
        domain: String,
        disklimit: String,
        diskused: String,
        suspended: Int,
        plan: String? = nil,
        email: String? = nil,
        suspendreason: String? = nil,
        suspendtime: String? = nil,
        ip: String? = nil,
        owner: String? = nil,
        startdate: String? = nil,
        theme: String? = nil,
        maxaddons: String? = nil,
        maxsub: String? = nil,
        maxpop: String? = nil,
        maxsql: String? = nil,
        inodesused: String? = nil,
        inodeslimit: String? = nil
    ) {
        self.user = user
        self.domain = domain
        self.disklimit = disklimit
        self.diskused = diskused
        self.suspended = suspended
        self.plan = plan
        self.email = email
        self.suspendreason = suspendreason
        self.suspendtime = suspendtime
        self.ip = ip
        self.owner = owner
        self.startdate = startdate
        self.theme = theme
        self.maxaddons = maxaddons
        self.maxsub = maxsub
        self.maxpop = maxpop
        self.maxsql = maxsql
        self.inodesused = inodesused
        self.inodeslimit = inodeslimit
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        func decodeLossless(_ key: CodingKeys) -> String? {
            if let s = try? c.decodeIfPresent(String.self, forKey: key) { return s }
            if let i = try? c.decodeIfPresent(Int.self, forKey: key) { return String(i) }
            if let d = try? c.decodeIfPresent(Double.self, forKey: key) { return String(d) }
            return nil
        }

        user = (try? c.decode(String.self, forKey: .user)) ?? decodeLossless(.user) ?? "unknown"
        domain = (try? c.decode(String.self, forKey: .domain)) ?? decodeLossless(.domain) ?? ""
        disklimit = decodeLossless(.disklimit) ?? "unlimited"
        diskused = decodeLossless(.diskused) ?? "0"
        
        // `suspended` can be an Int (0/1) or a string ("0"/"1")
        if let s = try? c.decode(Int.self, forKey: .suspended) {
            suspended = s
        } else if let s = try? c.decode(String.self, forKey: .suspended), let val = Int(s) {
            suspended = val
        } else {
            suspended = 0
        }

        plan = decodeLossless(.plan)
        email = decodeLossless(.email)
        suspendreason = decodeLossless(.suspendreason)
        suspendtime = decodeLossless(.suspendtime)
        ip = decodeLossless(.ip)
        owner = decodeLossless(.owner)
        startdate = decodeLossless(.startdate)
        theme = decodeLossless(.theme)
        maxaddons = decodeLossless(.maxaddons)
        maxsub = decodeLossless(.maxsub)
        maxpop = decodeLossless(.maxpop)
        maxsql = decodeLossless(.maxsql)
        inodesused = decodeLossless(.inodesused)
        inodeslimit = decodeLossless(.inodeslimit)
    }

    public var isSuspended: Bool { suspended != 0 }
    public var diskUsedMB: Double? { DiskSize.megabytes(from: diskused) }
    public var diskLimitMB: Double? { DiskSize.megabytes(from: disklimit) }

    /// nil when the plan has no limit ("unlimited") or the limit could not be parsed.
    public var diskUsedFraction: Double? {
        guard let used = diskUsedMB, let limit = diskLimitMB, limit > 0 else { return nil }
        return min(1, used / limit)
    }
}

public struct WHMAccountsResult: Codable, Sendable, Equatable {
    public let acct: [WHMAccount]

    public init(acct: [WHMAccount]) {
        self.acct = acct
    }

    enum CodingKeys: String, CodingKey {
        case acct
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        if let list = try? c.decode([WHMAccount].self, forKey: .acct) {
            acct = list
        } else if let single = try? c.decode(WHMAccount.self, forKey: .acct) {
            acct = [single]
        } else {
            acct = []
        }
    }
}

/// WHM sizes look like "500M", "2G" or "unlimited"/"0" (both mean no limit). Parses to megabytes.
public enum DiskSize {
    public static func megabytes(from text: String) -> Double? {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty || trimmed.caseInsensitiveCompare("unlimited") == .orderedSame { return nil }
        // The unit is only real when the string actually ends in a letter; a bare "0" or "500" has none.
        let hasUnit = trimmed.last?.isLetter ?? false
        let unit = hasUnit ? trimmed.suffix(1).uppercased() : ""
        let numberPart = hasUnit ? String(trimmed.dropLast()) : trimmed
        guard let value = Double(numberPart) else { return nil }
        let megabytes: Double
        switch unit {
        case "G": megabytes = value * 1024
        case "T": megabytes = value * 1024 * 1024
        case "K": megabytes = value / 1024
        default: megabytes = value
        }
        // WHM represents "no limit" as 0, not as a large number or `null`.
        return megabytes == 0 ? nil : megabytes
    }
}
