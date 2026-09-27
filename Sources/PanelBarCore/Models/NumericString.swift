import Foundation

/// cPanel's UAPI mixes JSON numbers and numeric strings for the same kind of value across calls (see
/// `Quota::get_quota_info`, where `inodes_used` is a number but `megabytes_used` is a string). This
/// decodes either into a `Double`, so callers never have to guess which one a given field will be.
@propertyWrapper
public struct NumericString: Codable, Sendable, Equatable {
    public var wrappedValue: Double

    public init(wrappedValue: Double) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Double.self) {
            wrappedValue = value
        } else if let text = try? container.decode(String.self), let value = Double(text) {
            wrappedValue = value
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected a number or a numeric string")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
