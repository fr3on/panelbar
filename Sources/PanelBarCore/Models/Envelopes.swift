import Foundation

/// cPanel UAPI's envelope: `{"status":1,"data":...,"errors":[...],"messages":...}`.
/// `status == 0` means the call itself failed even though the HTTP request succeeded.
struct UAPIEnvelope<T: Decodable>: Decodable {
    let status: Int
    let data: T?
    let errors: [String]?

    enum CodingKeys: String, CodingKey {
        case status, data, errors
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let s = try? container.decode(Int.self, forKey: .status) {
            status = s
        } else if let s = try? container.decode(String.self, forKey: .status), let parsed = Int(s) {
            status = parsed
        } else {
            status = 0
        }
        data = try? container.decodeIfPresent(T.self, forKey: .data)
        errors = try? container.decodeIfPresent([String].self, forKey: .errors)
    }

    init(status: Int, data: T?, errors: [String]? = nil) {
        self.status = status
        self.data = data
        self.errors = errors
    }
}

/// WHM API 1's envelope: `{"data":...,"metadata":{"result":1,"reason":"...","command":"..."}}`.
/// `metadata.result == 0` means the call itself failed even though the HTTP request succeeded.
struct WHMEnvelope<T: Decodable>: Decodable {
    struct Metadata: Decodable {
        let result: Int
        let reason: String?
        let command: String?
        let version: Int?

        enum CodingKeys: String, CodingKey {
            case result, reason, command, version
        }

        init(result: Int = 1, reason: String? = nil, command: String? = nil, version: Int? = nil) {
            self.result = result
            self.reason = reason
            self.command = command
            self.version = version
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let i = try? container.decode(Int.self, forKey: .result) {
                result = i
            } else if let s = try? container.decode(String.self, forKey: .result), let i = Int(s) {
                result = i
            } else {
                result = 1
            }
            reason = try? container.decodeIfPresent(String.self, forKey: .reason)
            command = try? container.decodeIfPresent(String.self, forKey: .command)
            if let v = try? container.decode(Int.self, forKey: .version) {
                version = v
            } else if let s = try? container.decode(String.self, forKey: .version), let v = Int(s) {
                version = v
            } else {
                version = nil
            }
        }
    }

    let data: T?
    let metadata: Metadata

    enum CodingKeys: String, CodingKey {
        case data, metadata
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try? container.decodeIfPresent(T.self, forKey: .data)
        if let meta = try? container.decodeIfPresent(Metadata.self, forKey: .metadata) {
            metadata = meta
        } else {
            metadata = Metadata(result: data != nil ? 1 : 0, reason: nil)
        }
    }

    init(data: T?, metadata: Metadata) {
        self.data = data
        self.metadata = metadata
    }
}

/// Fallback for WHM / cPanel legacy error responses like:
/// `{"cpanelresult":{"error":"Access denied","data":{"reason":"Access denied","result":"0"}}}`
struct LegacyErrorEnvelope: Decodable {
    struct CPResult: Decodable {
        let error: String?
        struct DataObj: Decodable {
            let reason: String?
            let result: String?
        }
        let data: DataObj?
    }
    let cpanelresult: CPResult?
    let error: String?
    let reason: String?

    var errorMessage: String? {
        if let err = cpanelresult?.error, !err.isEmpty { return err }
        if let r = cpanelresult?.data?.reason, !r.isEmpty { return r }
        if let err = error, !err.isEmpty { return err }
        if let r = reason, !r.isEmpty { return r }
        return nil
    }
}
