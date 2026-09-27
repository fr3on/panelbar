import Foundation
import Testing
@testable import PanelBarCore

@Suite("PanelClient")
struct PanelClientTests {
    private func creds(_ kind: ConnectionKind, url: String = "https://host.example.com:2083", allowInsecureHTTP: Bool = false) -> AccountCredentials {
        AccountCredentials(kind: kind, baseURL: URL(string: url)!, username: "agency", apiToken: "secret-token", allowInsecureHTTP: allowInsecureHTTP)
    }

    private func fixture(_ name: String) -> Data {
        let url = Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Fixtures")
        return (try? Data(contentsOf: url!)) ?? Data()
    }

    @Test("cPanel requests hit UAPI paths with the cpanel auth header")
    func cpanelPaths() async throws {
        let recorder = CallRecorder()
        let transport = MockHTTPTransport { request in
            recorder.record(path: request.url?.path, auth: request.value(forHTTPHeaderField: "Authorization"))
            if request.url?.path.contains("Quota") == true { return MockHTTPTransport.response(200, self.fixture("quota")) }
            if request.url?.path.contains("SSL") == true { return MockHTTPTransport.response(200, self.fixture("list_certs")) }
            return MockHTTPTransport.response(200, self.fixture("domains_data"))
        }
        let client = PanelClient(credentials: creds(.cpanel), transport: transport)
        _ = try await client.fetchQuota()
        _ = try await client.fetchDomains()
        _ = try await client.fetchCertificates()
        #expect(recorder.paths == ["/execute/Quota/get_quota_info", "/execute/DomainInfo/domains_data", "/execute/SSL/list_certs"])
        #expect(recorder.auth.allSatisfy { $0 == "cpanel agency:secret-token" })
    }

    @Test("WHM requests hit the json-api path with api.version=1 and the whm auth header")
    func whmPaths() async throws {
        let recorder = CallRecorder()
        let transport = MockHTTPTransport { request in
            recorder.record(auth: request.value(forHTTPHeaderField: "Authorization"), url: request.url)
            return MockHTTPTransport.response(200, self.fixture("listaccts"))
        }
        let client = PanelClient(credentials: creds(.whm, url: "https://srv1.host.example.com:2087"), transport: transport)
        let accounts = try await client.fetchAccounts()
        #expect(recorder.urls.first?.path == "/json-api/listaccts")
        #expect(recorder.urls.first?.query == "api.version=1")
        #expect(recorder.auth.first == "whm agency:secret-token")
        #expect(accounts.count == 2)
    }

    @Test("A cPanel-only call on a WHM connection is refused before any request is sent")
    func wrongKindCPanel() async {
        let recorder = CallRecorder()
        let transport = MockHTTPTransport { _ in recorder.record(); return MockHTTPTransport.response(200, Data()) }
        let client = PanelClient(credentials: creds(.whm), transport: transport)
        await #expect(throws: PanelClientError.self) { try await client.fetchQuota() }
        #expect(recorder.count == 0)
    }

    @Test("A WHM-only call on a cPanel connection is refused before any request is sent")
    func wrongKindWHM() async {
        let recorder = CallRecorder()
        let transport = MockHTTPTransport { _ in recorder.record(); return MockHTTPTransport.response(200, Data()) }
        let client = PanelClient(credentials: creds(.cpanel), transport: transport)
        await #expect(throws: PanelClientError.self) { try await client.fetchAccounts() }
        #expect(recorder.count == 0)
    }

    @Test("A 401 becomes unauthorized")
    func unauthorized() async {
        let transport = MockHTTPTransport { _ in MockHTTPTransport.response(401, Data()) }
        let client = PanelClient(credentials: creds(.cpanel), transport: transport)
        await #expect(throws: PanelClientError.unauthorized) { try await client.fetchQuota() }
    }

    @Test("A cPanel status:0 becomes apiError, not a decoding crash")
    func uapiFailure() async {
        let transport = MockHTTPTransport { _ in MockHTTPTransport.response(200, self.fixture("uapi_failure")) }
        let client = PanelClient(credentials: creds(.cpanel), transport: transport)
        await #expect(throws: PanelClientError.self) { try await client.fetchQuota() }
    }

    @Test("A WHM metadata.result:0 becomes apiError, not a decoding crash")
    func whmFailure() async {
        let transport = MockHTTPTransport { _ in MockHTTPTransport.response(200, self.fixture("whm_failure")) }
        let client = PanelClient(credentials: creds(.whm), transport: transport)
        await #expect(throws: PanelClientError.self) { try await client.fetchAccounts() }
    }

    @Test("Remote plain http is refused before the token leaves the app, and the opt-in lets it through")
    func insecureHTTP() async throws {
        let recorder = CallRecorder()
        let transport = MockHTTPTransport { _ in recorder.record(); return MockHTTPTransport.response(200, self.fixture("quota")) }
        let blocked = PanelClient(credentials: creds(.cpanel, url: "http://host.example.com:2082"), transport: transport)
        await #expect(throws: PanelClientError.insecureConnection(host: "host.example.com")) { try await blocked.fetchQuota() }
        #expect(recorder.count == 0)

        let allowed = PanelClient(credentials: creds(.cpanel, url: "http://host.example.com:2082", allowInsecureHTTP: true), transport: transport)
        _ = try await allowed.fetchQuota()
        #expect(recorder.count == 1)
    }

    @Test("verifyConnection calls the lightest verified endpoint per kind")
    func verify() async throws {
        let cpanelTransport = MockHTTPTransport { _ in MockHTTPTransport.response(200, self.fixture("quota")) }
        try await PanelClient(credentials: creds(.cpanel), transport: cpanelTransport).verifyConnection()

        let whmTransport = MockHTTPTransport { _ in MockHTTPTransport.response(200, self.fixture("listaccts")) }
        try await PanelClient(credentials: creds(.whm), transport: whmTransport).verifyConnection()
    }
}

@Suite("PanelClient.fetchServices")
struct PanelClientServicesTests {
    private func creds(_ kind: ConnectionKind) -> AccountCredentials {
        AccountCredentials(kind: kind, baseURL: URL(string: "https://srv1.host.example.com:2087")!, username: "root", apiToken: "secret-token")
    }
    private func fixture(_ name: String) -> Data {
        let url = Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Fixtures")
        return (try? Data(contentsOf: url!)) ?? Data()
    }

    @Test("fetchServices calls servicestatus on WHM, and is refused on a cPanel connection")
    func fetchServices() async throws {
        let recorder = CallRecorder()
        let transport = MockHTTPTransport { request in
            recorder.record(url: request.url)
            return MockHTTPTransport.response(200, self.fixture("servicestatus"))
        }
        let whm = PanelClient(credentials: creds(.whm), transport: transport)
        let services = try await whm.fetchServices()
        #expect(recorder.urls.first?.path == "/json-api/servicestatus")
        #expect(services.count == 36)

        let cpanel = PanelClient(credentials: creds(.cpanel), transport: transport)
        await #expect(throws: PanelClientError.self) { try await cpanel.fetchServices() }
    }
}

@Suite("Certificate trust errors")
struct CertificateTrustTests {
    @Test("A TLS trust failure (e.g. hostname mismatch) becomes a friendly, actionable error")
    func certificateMismatch() async {
        let url = URL(string: "https://srv1.host.example.com:2087")!
        let transport = MockHTTPTransport { _ in
            throw URLError(.serverCertificateUntrusted, userInfo: [NSURLErrorFailingURLErrorKey: url])
        }
        let creds = AccountCredentials(kind: .whm, baseURL: url, username: "root", apiToken: "t")
        let client = PanelClient(credentials: creds, transport: transport)
        await #expect(throws: PanelClientError.certificateNotTrusted(host: "srv1.host.example.com")) {
            try await client.fetchHostname()
        }
        let message = PanelClientError.certificateNotTrusted(host: "srv1.host.example.com").errorDescription ?? ""
        #expect(message.contains("srv1.host.example.com"))
        #expect(message.contains("certificate"))
    }

    @Test("secureConnectionFailed maps the same way")
    func secureConnectionFailed() async {
        let url = URL(string: "https://host.example.com:2087")!
        let transport = MockHTTPTransport { _ in throw URLError(.secureConnectionFailed) }
        let creds = AccountCredentials(kind: .whm, baseURL: url, username: "root", apiToken: "t")
        let client = PanelClient(credentials: creds, transport: transport)
        await #expect(throws: PanelClientError.certificateNotTrusted(host: "host.example.com")) {
            try await client.fetchHostname()
        }
    }
}
