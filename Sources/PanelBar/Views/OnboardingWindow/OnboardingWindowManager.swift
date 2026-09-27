import SwiftUI
import AppKit

@MainActor
public final class OnboardingWindowManager: NSObject, NSWindowDelegate {
    public static let shared = OnboardingWindowManager()
    private var window: NSWindow?

    private override init() { super.init() }

    public func show(appState: AppState) {
        if let existing = window {
            existing.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let hostingView = NSHostingView(rootView: OnboardingWindowView().environmentObject(appState))
        let newWindow = NSWindow(
            contentRect: NSRect(origin: .zero, size: OnboardingWindowView.size),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false
        )
        newWindow.delegate = self
        newWindow.center()
        newWindow.title = "Welcome to PanelBar"
        newWindow.titlebarAppearsTransparent = true
        newWindow.titleVisibility = .hidden
        newWindow.isReleasedWhenClosed = false
        newWindow.isOpaque = false
        newWindow.backgroundColor = .clear
        newWindow.contentView = hostingView
        self.window = newWindow
        newWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    public func close() {
        window?.close()
        window = nil
    }

    public func windowWillClose(_ notification: Notification) {
        window = nil
    }
}
