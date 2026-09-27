import Foundation
import LocalAuthentication

@MainActor
public final class TouchIDManager {
    public static let shared = TouchIDManager()

    private init() {}

    /// Returns true if this Mac has Touch ID hardware and at least one enrolled fingerprint.
    public var isTouchIDAvailable: Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    /// Evaluates Touch ID biometric authentication.
    /// Falls back to device passcode if biometrics cannot be evaluated directly.
    public func authenticate(reason: String = "Authenticate to access PanelBar servers") async -> Bool {
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"

        var error: NSError?
        let policy: LAPolicy = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            ? .deviceOwnerAuthenticationWithBiometrics
            : .deviceOwnerAuthentication

        do {
            return try await context.evaluatePolicy(policy, localizedReason: reason)
        } catch {
            return false
        }
    }
}
