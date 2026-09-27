import Foundation

/// Talks to one cPanel account (UAPI) or one WHM server (API 1). Read-only: every call here is a `GET`
/// against a function that only reads data. Calling a cPanel-only method against a WHM connection (or
/// the reverse) throws `.wrongKind` rather than guessing at a URL that would not exist.
public actor PanelClient {
    public var credentials: AccountCredentials
    private let transport: HTTPTransport

    public init(credentials: AccountCredentials, transport: HTTPTransport = URLSessionHTTPTransport()) {
        self.credentials = credentials
        self.transport = transport
    }

    public func updateCredentials(_ credentials: AccountCredentials) {
        self.credentials = credentials
    }

    // MARK: cPanel (UAPI)

    public func fetchQuota() async throws -> QuotaInfo {
        try await cpanelOnly()
        return try await uapi("Quota", "get_quota_info", as: QuotaInfo.self)
    }

    public func fetchDomains() async throws -> DomainsData {
        try await cpanelOnly()
        return try await uapi("DomainInfo", "domains_data", as: DomainsData.self)
    }

    public func fetchCertificates() async throws -> [SSLCertificate] {
        try await cpanelOnly()
        return try await uapi("SSL", "list_certs", as: [SSLCertificate].self)
    }

    // MARK: WHM (API 1)

    public func fetchAccounts() async throws -> [WHMAccount] {
        try await whmOnly()
        return try await whmapi1("listaccts", as: WHMAccountsResult.self).acct
    }

    /// Field names verified against real `whmapi1 servicestatus` output, not documentation.
    public func fetchServices() async throws -> [WHMService] {
        try await whmOnly()
        return try await whmapi1("servicestatus", as: WHMServicesResult.self).service
    }

    public func fetchSystemLoad() async throws -> WHMSystemLoad {
        try await whmOnly()
        return try await whmapi1("systemloadavg", as: WHMSystemLoad.self)
    }

    public func fetchDiskUsage() async throws -> WHMDiskUsageResult {
        try await whmOnly()
        return try await whmapi1("get_disk_usage", as: WHMDiskUsageResult.self)
    }

    public func fetchHostname() async throws -> String {
        try await whmOnly()
        return try await whmapi1("gethostname", as: WHMHostInfo.self).hostname
    }

    public func fetchWHMVersion() async throws -> String {
        try await whmOnly()
        return try await whmapi1("version", as: WHMVersionInfo.self).version
    }

    // MARK: Connectivity

    /// The lightest verified call for each kind, used to confirm a token actually works.
    public func verifyConnection() async throws {
        switch credentials.kind {
        case .cpanel: _ = try await fetchQuota()
        case .whm:
            do {
                _ = try await fetchAccounts()
            } catch {
                _ = try await fetchWHMVersion()
            }
        }
    }

    // MARK: Plumbing

    private func cpanelOnly() async throws {
        guard credentials.kind == .cpanel else {
            throw PanelClientError.wrongKind("This is a cPanel-only call, and the active connection is a WHM server.")
        }
    }

    private func whmOnly() async throws {
        guard credentials.kind == .whm else {
            throw PanelClientError.wrongKind("This is a WHM-only call, and the active connection is a cPanel account.")
        }
    }

    private func uapi<T: Decodable>(_ module: String, _ function: String, as type: T.Type) async throws -> T {
        let request = try makeRequest(path: "execute/\(module)/\(function)")
        let (data, response) = try await send(request)
        try checkHTTPStatus(response)

        if let legacy = try? JSONDecoder().decode(LegacyErrorEnvelope.self, from: data), let msg = legacy.errorMessage {
            if msg.localizedCaseInsensitiveContains("access denied") || msg.localizedCaseInsensitiveContains("unauthorized") {
                throw PanelClientError.unauthorized
            }
            throw PanelClientError.apiError("\(module)::\(function) failed: \(msg)")
        }

        let envelope: UAPIEnvelope<T>
        do {
            envelope = try JSONDecoder().decode(UAPIEnvelope<T>.self, from: data)
        } catch let decErr as DecodingError {
            throw PanelClientError.decodingError(Self.formatDecodingError(decErr))
        } catch {
            throw PanelClientError.decodingError(error.localizedDescription)
        }
        guard envelope.status == 1, let value = envelope.data else {
            let errorMsg = envelope.errors?.first
            if let errorMsg, errorMsg.localizedCaseInsensitiveContains("access denied") || errorMsg.localizedCaseInsensitiveContains("unauthorized") {
                throw PanelClientError.unauthorized
            }
            throw PanelClientError.apiError(errorMsg.map { "\(module)::\(function) failed: \($0)" } ?? "\(module)::\(function) failed")
        }
        return value
    }

    private func whmapi1<T: Decodable>(_ function: String, as type: T.Type) async throws -> T {
        let request = try makeRequest(path: "json-api/\(function)", queryItems: [URLQueryItem(name: "api.version", value: "1")])
        let (data, response) = try await send(request)
        try checkHTTPStatus(response)

        // Check if server returned a legacy or top-level error (e.g. {"cpanelresult": ...})
        if let legacy = try? JSONDecoder().decode(LegacyErrorEnvelope.self, from: data), let msg = legacy.errorMessage {
            if msg.localizedCaseInsensitiveContains("access denied") || msg.localizedCaseInsensitiveContains("unauthorized") {
                throw PanelClientError.unauthorized
            }
            throw PanelClientError.apiError("\(function) failed: \(msg)")
        }

        let envelope: WHMEnvelope<T>
        do {
            envelope = try JSONDecoder().decode(WHMEnvelope<T>.self, from: data)
        } catch let decErr as DecodingError {
            throw PanelClientError.decodingError(Self.formatDecodingError(decErr))
        } catch {
            throw PanelClientError.decodingError(error.localizedDescription)
        }

        if envelope.metadata.result == 0 {
            let reason = envelope.metadata.reason ?? "failed"
            if reason.localizedCaseInsensitiveContains("access denied") || reason.localizedCaseInsensitiveContains("unauthorized") {
                throw PanelClientError.unauthorized
            }
            throw PanelClientError.apiError("\(function) failed: \(reason)")
        }

        guard let value = envelope.data else {
            throw PanelClientError.apiError(envelope.metadata.reason.map { "\(function) failed: \($0)" } ?? "\(function) returned no data")
        }
        return value
    }

    private static func formatDecodingError(_ error: DecodingError) -> String {
        switch error {
        case .typeMismatch(let type, let ctx):
            let path = ctx.codingPath.map(\.stringValue).joined(separator: ".")
            return "Type mismatch for \(type)\(path.isEmpty ? "" : " at " + path)"
        case .valueNotFound(let type, let ctx):
            let path = ctx.codingPath.map(\.stringValue).joined(separator: ".")
            return "Value missing for \(type)\(path.isEmpty ? "" : " at " + path)"
        case .keyNotFound(let key, let ctx):
            let path = ctx.codingPath.map(\.stringValue).joined(separator: ".")
            return "Missing field '\(key.stringValue)'\(path.isEmpty ? "" : " at " + path)"
        case .dataCorrupted(let ctx):
            let path = ctx.codingPath.map(\.stringValue).joined(separator: ".")
            return "Corrupted data\(path.isEmpty ? "" : " at " + path): \(ctx.debugDescription)"
        @unknown default:
            return error.localizedDescription
        }
    }

    private func makeRequest(path: String, queryItems: [URLQueryItem] = []) throws -> URLRequest {
        guard var components = URLComponents(url: credentials.baseURL, resolvingAgainstBaseURL: true) else {
            throw PanelClientError.invalidURL
        }
        let existingPath = components.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let newPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        components.path = "/" + (existingPath.isEmpty ? newPath : "\(existingPath)/\(newPath)")
        if !queryItems.isEmpty { components.queryItems = queryItems }
        guard let url = components.url else { throw PanelClientError.invalidURL }

        // A remote plain-HTTP connection is refused before the token can be sent, same rule as QdrantBar.
        if ConnectionPolicy.requiresInsecureOptIn(url) && !credentials.allowInsecureHTTP {
            throw PanelClientError.insecureConnection(host: url.host ?? "This server")
        }

        var request = URLRequest(url: url, timeoutInterval: 12)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(credentials.authorizationHeader, forHTTPHeaderField: "Authorization")
        return request
    }

    private func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        do {
            return try await transport.execute(request: request)
        } catch let error as PanelClientError {
            throw error
        } catch let urlError as URLError where urlError.code == .appTransportSecurityRequiresSecureConnection {
            throw PanelClientError.insecureConnection(host: urlError.failingURL?.host ?? "This server")
        } catch let urlError as URLError where Self.certificateTrustCodes.contains(urlError.code) {
            throw PanelClientError.certificateNotTrusted(host: urlError.failingURL?.host ?? request.url?.host ?? "This server")
        } catch {
            throw PanelClientError.networkError(error.localizedDescription)
        }
    }

    /// URLSession folds "untrusted", "expired" and "issued for a different hostname" into one of these
    /// few codes; it does not expose which one happened, so the message covers all three.
    private static let certificateTrustCodes: Set<URLError.Code> = [
        .serverCertificateUntrusted,
        .serverCertificateHasBadDate,
        .serverCertificateNotYetValid,
        .serverCertificateHasUnknownRoot,
        .secureConnectionFailed,
        .clientCertificateRejected,
    ]

    private func checkHTTPStatus(_ response: HTTPURLResponse) throws {
        guard !(200...299).contains(response.statusCode) else { return }
        switch response.statusCode {
        case 401, 403: throw PanelClientError.unauthorized
        case 404: throw PanelClientError.notFound(response.url?.path ?? "")
        default: throw PanelClientError.serverError(response.statusCode, HTTPURLResponse.localizedString(forStatusCode: response.statusCode))
        }
    }
}
