import Foundation

/// cPanel and WHM are different APIs with different auth and different data. A connection is one or
/// the other, never both, so it gets the dashboard that matches.
public enum ConnectionKind: String, Codable, Sendable, Equatable {
    case cpanel
    case whm

    /// cPanel's UAPI username, or WHM's server username (root or a reseller).
    public var usernameLabel: String {
        self == .cpanel ? "cPanel username" : "WHM username (root or reseller)"
    }

    /// The default secure port for this product, used only to help the user fill in a host URL.
    public var defaultPort: Int { self == .cpanel ? 2083 : 2087 }
}

public struct AccountCredentials: Sendable, Equatable {
    public var kind: ConnectionKind
    public var baseURL: URL
    public var username: String
    public var apiToken: String
    public var allowInsecureHTTP: Bool

    public init(kind: ConnectionKind, baseURL: URL, username: String, apiToken: String, allowInsecureHTTP: Bool = false) {
        self.kind = kind
        self.baseURL = baseURL
        self.username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        self.apiToken = apiToken.trimmingCharacters(in: .whitespacesAndNewlines)
        self.allowInsecureHTTP = allowInsecureHTTP
    }

    /// `Authorization: cpanel user:token` or `Authorization: whm user:token`, cPanel and WHM's own token scheme.
    var authorizationHeader: String {
        "\(kind.rawValue) \(username):\(apiToken)"
    }
}
