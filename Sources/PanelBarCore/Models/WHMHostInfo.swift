import Foundation

/// `gethostname`. Field name verified against real output from a live server.
public struct WHMHostInfo: Codable, Sendable, Equatable {
    public let hostname: String

    public init(hostname: String) {
        self.hostname = hostname
    }
}
