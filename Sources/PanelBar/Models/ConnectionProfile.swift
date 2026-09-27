import Foundation
import PanelBarCore

/// A saved connection: one cPanel account or one WHM server. The API token lives in the Keychain,
/// keyed by `id`, never here.
public struct ConnectionProfile: Codable, Sendable, Equatable, Identifiable {
    public let id: UUID
    public var name: String
    public var kind: ConnectionKind
    public var urlString: String
    public var username: String
    public var allowInsecureHTTP: Bool
    public var customTag: String?

    public init(
        id: UUID = UUID(),
        name: String,
        kind: ConnectionKind,
        urlString: String,
        username: String,
        allowInsecureHTTP: Bool = false,
        customTag: String? = nil
    ) {
        self.id = id
        self.name = name
        self.kind = kind
        self.urlString = urlString
        self.username = username
        self.allowInsecureHTTP = allowInsecureHTTP
        self.customTag = customTag
    }

    public var environmentTag: String {
        customTag ?? (kind == .cpanel ? "cPanel" : "WHM")
    }

    public static let storageKey = "panelbar_profiles"
    public static let activeIDKey = "panelbar_active_profile_id"

    public static func loadAll(from defaults: UserDefaults = .standard) -> [ConnectionProfile] {
        guard let data = defaults.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([ConnectionProfile].self, from: data)
        else { return [] }
        return decoded
    }

    public static func saveAll(_ profiles: [ConnectionProfile], to defaults: UserDefaults = .standard) {
        if let data = try? JSONEncoder().encode(profiles) {
            defaults.set(data, forKey: storageKey)
        }
    }

    /// Credentials to hand to `PanelClient`, once the Keychain has supplied the token.
    public func credentials(apiToken: String) -> AccountCredentials? {
        guard let url = URL(string: urlString) else { return nil }
        return AccountCredentials(kind: kind, baseURL: url, username: username, apiToken: apiToken, allowInsecureHTTP: allowInsecureHTTP)
    }
}
