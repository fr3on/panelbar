import Foundation

/// User preferences that are not tied to one connection. Stored as one JSON blob in UserDefaults.
public struct AppSettings: Codable, Sendable, Equatable {
    /// What the menu bar item shows next to the icon. `primary` means "the one number that matters for
    /// this connection's kind": disk percent for a cPanel account, account count for a WHM server.
    public enum MenuBarStat: String, Codable, CaseIterable, Sendable, Identifiable {
        case none, primary, sslDaysLeft

        public var id: String { rawValue }
    }

    public enum AppearanceChoice: String, Codable, CaseIterable, Sendable, Identifiable {
        case system = "System"
        case light = "Light"
        case dark = "Dark"

        public var id: String { rawValue }
    }

    public static let openRefreshMinuteChoices = [2, 5, 10]
    /// 0 turns the background check off.
    public static let backgroundRefreshMinuteChoices = [0, 10, 30, 60]
    public static let storageKey = "panelbar_settings"

    public var menuBarStat: MenuBarStat
    public var hideStatWhenOffline: Bool
    public var openRefreshMinutes: Int
    public var backgroundRefreshMinutes: Int
    public var appearance: AppearanceChoice
    public var language: AppLanguage

    public init(
        menuBarStat: MenuBarStat = .primary,
        hideStatWhenOffline: Bool = true,
        openRefreshMinutes: Int = 2,
        backgroundRefreshMinutes: Int = 10,
        appearance: AppearanceChoice = .system,
        language: AppLanguage = .system
    ) {
        self.menuBarStat = menuBarStat
        self.hideStatWhenOffline = hideStatWhenOffline
        self.openRefreshMinutes = openRefreshMinutes
        self.backgroundRefreshMinutes = backgroundRefreshMinutes
        self.appearance = appearance
        self.language = language
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let defaults = AppSettings()
        menuBarStat = (try? container.decodeIfPresent(MenuBarStat.self, forKey: .menuBarStat)) ?? defaults.menuBarStat
        hideStatWhenOffline = try container.decodeIfPresent(Bool.self, forKey: .hideStatWhenOffline) ?? defaults.hideStatWhenOffline
        openRefreshMinutes = try container.decodeIfPresent(Int.self, forKey: .openRefreshMinutes) ?? defaults.openRefreshMinutes
        backgroundRefreshMinutes = try container.decodeIfPresent(Int.self, forKey: .backgroundRefreshMinutes) ?? defaults.backgroundRefreshMinutes
        appearance = (try? container.decodeIfPresent(AppearanceChoice.self, forKey: .appearance)) ?? defaults.appearance
        language = (try? container.decodeIfPresent(AppLanguage.self, forKey: .language)) ?? defaults.language
    }

    /// Snaps intervals to the offered choices, so a hand-edited value cannot hammer a shared host.
    public func normalized() -> AppSettings {
        var copy = self
        if !Self.openRefreshMinuteChoices.contains(copy.openRefreshMinutes) {
            copy.openRefreshMinutes = Self.openRefreshMinuteChoices.min { abs($0 - copy.openRefreshMinutes) < abs($1 - copy.openRefreshMinutes) } ?? 2
        }
        if !Self.backgroundRefreshMinuteChoices.contains(copy.backgroundRefreshMinutes) {
            copy.backgroundRefreshMinutes = Self.backgroundRefreshMinuteChoices.min { abs($0 - copy.backgroundRefreshMinutes) < abs($1 - copy.backgroundRefreshMinutes) } ?? 10
        }
        return copy
    }

    public static func load(from defaults: UserDefaults = .standard) -> AppSettings {
        guard let data = defaults.data(forKey: storageKey), let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) else {
            return AppSettings()
        }
        return decoded.normalized()
    }

    public func save(to defaults: UserDefaults = .standard) {
        if let data = try? JSONEncoder().encode(self) {
            defaults.set(data, forKey: Self.storageKey)
        }
    }
}
