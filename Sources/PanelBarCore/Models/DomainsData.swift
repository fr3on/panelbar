import Foundation

/// One entry from `DomainInfo::domains_data`. Field names verified against cPanel's own UAPI reference:
/// https://api.docs.cpanel.net/openapi/cpanel/operation/domains_data/
/// Only the fields PanelBar actually shows are kept; the real response carries many more (Apache
/// directives, log paths, and so on) that are read but ignored.
public struct DomainRecord: Codable, Sendable, Equatable, Identifiable {
    public var id: String { domain }
    public let domain: String
    public let documentroot: String?
    public let type: String?

    public init(domain: String, documentroot: String? = nil, type: String? = nil) {
        self.domain = domain
        self.documentroot = documentroot
        self.type = type
    }
}

public struct DomainsData: Codable, Sendable, Equatable {
    public let mainDomain: DomainRecord?
    public let addonDomains: [DomainRecord]
    public let subDomains: [DomainRecord]
    /// The API returns parked domains as bare strings, not objects.
    public let parkedDomains: [String]

    enum CodingKeys: String, CodingKey {
        case mainDomain = "main_domain"
        case addonDomains = "addon_domains"
        case subDomains = "sub_domains"
        case parkedDomains = "parked_domains"
    }

    public init(mainDomain: DomainRecord?, addonDomains: [DomainRecord] = [], subDomains: [DomainRecord] = [], parkedDomains: [String] = []) {
        self.mainDomain = mainDomain
        self.addonDomains = addonDomains
        self.subDomains = subDomains
        self.parkedDomains = parkedDomains
    }

    /// Every domain PanelBar can show a row for, each labeled with the kind it is.
    public var all: [(name: String, kind: String)] {
        var result: [(String, String)] = []
        if let main = mainDomain { result.append((main.domain, "Primary")) }
        result += addonDomains.map { ($0.domain, "Addon") }
        result += subDomains.map { ($0.domain, "Subdomain") }
        result += parkedDomains.map { ($0, "Parked") }
        return result
    }
}
