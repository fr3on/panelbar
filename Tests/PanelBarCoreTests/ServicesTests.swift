import Foundation
import Testing
@testable import PanelBarCore

@Suite("WHM services, from real whmapi1 output")
struct ServicesTests {
    private func fixture(_ name: String) throws -> Data {
        let url = Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Fixtures")
        return try Data(contentsOf: try #require(url))
    }

    private struct DataOnly<T: Decodable>: Decodable { let data: T }

    @Test("All 36 services decode, including ones with no 'running' key at all")
    func decode() throws {
        let services = try JSONDecoder().decode(DataOnly<WHMServicesResult>.self, from: fixture("servicestatus")).data.service
        #expect(services.count == 36)

        let httpd = try #require(services.first { $0.name == "httpd" })
        #expect(httpd.displayName == "Apache Web Server")
        #expect(httpd.enabled && httpd.installed && httpd.monitored)
        #expect(httpd.running == true)
        #expect(httpd.state == .up)

        let cxswatch = try #require(services.first { $0.name == "cxswatch" })
        #expect(cxswatch.running == false)
        #expect(cxswatch.state == .down)
    }

    @Test("A service with no 'running' key is not silently treated as stopped")
    func missingRunningKey() throws {
        let services = try JSONDecoder().decode(DataOnly<WHMServicesResult>.self, from: fixture("servicestatus")).data.service

        let ftpd = try #require(services.first { $0.name == "ftpd" })
        #expect(ftpd.running == nil)
        #expect(!ftpd.installed)
        #expect(ftpd.state == .notInstalled)

        let dbGovernor = try #require(services.first { $0.name == "db_governor" })
        #expect(dbGovernor.running == nil)
        #expect(dbGovernor.installed && !dbGovernor.monitored)
        #expect(dbGovernor.state == .notMonitored)
    }

    @Test("A 'settings' sub-object on a service (exim-altport) does not break decoding")
    func ignoresSettings() throws {
        let services = try JSONDecoder().decode(DataOnly<WHMServicesResult>.self, from: fixture("servicestatus")).data.service
        let eximAlt = try #require(services.first { $0.name == "exim-altport" })
        #expect(eximAlt.running == nil)
        #expect(!eximAlt.monitored)
    }

    @Test("down lists exactly the installed, monitored, confirmed-stopped services")
    func down() throws {
        let services = try JSONDecoder().decode(DataOnly<WHMServicesResult>.self, from: fixture("servicestatus")).data.service
        let down = services.down
        #expect(Set(down.map(\.name)) == ["cxswatch", "jetbackup5d", "mailman"])
    }
}
