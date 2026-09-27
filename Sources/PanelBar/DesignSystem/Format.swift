import Foundation
import PanelBarCore

enum Format {
    static func count(_ value: Int) -> String {
        let f = NumberFormatter(); f.numberStyle = .decimal
        return f.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    static func host(_ urlString: String) -> String {
        guard let url = URL(string: urlString), let host = url.host else { return urlString }
        return url.port.map { "\(host):\($0)" } ?? host
    }

    static func mb(_ value: Double) -> String {
        let tb = 1024.0 * 1024.0
        let gb = 1024.0
        if value >= tb {
            let val = value / tb
            return String(format: val.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f TB" : "%.1f TB", val)
        } else if value >= gb {
            let val = value / gb
            return String(format: val.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f GB" : "%.1f GB", val)
        } else {
            return String(format: "%.0f MB", value)
        }
    }

    /// Formats a raw size string from WHM (e.g. "48363M", "444444M", "500M", "1.2G", "unlimited", "0")
    /// into a human-readable scaled unit like "47.2 GB", "434.0 GB", "1.2 TB", or "unlimited".
    static func diskSize(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty || trimmed.caseInsensitiveCompare("unlimited") == .orderedSame {
            return "unlimited"
        }
        if trimmed == "0" || trimmed == "0M" || trimmed == "0G" {
            return "0 MB"
        }
        if let mb = DiskSize.megabytes(from: trimmed) {
            return self.mb(mb)
        }
        return raw
    }
}
