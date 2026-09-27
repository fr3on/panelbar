import SwiftUI
import PanelBarCore

struct AddServerView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollingContent {
                ConnectForm()
                .padding(.horizontal, Theme.Layout.gutter).padding(.top, 8).padding(.bottom, 12)
            }
            footer
        }
        .frame(width: Theme.Layout.popoverWidth, height: Theme.Layout.popoverHeight)
        .background(Theme.Colors.bg)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 9) {
            GlassPillButton(icon: "chevron.left", title: appState.strings.back, onLight: true) {
                appState.closeAddServer()
            }
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .fill(LinearGradient(colors: [Theme.Colors.accent(appState.newKind), Theme.Colors.accent(appState.newKind).opacity(0.78)], startPoint: .top, endPoint: .bottom))
                        .frame(width: 32, height: 32)
                    Image(systemName: "plus").font(.system(size: 13, weight: .semibold)).foregroundColor(.white)
                }
                Text(appState.strings.addServer).font(.system(size: 14.5, weight: .bold)).foregroundColor(Theme.Colors.text)
                Spacer()
            }
        }
        .padding(.horizontal, 14).padding(.top, 14).padding(.bottom, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .solidCard(radius: 20)
        .padding(.horizontal, 10).padding(.top, 10)
    }

    private var footer: some View {
        HStack {
            Button { appState.closeAddServer() } label: { Text(appState.strings.cancel).font(.system(size: 12)).foregroundColor(Theme.Colors.text3) }.buttonStyle(.plain).focusEffectDisabled()
            Spacer()
            Button { finish() } label: {
                PrimaryPillLabel(title: appState.strings.saveAndConnect, kind: appState.newKind)
                    .opacity(blocked ? 0.4 : 1)
            }
            .buttonStyle(.plain).focusEffectDisabled()
            .disabled(blocked)
        }
        .padding(.horizontal, Theme.Layout.gutter).padding(.vertical, 12)
        .overlay(alignment: .top) { Rectangle().fill(Theme.Colors.hairline).frame(height: 1) }
    }

    private var blocked: Bool {
        appState.newURL.isEmpty || (PanelBarCore.ConnectionPolicy.requiresInsecureOptIn(appState.newURL) && !appState.newAllowInsecure)
    }

    private func finish() {
        appState.saveNewProfile()
        appState.closeAddServer()
    }
}
