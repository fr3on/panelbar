import Foundation
import Testing
@testable import PanelBarCore

@Suite("Decoding, from cPanel's own documented examples")
struct ModelsTests {
    private func fixture(_ name: String) throws -> Data {
        let url = Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Fixtures")
            ?? Bundle.module.url(forResource: name, withExtension: "json")
        return try Data(contentsOf: try #require(url))
    }

    private struct DataOnly<T: Decodable>: Decodable { let data: T }

    @Test("Quota: numeric-string fields decode, and a zero limit means unlimited, not zero")
    func quota() throws {
        let quota = try JSONDecoder().decode(DataOnly<QuotaInfo>.self, from: fixture("quota")).data
        #expect(quota.megabytesUsed == 5.46)
        #expect(quota.megabyteLimit == 40000)
        #expect(quota.inodesUsed == 1035)
        #expect(!quota.isUnlimited)
        #expect(abs((quota.usedFraction ?? -1) - 5.46 / 40000) < 0.0001)

        let unlimited = try JSONDecoder().decode(DataOnly<QuotaInfo>.self, from: fixture("quota_unlimited")).data
        #expect(unlimited.isUnlimited)
        #expect(unlimited.usedFraction == nil)
    }

    @Test("Domains: main, addon, sub and bare-string parked domains all decode")
    func domains() throws {
        let domains = try JSONDecoder().decode(DataOnly<DomainsData>.self, from: fixture("domains_data")).data
        #expect(domains.mainDomain?.domain == "example.com")
        #expect(domains.addonDomains.map(\.domain) == ["seconddomain.com"])
        #expect(domains.subDomains.map(\.domain) == ["sub.example.com"])
        #expect(domains.parkedDomains == ["parkeddomain.com"])
        let all = domains.all
        #expect(all.count == 4)
        #expect(all.contains { $0.name == "example.com" && $0.kind == "Primary" })
        #expect(all.contains { $0.name == "parkeddomain.com" && $0.kind == "Parked" })
    }

    @Test("SSL certificates: dotted keys decode, and not_after parses to a date")
    func certificates() throws {
        let certs = try JSONDecoder().decode(DataOnly<[SSLCertificate]>.self, from: fixture("list_certs")).data
        let cert = try #require(certs.first)
        #expect(cert.domains == ["example.com"])
        #expect(cert.isSelfSigned)
        #expect(cert.issuerCommonName == "example.com")
        #expect(cert.friendlyName == "TestCert")
        let expiresAt = try #require(cert.expiresAt)
        #expect(expiresAt == Date(timeIntervalSince1970: 1_397_169_490))
        // 4 days before expiry, daysLeft should read 4; well past it, it should go negative.
        #expect(cert.daysLeft(from: expiresAt.addingTimeInterval(-4 * 86400)) == 4)
        #expect((cert.daysLeft(from: Date()) ?? 0) < 0, "the fixture's certificate expired in 2014")
    }

    @Test("WHM accounts: suspended flag, and WHM's size strings parse to megabytes")
    func whmAccounts() throws {
        let result = try JSONDecoder().decode(DataOnly<WHMAccountsResult>.self, from: fixture("listaccts")).data
        #expect(result.acct.count == 2)
        let active = result.acct[0]
        #expect(!active.isSuspended)
        #expect(active.diskUsedMB == 65)
        #expect(active.diskLimitMB == 500)
        #expect(abs((active.diskUsedFraction ?? -1) - 0.13) < 0.001)

        let suspended = result.acct[1]
        #expect(suspended.isSuspended)
        #expect(suspended.diskLimitMB == nil, "unlimited must not be treated as a real limit")
        #expect(suspended.diskUsedFraction == nil)
    }

    @Test("Disk sizes")
    func diskSizes() {
        // Compared as Double explicitly: swift-testing's #expect captures each side of `==` with its
        // own inferred type for its failure messages, so a bare Int literal on one side of a Double?
        // comparison can read as unequal even when the numbers match.
        #expect(DiskSize.megabytes(from: "500M") == Double(500))
        #expect(DiskSize.megabytes(from: "1.2G") == 1.2 * 1024)
        #expect(DiskSize.megabytes(from: "2T") == Double(2 * 1024 * 1024))
        #expect(DiskSize.megabytes(from: "unlimited") == nil)
        #expect(DiskSize.megabytes(from: "0") == nil)
    }
}
