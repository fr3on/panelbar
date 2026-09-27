import Foundation

public struct DomainSSLStatus: Sendable, Equatable, Identifiable {
    public var id: String { name }
    public let name: String
    public let kind: String
    public let daysLeft: Int?
    public let issuer: String?

    public init(name: String, kind: String, daysLeft: Int?, issuer: String?) {
        self.name = name
        self.kind = kind
        self.daysLeft = daysLeft
        self.issuer = issuer
    }
}

public enum SSLUrgency: Sendable, Equatable {
    case none, soon(Int), expired(Int)

    public init(daysLeft: Int?, threshold: Int = 14) {
        guard let daysLeft else { self = .none; return }
        if daysLeft < 0 { self = .expired(-daysLeft) }
        else if daysLeft <= threshold { self = .soon(daysLeft) }
        else { self = .none }
    }
}

public enum DomainSSL {
    /// Matches each domain to the certificate that covers it (an exact name, or a wildcard whose suffix
    /// matches), preferring the one with the latest `not_after` when more than one covers the same name
    /// — cPanel can keep an old certificate in the list after AutoSSL renews it, and the newest one is
    /// the one actually presented to visitors.
    public static func merge(domains: DomainsData, certificates: [SSLCertificate], now: Date = Date()) -> [DomainSSLStatus] {
        domains.all.map { entry in
            let matches = certificates.filter { covers($0, entry.name) }
            let best = matches.max { ($0.expiresAt ?? .distantPast) < ($1.expiresAt ?? .distantPast) }
            return DomainSSLStatus(name: entry.name, kind: entry.kind, daysLeft: best?.daysLeft(from: now), issuer: best?.issuerCommonName)
        }
        .sorted { lhs, rhs in
            let l = lhs.daysLeft ?? Int.max
            let r = rhs.daysLeft ?? Int.max
            return l != r ? l < r : lhs.name < rhs.name
        }
    }

    private static func covers(_ certificate: SSLCertificate, _ domain: String) -> Bool {
        let domain = domain.lowercased()
        for covered in certificate.domains.map({ $0.lowercased() }) {
            if covered == domain { return true }
            if covered.hasPrefix("*.") {
                // Keep the leading dot: "*.example.com" covers "shop" + ".example.com", not "example.com" alone.
                let suffix = String(covered.dropFirst(1))
                if domain.hasSuffix(suffix) {
                    let rest = domain.dropLast(suffix.count)
                    if !rest.isEmpty && !rest.contains(".") { return true }
                }
            }
        }
        return false
    }
}
