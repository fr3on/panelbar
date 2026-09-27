import Foundation
import Testing
@testable import PanelBarCore

@Suite("Update checker")
struct UpdateCheckerTests {
    @Test("Semantic version comparison")
    func versionComparison() {
        #expect(UpdateChecker.isVersion("0.2.0", newerThan: "0.1.0"))
        #expect(UpdateChecker.isVersion("v0.2.0", newerThan: "0.1.0"))
        #expect(UpdateChecker.isVersion("v1.0.0", newerThan: "0.9.9"))
        #expect(UpdateChecker.isVersion("0.1.1", newerThan: "0.1.0"))
        #expect(UpdateChecker.isVersion("0.10.0", newerThan: "0.9.0"))

        #expect(!UpdateChecker.isVersion("0.1.0", newerThan: "0.1.0"))
        #expect(!UpdateChecker.isVersion("v0.1.0", newerThan: "0.1.0"))
        #expect(!UpdateChecker.isVersion("0.0.9", newerThan: "0.1.0"))
        #expect(!UpdateChecker.isVersion("0.1.0", newerThan: "0.2.0"))
    }

    @Test("Update available when remote version is newer")
    func updateAvailable() async throws {
        let json = """
        {
            "tag_name": "v0.2.0",
            "html_url": "https://github.com/fr3on/panelbar/releases/tag/v0.2.0",
            "name": "0.2.0",
            "body": "New features release"
        }
        """.data(using: .utf8)!

        let transport = MockHTTPTransport { request in
            #expect(request.url?.absoluteString == "https://api.github.com/repos/fr3on/panelbar/releases/latest")
            #expect(request.value(forHTTPHeaderField: "User-Agent") == "PanelBar/0.1.0")
            return MockHTTPTransport.response(200, json, url: request.url!)
        }

        let checker = UpdateChecker(repository: "fr3on/panelbar", currentVersion: "0.1.0", transport: transport)
        let result = try await checker.checkForUpdates()

        let expectedURL = URL(string: "https://github.com/fr3on/panelbar/releases/tag/v0.2.0")!
        #expect(result == .updateAvailable(latestVersion: "0.2.0", releaseURL: expectedURL))
    }

    @Test("Up to date when remote matches current version")
    func upToDate() async throws {
        let json = """
        {
            "tag_name": "v0.1.0",
            "html_url": "https://github.com/fr3on/panelbar/releases/tag/v0.1.0",
            "name": "0.1.0"
        }
        """.data(using: .utf8)!

        let transport = MockHTTPTransport { request in
            MockHTTPTransport.response(200, json, url: request.url!)
        }

        let checker = UpdateChecker(repository: "fr3on/panelbar", currentVersion: "0.1.0", transport: transport)
        let result = try await checker.checkForUpdates()
        #expect(result == .upToDate(currentVersion: "0.1.0"))
    }

    @Test("404 response on repo without releases is treated as up to date")
    func notFoundIsUpToDate() async throws {
        let transport = MockHTTPTransport { request in
            MockHTTPTransport.response(404, Data(), url: request.url!)
        }

        let checker = UpdateChecker(repository: "fr3on/panelbar", currentVersion: "0.1.0", transport: transport)
        let result = try await checker.checkForUpdates()
        #expect(result == .upToDate(currentVersion: "0.1.0"))
    }

    @Test("Server error throws error")
    func serverErrorThrows() async throws {
        let transport = MockHTTPTransport { request in
            MockHTTPTransport.response(500, Data(), url: request.url!)
        }

        let checker = UpdateChecker(repository: "fr3on/panelbar", currentVersion: "0.1.0", transport: transport)
        await #expect(throws: Error.self) {
            try await checker.checkForUpdates()
        }
    }
}
