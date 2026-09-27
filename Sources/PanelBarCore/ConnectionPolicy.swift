import Foundation

/// Which servers may be reached over plain `http://`.
///
/// cPanel and WHM almost always run behind their own TLS (ports 2083/2087), so this mirrors the same
/// rule used elsewhere: a remote `http://` host is refused unless that connection's profile opts in.
/// Loopback is always allowed, for a local development cPanel/WHM.
public enum ConnectionPolicy {
    public static func isLoopback(host: String) -> Bool {
        let host = host.lowercased().trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
        return host == "localhost" || host == "::1" || host.hasSuffix(".localhost") || host == "127.0.0.1" || host.hasPrefix("127.")
    }

    public static func requiresInsecureOptIn(_ url: URL) -> Bool {
        guard url.scheme?.lowercased() == "http", let host = url.host, !host.isEmpty else { return false }
        return !isLoopback(host: host)
    }

    public static func requiresInsecureOptIn(_ urlString: String) -> Bool {
        URL(string: urlString.trimmingCharacters(in: .whitespacesAndNewlines)).map(requiresInsecureOptIn) ?? false
    }
}
