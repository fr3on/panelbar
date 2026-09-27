import Foundation
import Security

public enum KeychainError: Error, LocalizedError, Equatable {
    case saveFailed(OSStatus)
    case deleteFailed(OSStatus)

    public var errorDescription: String? {
        switch self {
        case let .saveFailed(status): "Keychain save failed (code \(status))"
        case let .deleteFailed(status): "Keychain delete failed (code \(status))"
        }
    }
}

/// One API token per connection profile, keyed by the profile's UUID.
public actor KeychainManager {
    public static let shared = KeychainManager()
    private let service = "com.0x200.panelbar.apitoken"

    public init() {}

    public func saveToken(_ token: String, for profileID: UUID) throws {
        guard let data = token.data(using: .utf8) else { return }
        try? deleteToken(for: profileID)
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: profileID.uuidString,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
        ]

        var access: SecAccess?
        if SecAccessCreate("PanelBar Token" as CFString, nil, &access) == errSecSuccess, let access {
            query[kSecAttrAccess as String] = access
        }

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.saveFailed(status) }
    }

    public func getToken(for profileID: UUID) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: profileID.uuidString,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    public func deleteToken(for profileID: UUID) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: profileID.uuidString,
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError.deleteFailed(status) }
    }
}
