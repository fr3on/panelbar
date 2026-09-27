import Foundation

/// `version`. Field name verified against real output from a live server.
public struct WHMVersionInfo: Codable, Sendable, Equatable {
    public let version: String

    public init(version: String) {
        self.version = version
    }
}
