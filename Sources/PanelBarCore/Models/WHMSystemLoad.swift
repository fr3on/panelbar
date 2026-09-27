import Foundation

/// `systemloadavg`. Field names verified against real `whmapi1 systemloadavg` output from a live
/// server: `one`, `five`, `fifteen`, all sent as numeric strings.
public struct WHMSystemLoad: Codable, Sendable, Equatable {
    @NumericString public var one: Double
    @NumericString public var five: Double
    @NumericString public var fifteen: Double

    public init(one: Double, five: Double, fifteen: Double) {
        self.one = one
        self.five = five
        self.fifteen = fifteen
    }
}
