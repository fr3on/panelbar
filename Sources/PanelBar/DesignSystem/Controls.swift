import SwiftUI
import PanelBarCore

/// A small, self-styled glass control for use where a native `Menu`/`Button` bezel would fight the
/// surface's own look instead of sitting on top of it. `onLight` switches it from white-on-color
/// (over an accent surface) to dark-on-glass (over a neutral card).
struct GlassIconButton: View {
    let systemImage: String
    var size: CGFloat = 24
    var onLight: Bool = false
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: size * 0.38, weight: .bold))
                .foregroundColor(onLight ? Theme.Colors.text2 : .white)
                .frame(width: size, height: size)
                .background(onLight ? Theme.Colors.bg : Color.white.opacity(0.22), in: Circle())
                .overlay(Circle().strokeBorder(onLight ? Theme.Colors.solidBorder : Color.white.opacity(0.4), lineWidth: 1))
        }
        .buttonStyle(.plain).focusEffectDisabled()
    }
}

/// The pill counterpart of `GlassIconButton`, for an icon+label control like a back button.
struct GlassPillButton: View {
    let icon: String
    let title: String
    var onLight: Bool = false
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 9, weight: .bold))
                Text(title).font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(onLight ? Theme.Colors.text2 : .white)
            .padding(.horizontal, 10).padding(.vertical, 5)
            .background(onLight ? Theme.Colors.bg : Color.white.opacity(0.20), in: Capsule())
            .overlay(Capsule().strokeBorder(onLight ? Theme.Colors.solidBorder : Color.white.opacity(0.38), lineWidth: 1))
        }
        .buttonStyle(.plain).focusEffectDisabled()
    }
}

struct PrimaryPillLabel: View {
    let title: String
    let kind: ConnectionKind
    var body: some View {
        Text(title).font(.system(size: 12, weight: .semibold)).foregroundColor(Theme.Colors.onAccent)
            .padding(.horizontal, 14).padding(.vertical, 7)
            .background(
                LinearGradient(colors: [Theme.Colors.accent(kind), Theme.Colors.accent(kind).opacity(0.82)], startPoint: .top, endPoint: .bottom),
                in: RoundedRectangle(cornerRadius: Theme.Layout.pillRadius)
            )
            .shadow(color: Theme.Colors.accent(kind).opacity(0.35), radius: 6, x: 0, y: 2)
    }
}

struct SecondaryPillLabel: View {
    let title: String
    var icon: String? = nil
    var body: some View {
        HStack(spacing: 5) {
            if let icon { Image(systemName: icon).font(.system(size: 10, weight: .semibold)) }
            Text(title).font(.system(size: 12, weight: .medium))
        }
        .foregroundColor(Theme.Colors.text)
        .padding(.horizontal, 12).padding(.vertical, 7)
        .glassCard(radius: Theme.Layout.pillRadius)
    }
}

struct Chip: View {
    let text: String
    var tone: Color = Theme.Colors.text2
    var body: some View {
        Text(text).font(.system(size: 10.5, weight: .semibold)).foregroundColor(tone)
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(tone.opacity(0.16), in: RoundedRectangle(cornerRadius: 5))
    }
}

struct PillLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 10.5, weight: .medium))
            .foregroundColor(Theme.Colors.text2)
            .lineLimit(1)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(Theme.Colors.pillBackground)
            .clipShape(Capsule())
    }
}

struct QuietPillLabel: View {
    let title: String
    var icon: String? = nil

    var body: some View {
        HStack(spacing: 5) {
            if let icon {
                Image(systemName: icon).font(.system(size: 10, weight: .semibold))
            }
            Text(title).font(.system(size: 12, weight: .medium))
        }
        .foregroundColor(Theme.Colors.text)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Theme.Colors.pillBackground)
        .clipShape(Capsule())
    }
}

struct StatusDot: View {
    let color: Color
    var size: CGFloat = 8
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .shadow(color: color.opacity(0.6), radius: 3)
    }
}

struct SegmentedTabs<Tab: Hashable>: View {
    let items: [(Tab, String)]
    @Binding var selected: Tab

    var body: some View {
        HStack(spacing: 2) {
            ForEach(items, id: \.0) { tab, title in
                let isSelected = selected == tab
                Button {
                    selected = tab
                } label: {
                    Text(title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(isSelected ? Theme.Colors.text : Theme.Colors.text3)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(isSelected ? Theme.Colors.pillBackground : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                }
                .buttonStyle(.plain)
                .focusEffectDisabled()
            }
        }
        .padding(2)
        .background(Theme.Colors.solidCard)
        .clipShape(RoundedRectangle(cornerRadius: 9))
        .padding(.horizontal, Theme.Layout.gutter)
    }
}

struct UnderlineTabs<Tab: Hashable>: View {
    let items: [(Tab, String)]
    @Binding var selected: Tab
    let kind: ConnectionKind
    var body: some View {
        HStack(spacing: 20) {
            ForEach(items, id: \.0) { tab, title in
                Button {
                    selected = tab
                } label: {
                    VStack(spacing: 7) {
                        Text(title).font(.system(size: 12.5, weight: tab == selected ? .semibold : .medium))
                            .foregroundColor(tab == selected ? Theme.Colors.text : Theme.Colors.text3)
                        Rectangle().fill(tab == selected ? Theme.Colors.accent(kind) : .clear).frame(height: 2)
                    }
                }
                .buttonStyle(.plain).focusEffectDisabled()
            }
            Spacer()
        }
        .overlay(alignment: .bottom) { Rectangle().fill(Theme.Colors.hairline).frame(height: 1) }
    }
}

struct StatTile: View {
    let icon: String
    let tint: Color
    let value: String
    let label: String
    var note: String? = nil
    var noteColor: Color = Theme.Colors.text3
    var progress: Double? = nil
    var progressColor: Color? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        let content = VStack(alignment: .leading, spacing: 7) {
            HStack {
                ZStack {
                    Circle().fill(
                        LinearGradient(colors: [tint.opacity(0.22), tint.opacity(0.12)], startPoint: .top, endPoint: .bottom)
                    ).frame(width: 30, height: 30)
                    Image(systemName: icon).font(.system(size: 12, weight: .semibold)).foregroundColor(tint)
                }
                Spacer()
                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(Theme.Colors.text3.opacity(0.6))
                }
            }
            Text(value).font(.system(size: 23, weight: .bold)).foregroundColor(Theme.Colors.text).lineLimit(1).minimumScaleFactor(0.7)
            Text(label).font(.system(size: 10.5)).foregroundColor(Theme.Colors.text3).lineLimit(1)
            if let p = progress {
                MiniBar(fraction: p, color: progressColor ?? tint)
                    .padding(.top, 2)
            }
            if let note {
                Text(note).font(.system(size: 9.5, weight: .medium)).foregroundColor(noteColor).lineLimit(1)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard()

        if let action {
            Button(action: action) {
                content
            }
            .buttonStyle(.plain).focusEffectDisabled()
        } else {
            content
        }
    }
}

struct ActionTileButton: View {
    let title: String
    let icon: String
    var subtitle: String? = nil
    var tone: Color = Theme.Colors.text
    var isExternal: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(colors: [tone.opacity(0.20), tone.opacity(0.10)], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: 26, height: 26)
                    Image(systemName: icon)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(tone)
                }

                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Theme.Colors.text)
                        .lineLimit(1)
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 9.5))
                            .foregroundColor(Theme.Colors.text3)
                            .lineLimit(1)
                    }
                }
                Spacer(minLength: 0)
                Image(systemName: isExternal ? "arrow.up.right" : "chevron.right")
                    .font(.system(size: 8, weight: .semibold))
                    .foregroundColor(Theme.Colors.text3.opacity(0.5))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassCard()
        }
        .buttonStyle(.plain).focusEffectDisabled()
    }
}

struct ActionPillButton: View {
    let title: String
    let icon: String
    var tone: Color = Theme.Colors.text
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .semibold))
                Text(title)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(tone)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .glassCard(radius: Theme.Layout.pillRadius)
        }
        .buttonStyle(.plain).focusEffectDisabled()
    }
}

struct MiniBar: View {
    let fraction: Double
    var color: Color = Theme.Colors.text2
    var body: some View {
        GeometryReader { g in
            ZStack(alignment: .leading) {
                Capsule().fill(Theme.Colors.hairline)
                Capsule().fill(color).frame(width: max(3, g.size.width * min(1, fraction)))
            }
        }.frame(height: 4)
    }
}

/// A floating "liquid glass" header: a tinted, refractive panel that sits above the content rather
/// than a flat bar flush with the window edge — continuous-corner shape, a specular highlight along
/// the top edge standing in for a light catch, and a real shadow separating it from what's behind it.
struct TopStrip: View {
    let title: String
    let subtitle: String
    let kind: ConnectionKind
    var icon: String? = nil
    var back: (() -> Void)? = nil
    var backLabel: String = "Back"
    var statusBadge: (text: String, color: Color)? = nil

    private var accent: Color { Theme.Colors.accent(kind) }
    private var resolvedIcon: String { icon ?? (kind == .cpanel ? "globe" : "server.rack") }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let back {
                Button(action: back) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left").font(.system(size: 10, weight: .bold))
                        Text(backLabel).font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(Theme.Colors.text3)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .focusEffectDisabled()
            }
            HStack(alignment: .center, spacing: 8) {
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

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(title)
                        .font(.system(size: 14.5, weight: .semibold))
                        .foregroundColor(Theme.Colors.text)
                        .lineLimit(1)

                    if !subtitle.isEmpty {
                        Text("·")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.Colors.text3)
                        Text(subtitle)
                            .font(.system(size: 11.5))
                            .foregroundColor(Theme.Colors.text3)
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 6)

                if let statusBadge {
                    PillLabel(text: statusBadge.text)
                }
            }
        }
        .padding(.horizontal, Theme.Layout.gutter)
        .padding(.top, 14)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct StatusBadgePill: View {
    let text: String
    let color: Color
    var body: some View {
        Text(text.uppercased()).font(.system(size: 9, weight: .bold)).tracking(0.3).foregroundColor(color)
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(color.opacity(0.14), in: Capsule())
    }
}

struct TableHeader: View {
    let columns: [String]
    var body: some View {
        HStack {
            ForEach(columns.indices, id: \.self) { i in
                Text(columns[i]).font(.system(size: 9.5, weight: .bold)).tracking(0.4).foregroundColor(Theme.Colors.text3)
                    .frame(maxWidth: i == 0 ? .infinity : nil, alignment: .leading)
            }
        }
        .padding(.horizontal, Theme.Layout.gutter).padding(.vertical, 7)
        .background(Theme.Colors.cardAlt)
    }
}

struct SectionLabel: View {
    let text: String
    var trailing: String? = nil
    var body: some View {
        HStack {
            Text(text.uppercased()).font(.system(size: 10.5, weight: .bold)).tracking(0.4).foregroundColor(Theme.Colors.text3)
            Spacer()
            if let trailing { Text(trailing).font(.system(size: 11).monospacedDigit()).foregroundColor(Theme.Colors.text3) }
        }
        .padding(.horizontal, Theme.Layout.gutter)
    }
}

struct KV: View {
    let key: String
    let value: String
    var body: some View {
        HStack {
            Text(key).font(.system(size: 11.5)).foregroundColor(Theme.Colors.text2)
            Spacer()
            Text(value).font(.system(size: 11.5, weight: .medium).monospacedDigit()).foregroundColor(Theme.Colors.text).lineLimit(1)
        }
        .padding(.horizontal, Theme.Layout.gutter).padding(.vertical, 6)
        .background(Theme.Colors.card)
    }
}

struct DetailSection<Content: View>: View {
    let title: String
    var trailing: String? = nil
    @ViewBuilder let content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            SectionLabel(text: title, trailing: trailing)
            VStack(spacing: 0) { content }
                .clipShape(RoundedRectangle(cornerRadius: Theme.Layout.cardRadius))
                .overlay(RoundedRectangle(cornerRadius: Theme.Layout.cardRadius).stroke(Theme.Colors.border, lineWidth: 1))
                .shadow(color: Theme.Colors.cardShadow, radius: 10, x: 0, y: 4)
                .padding(.horizontal, Theme.Layout.gutter)
        }.padding(.top, 16)
    }
}

struct FooterBar: View {
    let text: String
    let onRefresh: () -> Void
    let onSettings: () -> Void
    var onQuit: (() -> Void)? = nil
    var isLoading: Bool = false
    @Environment(\.appLanguage) private var language

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onRefresh) {
                if isLoading {
                    ProgressView().scaleEffect(0.5).frame(width: 10, height: 10)
                } else {
                    Image(systemName: "arrow.clockwise").font(.system(size: 10))
                }
            }
            .buttonStyle(.plain).focusEffectDisabled()
            .help(language.strings.refreshTooltip)

            Text(text).font(.system(size: 11))

            Spacer()

            Button(action: onSettings) {
                Image(systemName: "gearshape").font(.system(size: 12))
            }
            .buttonStyle(.plain).focusEffectDisabled()
            .help(language.strings.settingsTooltip)

            if let onQuit {
                Button(action: onQuit) {
                    Image(systemName: "power").font(.system(size: 11, weight: .semibold))
                }
                .buttonStyle(.plain).focusEffectDisabled()
                .foregroundColor(Theme.Colors.red)
                .help(language.strings.quitTooltip)
            }
        }
        .foregroundColor(Theme.Colors.text3).padding(.horizontal, Theme.Layout.gutter).padding(.vertical, 10)
        .overlay(alignment: .top) { Rectangle().fill(Theme.Colors.hairline).frame(height: 1) }
        .background(Theme.Colors.card)
    }
}

struct FormField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var mono = false
    var secure = false
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label).font(.system(size: 11, weight: .medium)).foregroundColor(Theme.Colors.text2)
            Group {
                if secure {
                    SecureField(placeholder, text: $text).textFieldStyle(.plain)
                } else {
                    TextField(placeholder, text: $text).textFieldStyle(.plain)
                }
            }
            .font(.system(size: 12.5, design: mono ? .monospaced : .default))
            .padding(.horizontal, 10).padding(.vertical, 8)
            .background(Theme.Colors.card, in: RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.Colors.border, lineWidth: 1))
        }
    }
}

struct SwitchControl: View {
    @Binding var isOn: Bool
    var tint: Color = Theme.Colors.cpanelOrange
    var body: some View {
        Button { isOn.toggle() } label: {
            Capsule().fill(isOn ? tint : Theme.Colors.hairline).frame(width: 32, height: 19)
                .overlay(alignment: isOn ? .trailing : .leading) { Circle().fill(.white).frame(width: 15, height: 15).padding(2) }
        }
        .buttonStyle(.plain).focusEffectDisabled()
    }
}
