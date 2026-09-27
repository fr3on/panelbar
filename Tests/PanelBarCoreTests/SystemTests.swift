import Foundation
import Testing
@testable import PanelBarCore

@Suite("WHM system load, disk usage, hostname, from real whmapi1 output")
struct SystemTests {
    private func fixture(_ name: String) throws -> Data {
        let url = Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Fixtures")
        return try Data(contentsOf: try #require(url))
    }
    private struct DataOnly<T: Decodable>: Decodable { let data: T }

    @Test("Load average: numeric strings decode for all three windows")
    func systemLoad() throws {
        let load = try JSONDecoder().decode(DataOnly<WHMSystemLoad>.self, from: fixture("systemloadavg")).data
        #expect(load.one == 0.71)
        #expect(load.five == 0.94)
        #expect(load.fifteen == 0.93)
    }

    @Test("Disk usage: a string limit, a null limit, and a bare-number used all decode in the same list")
    func diskUsage() throws {
        let result = try JSONDecoder().decode(DataOnly<WHMDiskUsageResult>.self, from: fixture("get_disk_usage")).data
        #expect(result.accounts.count == 13)

        let acct01 = try #require(result.accounts.first { $0.user == "acct01" })
        #expect(acct01.blocksUsed == 952228)
        #expect(acct01.blocksLimit == 10_240_000)
        #expect(acct01.inodesLimit == nil)

        let acct03 = try #require(result.accounts.first { $0.user == "acct03" })
        #expect(acct03.blocksLimit == nil, "most accounts on this server have no quota set")
        #expect(acct03.blocksUsed == 36_472_273)

        // Computed the same way PanelBar would: sum of every account's blocks_used, in MB.
        let expectedTotalMB = Double(952228 + 187936 + 36_472_273 + 89692 + 42_997_255 + 513092 + 383332 + 49_524_177 + 7_804_840 + 89452 + 998685 + 19800 + 14884) / 1024
        #expect(abs(result.totalUsedMB - expectedTotalMB) < 0.01)
        // Sanity bound in round numbers, independent of the exact arithmetic above: ~130-140 GB used.
        #expect(result.totalUsedMB > 130_000 && result.totalUsedMB < 140_000)
    }

    @Test("Hostname decodes")
    func hostname() throws {
        let info = try JSONDecoder().decode(DataOnly<WHMHostInfo>.self, from: fixture("gethostname")).data
        #expect(info.hostname == "srv1.host.example.com")
    }
}

@Suite("PanelClient system calls")
struct PanelClientSystemTests {
    private func creds(_ kind: ConnectionKind) -> AccountCredentials {
        AccountCredentials(kind: kind, baseURL: URL(string: "https://srv1.host.example.com:2087")!, username: "root", apiToken: "secret-token")
    }
    private func fixture(_ name: String) -> Data {
        let url = Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Fixtures")
        return (try? Data(contentsOf: url!)) ?? Data()
    }

    @Test("Each call hits its confirmed path, and is refused on a cPanel connection")
    func paths() async throws {
        let recorder = CallRecorder()
        let transport = MockHTTPTransport { request in
            let path = request.url?.path ?? ""
            recorder.record(path: path)
            if path.hasSuffix("systemloadavg") { return MockHTTPTransport.response(200, self.fixture("systemloadavg")) }
            if path.hasSuffix("get_disk_usage") { return MockHTTPTransport.response(200, self.fixture("get_disk_usage")) }
            return MockHTTPTransport.response(200, self.fixture("gethostname"))
        }
        let whm = PanelClient(credentials: creds(.whm), transport: transport)
        _ = try await whm.fetchSystemLoad()
        _ = try await whm.fetchDiskUsage()
        let hostname = try await whm.fetchHostname()
        #expect(recorder.paths == ["/json-api/systemloadavg", "/json-api/get_disk_usage", "/json-api/gethostname"])
        #expect(hostname == "srv1.host.example.com")

        let cpanel = PanelClient(credentials: creds(.cpanel), transport: transport)
        await #expect(throws: PanelClientError.self) { try await cpanel.fetchSystemLoad() }
    }
}
