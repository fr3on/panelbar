import Foundation
import Testing
@testable import PanelBarCore

@Suite("Connection policy")
struct ConnectionPolicyTests {
    @Test("Only remote plain http needs an opt-in")
    func requiresOptIn() {
        for url in ["http://localhost:2083", "http://127.0.0.1:2087", "https://host.example.com:2083"] {
            #expect(!ConnectionPolicy.requiresInsecureOptIn(url), "\(url)")
        }
        for url in ["http://host.example.com:2082", "http://srv1.host.example.com:2086"] {
            #expect(ConnectionPolicy.requiresInsecureOptIn(url), "\(url)")
        }
    }
}

@Suite("Domain and SSL kind")
struct DomainSSLStatusTests {
    @Test("cPanel and WHM each get the right default port and username label")
    func kindDefaults() {
        #expect(ConnectionKind.cpanel.defaultPort == 2083)
        #expect(ConnectionKind.whm.defaultPort == 2087)
        #expect(ConnectionKind.cpanel.usernameLabel.contains("cPanel"))
        #expect(ConnectionKind.whm.usernameLabel.contains("WHM"))
    }

    @Test("Merging picks the newest certificate that covers each domain, worst SSL first")
    func merge() {
        let domains = DomainsData(
            mainDomain: DomainRecord(domain: "agency-client.com", type: "main_domain"),
            addonDomains: [DomainRecord(domain: "old-brand.com", type: "addon_domain")],
            subDomains: [DomainRecord(domain: "shop.agency-client.com", type: "sub_domain")]
        )
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        let certs = [
            SSLCertificate(id: "a", domains: ["agency-client.com"], isSelfSigned: false, notAfter: String(Int(now.timeIntervalSince1970) + 82 * 86400), issuerCommonName: "R3", friendlyName: nil),
            SSLCertificate(id: "b-old", domains: ["shop.agency-client.com"], isSelfSigned: false, notAfter: String(Int(now.timeIntervalSince1970) - 100), issuerCommonName: "R3", friendlyName: nil),
            SSLCertificate(id: "b-new", domains: ["shop.agency-client.com"], isSelfSigned: false, notAfter: String(Int(now.timeIntervalSince1970) + 6 * 86400), issuerCommonName: "R3", friendlyName: nil),
        ]
        let statuses = DomainSSL.merge(domains: domains, certificates: certs, now: now)
        #expect(statuses.map(\.name) == ["shop.agency-client.com", "agency-client.com", "old-brand.com"], "worst real SSL first, no-cert domains last")
        #expect(statuses[0].daysLeft == 6, "the newer of the two matching certificates wins")
        #expect(statuses[1].daysLeft == 82)
        #expect(statuses[2].daysLeft == nil)
    }

    @Test("A wildcard certificate covers a direct subdomain, not a deeper one")
    func wildcard() {
        let domains = DomainsData(mainDomain: nil, subDomains: [
            DomainRecord(domain: "shop.example.com", type: "sub_domain"),
            DomainRecord(domain: "a.b.example.com", type: "sub_domain"),
        ])
        let cert = SSLCertificate(id: "w", domains: ["*.example.com"], isSelfSigned: false, notAfter: "9999999999", issuerCommonName: nil, friendlyName: nil)
        let statuses = DomainSSL.merge(domains: domains, certificates: [cert])
        #expect(statuses.first { $0.name == "shop.example.com" }?.daysLeft != nil)
        #expect(statuses.first { $0.name == "a.b.example.com" }?.daysLeft == nil)
    }

    @Test("Urgency thresholds")
    func urgency() {
        #expect(SSLUrgency(daysLeft: nil) == .none)
        #expect(SSLUrgency(daysLeft: 30) == .none)
        #expect(SSLUrgency(daysLeft: 14) == .soon(14))
        #expect(SSLUrgency(daysLeft: 0) == .soon(0))
        #expect(SSLUrgency(daysLeft: -3) == .expired(3))
    }
}

@Suite("App settings")
struct AppSettingsTests {
    private func freshDefaults() -> UserDefaults {
        let name = "panelbar.tests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: name)!
        defaults.removePersistentDomain(forName: name)
        return defaults
    }

    @Test("Defaults, round-trip, and normalization")
    func settings() {
        let defaults = freshDefaults()
        #expect(AppSettings.load(from: defaults) == AppSettings())

        let custom = AppSettings(menuBarStat: .sslDaysLeft, hideStatWhenOffline: false, openRefreshMinutes: 5, backgroundRefreshMinutes: 0)
        custom.save(to: defaults)
        #expect(AppSettings.load(from: defaults) == custom)

        let bad = AppSettings(openRefreshMinutes: 1, backgroundRefreshMinutes: 7).normalized()
        #expect(bad.openRefreshMinutes == 2)
        #expect(bad.backgroundRefreshMinutes == 10)
    }
}
