import Foundation

public struct ReleaseInfo: Codable, Sendable, Equatable {
    public let tagName: String
    public let htmlURL: URL?
    public let name: String?
    public let body: String?

    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
        case htmlURL = "html_url"
        case name
        case body
    }

    public init(tagName: String, htmlURL: URL? = nil, name: String? = nil, body: String? = nil) {
        self.tagName = tagName
        self.htmlURL = htmlURL
        self.name = name
        self.body = body
    }
}

public enum UpdateCheckResult: Sendable, Equatable {
    case upToDate(currentVersion: String)
    case updateAvailable(latestVersion: String, releaseURL: URL)
}

public actor UpdateChecker {
    public let repository: String
    public let currentVersion: String
    private let transport: HTTPTransport

    public init(
        repository: String = "fr3on/panelbar",
        currentVersion: String = "0.1.0",
        transport: HTTPTransport = URLSessionHTTPTransport()
    ) {
        self.repository = repository
        self.currentVersion = currentVersion
        self.transport = transport
    }

    public func checkForUpdates() async throws -> UpdateCheckResult {
        guard let url = URL(string: "https://api.github.com/repos/\(repository)/releases/latest") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("PanelBar/\(currentVersion)", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 10

        let (data, response) = try await transport.execute(request: request)
        if response.statusCode == 404 {
            return .upToDate(currentVersion: Self.cleanVersion(currentVersion))
        }
        guard response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let release = try JSONDecoder().decode(ReleaseInfo.self, from: data)
        let remote = Self.cleanVersion(release.tagName)
        let local = Self.cleanVersion(currentVersion)

        if Self.isVersion(remote, newerThan: local) {
            let releaseURL = release.htmlURL ?? URL(string: "https://github.com/\(repository)/releases")!
            return .updateAvailable(latestVersion: remote, releaseURL: releaseURL)
        } else {
            return .upToDate(currentVersion: local)
        }
    }

    public static func cleanVersion(_ version: String) -> String {
        var trimmed = version.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.lowercased().hasPrefix("v") {
            trimmed.removeFirst()
        }
        return trimmed
    }

    public static func isVersion(_ v1: String, newerThan v2: String) -> Bool {
        let parts1 = cleanVersion(v1).split(separator: ".").compactMap { Int($0) }
        let parts2 = cleanVersion(v2).split(separator: ".").compactMap { Int($0) }

        let count = max(parts1.count, parts2.count)
        for i in 0..<count {
            let p1 = i < parts1.count ? parts1[i] : 0
            let p2 = i < parts2.count ? parts2[i] : 0
            if p1 > p2 { return true }
            if p1 < p2 { return false }
        }
        return false
    }
}
