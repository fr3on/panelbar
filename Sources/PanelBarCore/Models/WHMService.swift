import Foundation

/// One entry from WHM API 1's `servicestatus`. Field names verified against real output from a live
/// WHM server (`whmapi1 servicestatus --output=jsonpretty`), not documentation: `display_name`,
/// `enabled`, `installed`, `monitored`, `name`, and `running`. A service WHM is not monitoring, or has
/// not installed, simply omits `running` rather than sending `0` — so it must decode as optional.
/// A `settings` object appears on a few services (for example `exim-altport`'s alternate port number);
/// PanelBar has no use for it and it decodes as absent.
public struct WHMService: Codable, Sendable, Equatable, Identifiable {
    public var id: String { name }
    public let name: String
    public let displayName: String
    public let enabled: Bool
    public let installed: Bool
    public let monitored: Bool
    public let running: Bool?

    enum CodingKeys: String, CodingKey {
        case name, running
        case displayName = "display_name"
        case enabled, installed, monitored
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName) ?? name
        enabled = try container.decode(Int.self, forKey: .enabled) != 0
        installed = try container.decode(Int.self, forKey: .installed) != 0
        monitored = try container.decode(Int.self, forKey: .monitored) != 0
        running = try container.decodeIfPresent(Int.self, forKey: .running).map { $0 != 0 }
    }

    public init(name: String, displayName: String, enabled: Bool, installed: Bool, monitored: Bool, running: Bool?) {
        self.name = name
        self.displayName = displayName
        self.enabled = enabled
        self.installed = installed
        self.monitored = monitored
        self.running = running
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(enabled ? 1 : 0, forKey: .enabled)
        try container.encode(installed ? 1 : 0, forKey: .installed)
        try container.encode(monitored ? 1 : 0, forKey: .monitored)
        try container.encodeIfPresent(running.map { $0 ? 1 : 0 }, forKey: .running)
    }

    /// WHM's own vocabulary for this screen: "up", "down", or monitoring "pending" (suspended).
    public enum State: Sendable, Equatable {
        case up, down, notMonitored, notInstalled
    }

    public var state: State {
        guard installed else { return .notInstalled }
        guard monitored else { return .notMonitored }
        return running == true ? .up : .down
    }
}

public struct WHMServicesResult: Codable, Sendable, Equatable {
    public let service: [WHMService]

    public init(service: [WHMService]) {
        self.service = service
    }
}

public extension Array where Element == WHMService {
    /// Installed, monitored, and confirmed not running: the thing worth an attention card.
    var down: [WHMService] { filter { $0.state == .down } }
}
