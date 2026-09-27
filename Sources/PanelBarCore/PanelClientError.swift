import Foundation

public enum PanelClientError: Error, LocalizedError, Sendable, Equatable {
    case invalidURL
    case invalidResponse
    case unauthorized
    case notFound(String)
    case serverError(Int, String)
    case decodingError(String)
    case networkError(String)
    case insecureConnection(host: String)
    /// TLS failed: an untrusted, expired, or (the common real-world case on shared/reseller hosting)
    /// a certificate issued for a different hostname than the one being connected to.
    case certificateNotTrusted(host: String)
    /// A cPanel-only call was made on a WHM connection, or the reverse.
    case wrongKind(String)
    /// The server answered, but its own `metadata.result == 0` (cPanel `status == 0`).
    case apiError(String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid server URL"
        case .invalidResponse:
            return "Received an invalid HTTP response"
        case .unauthorized:
            return "Unauthorized: invalid or missing API token"
        case let .notFound(resource):
            return "Not found: \(resource)"
        case let .serverError(code, message):
            return "Server error (\(code)): \(message)"
        case let .decodingError(details):
            return "Failed to decode the response: \(details)"
        case let .networkError(message):
            return "Network error: \(message)"
        case let .insecureConnection(host):
            return "\(host) uses plain http://, and macOS blocks unencrypted connections to remote hosts. Use https or an SSH tunnel, or allow insecure HTTP for this connection."
        case let .certificateNotTrusted(host):
            return "Could not verify \(host)'s certificate. The most common cause on shared or reseller hosting: the certificate is issued for the server's real hostname, not this one. Try connecting using the hostname shown on the certificate instead (often something like your-server.yourhost.com)."
        case let .wrongKind(message):
            return message
        case let .apiError(message):
            return message
        }
    }
}
