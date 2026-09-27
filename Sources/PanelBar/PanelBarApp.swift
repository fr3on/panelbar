import SwiftUI
import AppKit

@main
struct PanelBarApp: App {
    @StateObject private var appState = AppState()

    init() {
        #if DEBUG
        MainActor.assumeIsolated { Snapshot.runIfRequested() }
        #endif
        quitIfAlreadyRunning()
    }

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environmentObject(appState)
        } label: {
            Image(nsImage: MenuBarImage.make(state: appState))
                .help(appState.menuBarTooltip)
        }
        .menuBarExtraStyle(.window)
    }
}

private func quitIfAlreadyRunning() {
    let bundleId = Bundle.main.bundleIdentifier ?? "com.0x200.panelbar"
    let running = NSRunningApplication.runningApplications(withBundleIdentifier: bundleId)
    if running.count > 1 { exit(0) }
}
