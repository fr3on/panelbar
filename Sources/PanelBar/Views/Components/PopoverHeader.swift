import SwiftUI
import PanelBarCore

/// Logo, server picker and environment/profile tag in the QdrantBar style.
struct PopoverHeader: View {
    @EnvironmentObject var appState: AppState
    let profile: ConnectionProfile

    private var accent: Color { Theme.Colors.accent(profile.kind) }
    private var resolvedIcon: String { profile.kind == .cpanel ? "globe" : "server.rack" }

    var body: some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    LinearGradient(
                        colors: [accent, accent.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 20, height: 20)
                .overlay(
                    Image(systemName: resolvedIcon)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                )

            Button {
                withAnimation(.easeOut(duration: 0.12)) { appState.isProfileSwitcherOpen.toggle() }
            } label: {
                pickerLabel
            }
            .buttonStyle(.plain).focusEffectDisabled()
            .popover(isPresented: Binding(
                get: { appState.isProfileSwitcherOpen },
                set: { appState.isProfileSwitcherOpen = $0 }
            ), arrowEdge: .top) {
                switcherPanel
            }

            Spacer()

            PillLabel(text: profile.environmentTag)
        }
        .padding(.horizontal, Theme.Layout.gutter)
        .padding(.top, 14)
    }

    private var pickerLabel: some View {
        HStack(spacing: 6) {
            Image(systemName: "chevron.down")
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(Theme.Colors.text3)
            Text(profile.name)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.Colors.text)
                .lineLimit(1)
        }
    }

    /// Presented via `.popover`, not `Menu` — `Menu`'s native bezel/chrome renders unreliably on
    /// this OS (see the earlier broken-icon fix), so this is our own styled panel instead.
    private var switcherPanel: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(appState.strings.activeServer.uppercased())
                .font(.system(size: 10, weight: .bold)).tracking(0.4).foregroundColor(Theme.Colors.text3)
                .padding(.horizontal, 10).padding(.top, 6).padding(.bottom, 2)

            ForEach(appState.profiles) { p in
                Button {
                    appState.switchProfile(to: p)
                    appState.isProfileSwitcherOpen = false
                } label: {
                    HStack(spacing: 8) {
                        Text("\(p.name) (\(p.kind == .cpanel ? "cPanel" : "WHM"))")
                            .font(.system(size: 12, weight: .medium)).foregroundColor(Theme.Colors.text).lineLimit(1)
                        Spacer(minLength: 10)
                        if appState.activeProfileID == p.id {
                            Image(systemName: "checkmark").font(.system(size: 10, weight: .bold)).foregroundColor(Theme.Colors.text2)
                        }
                    }
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain).focusEffectDisabled()
            }

            Rectangle().fill(Theme.Colors.hairline).frame(height: 1).padding(.vertical, 2)

            Button {
                appState.navigateToAddServer()
                appState.isProfileSwitcherOpen = false
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus").font(.system(size: 10, weight: .bold))
                    Text(appState.strings.addServerEllipsis).font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(Theme.Colors.text)
                .padding(.horizontal, 10).padding(.vertical, 6)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain).focusEffectDisabled()
        }
        .padding(4)
        .frame(minWidth: 200, alignment: .leading)
    }
}
