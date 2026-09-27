import Foundation

/// One entry from `SSL::list_certs`. Field names, including the dotted keys, verified against cPanel's
/// own UAPI reference example: https://api.docs.cpanel.net/openapi/cpanel/operation/list_certs/
/// (the dots are real JSON keys in cPanel's flattened-hash response, not nested objects).
public struct SSLCertificate: Codable, Sendable, Equatable, Identifiable {
    public let id: String
    public let domains: [String]
    public let isSelfSigned: Bool
    /// Unix timestamp, sent as a string.
    public let notAfter: String
    public let issuerCommonName: String?
    public let friendlyName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case domains
        case isSelfSigned = "is_self_signed"
        case notAfter = "not_after"
        case issuerCommonName = "issuer.commonName"
        case friendlyName = "friendly_name"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        domains = try container.decodeIfPresent([String].self, forKey: .domains) ?? []
        isSelfSigned = Self.isTruthy(try container.decodeIfPresent(String.self, forKey: .isSelfSigned))
        notAfter = try container.decode(String.self, forKey: .notAfter)
        issuerCommonName = try container.decodeIfPresent(String.self, forKey: .issuerCommonName)
        friendlyName = try container.decodeIfPresent(String.self, forKey: .friendlyName)
    }

    public init(id: String, domains: [String], isSelfSigned: Bool, notAfter: String, issuerCommonName: String?, friendlyName: String?) {
        self.id = id
        self.domains = domains
        self.isSelfSigned = isSelfSigned
        self.notAfter = notAfter
        self.issuerCommonName = issuerCommonName
        self.friendlyName = friendlyName
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(domains, forKey: .domains)
        try container.encode(isSelfSigned ? "1" : "0", forKey: .isSelfSigned)
        try container.encode(notAfter, forKey: .notAfter)
        try container.encodeIfPresent(issuerCommonName, forKey: .issuerCommonName)
        try container.encodeIfPresent(friendlyName, forKey: .friendlyName)
    }

    private static func isTruthy(_ value: String?) -> Bool {
        guard let value else { return false }
        return value == "1" || value.lowercased() == "true"
    }

    public var expiresAt: Date? {
        guard let seconds = TimeInterval(notAfter) else { return nil }
        return Date(timeIntervalSince1970: seconds)
    }

    public func daysLeft(from now: Date = Date()) -> Int? {
        guard let expiresAt else { return nil }
        let seconds = expiresAt.timeIntervalSince(now)
        return Int((seconds / 86400).rounded(.down))
    }
}
