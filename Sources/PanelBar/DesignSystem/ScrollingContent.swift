import SwiftUI

/// Scrolls in the real app. Image rendering (used by the debug --snapshot tool) cannot draw ScrollView
/// content at all, so snapshots fall back to a plain top-aligned stack instead.
struct ScrollingContent<Content: View>: View {
    @EnvironmentObject var appState: AppState
    @ViewBuilder let content: Content

    var body: some View {
        if appState.isSnapshot {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
        } else {
            ScrollView(.vertical, showsIndicators: false) { content }
        }
    }
}
