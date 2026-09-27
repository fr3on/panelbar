import SwiftUI
import PanelBarCore

/// Light theme by default, matching how cPanel's own Jupiter interface actually looks.
/// Deliberately supports dark mode cleanly via dynamic AppKit colors.
public enum Theme {
    public enum Layout {
        public static let popoverWidth: CGFloat = 372
        public static let popoverHeight: CGFloat = 580
        public static let gutter: CGFloat = 16
        /// Standard radius for elevated glass cards (tiles, action buttons, detail groups).
        public static let cardRadius: CGFloat = 14
        /// Radius for pill-shaped controls (primary/secondary buttons).
        public static let pillRadius: CGFloat = 9
    }

    public enum Colors {
        private static func dynamic(light: NSColor, dark: NSColor) -> Color {
            Color(nsColor: NSColor(name: nil, dynamicProvider: { appearance in
                // `MenuBarExtra`'s popover window doesn't reliably propagate SwiftUI's
                // `.preferredColorScheme` into AppKit's own effective appearance, so an explicit
                // user choice (Settings > Appearance) is honored directly rather than trusting
                // whatever `appearance` this dynamic provider is called with.
                if let forced = ThemeAppearanceOverride.isDark {
                    return forced ? dark : light
                }
                let match = appearance.bestMatch(from: [.darkAqua, .aqua])
                return match == .darkAqua ? dark : light
            }))
        }

        public static let bg = dynamic(
            light: NSColor(red: 0.957, green: 0.961, blue: 0.965, alpha: 1),
            dark: NSColor(red: 0.118, green: 0.125, blue: 0.133, alpha: 1)
        )
        /// Translucent so the window's material shows through underneath — the "glass" in each card.
        public static let card = dynamic(
            light: NSColor.white.withAlphaComponent(0.6),
            dark: NSColor(red: 0.165, green: 0.176, blue: 0.188, alpha: 0.6)
        )
        public static let cardAlt = dynamic(
            light: NSColor.white.withAlphaComponent(0.4),
            dark: NSColor(red: 0.141, green: 0.149, blue: 0.161, alpha: 0.4)
        )
        /// A fully opaque card — no material, no translucency — for surfaces that should read as
        /// plain and solid rather than "glass" (e.g. the dashboard header).
        public static let solidCard = dynamic(
            light: NSColor.white,
            dark: NSColor(red: 0.165, green: 0.176, blue: 0.188, alpha: 1)
        )
        public static let solidBorder = dynamic(
            light: NSColor.black.withAlphaComponent(0.08),
            dark: NSColor.white.withAlphaComponent(0.10)
        )
        /// A soft light-catching edge rather than a flat outline, doubling as the top highlight on glass cards.
        public static let border = dynamic(
            light: NSColor.white.withAlphaComponent(0.5),
            dark: NSColor.white.withAlphaComponent(0.14)
        )
        public static let hairline = dynamic(
            light: NSColor.black.withAlphaComponent(0.07),
            dark: NSColor.white.withAlphaComponent(0.08)
        )
        public static let cardShadow = dynamic(
            light: NSColor.black.withAlphaComponent(0.10),
            dark: NSColor.black.withAlphaComponent(0.45)
        )

        public static let pillBackground = dynamic(
            light: NSColor(red: 0.89, green: 0.89, blue: 0.90, alpha: 1.0),
            dark: NSColor(red: 0.180, green: 0.184, blue: 0.212, alpha: 1.0)
        )

        public static let text = dynamic(
            light: NSColor(red: 0.106, green: 0.118, blue: 0.126, alpha: 1),
            dark: NSColor(red: 0.933, green: 0.941, blue: 0.949, alpha: 1)
        )
        public static let text2 = dynamic(
            light: NSColor(red: 0.337, green: 0.365, blue: 0.384, alpha: 1),
            dark: NSColor(red: 0.686, green: 0.710, blue: 0.733, alpha: 1)
        )
        public static let text3 = dynamic(
            light: NSColor(red: 0.541, green: 0.565, blue: 0.584, alpha: 1),
            dark: NSColor(red: 0.500, green: 0.525, blue: 0.545, alpha: 1)
        )

        public static let cpanelOrange = Color(nsColor: NSColor(red: 1.0, green: 0.424, blue: 0.173, alpha: 1))
        public static let whmBlue = Color(nsColor: NSColor(red: 0.140, green: 0.440, blue: 0.780, alpha: 1))

        public static let green = Color(nsColor: NSColor(red: 0.140, green: 0.650, blue: 0.380, alpha: 1))
        public static let amber = Color(nsColor: NSColor(red: 0.850, green: 0.600, blue: 0.05, alpha: 1))
        public static let red = Color(nsColor: NSColor(red: 0.900, green: 0.300, blue: 0.220, alpha: 1))
        public static let gray = Color(nsColor: NSColor(red: 0.604, green: 0.627, blue: 0.647, alpha: 1))

        public static func accent(_ kind: ConnectionKind) -> Color { kind == .cpanel ? cpanelOrange : whmBlue }
        public static let onAccent = Color.white
    }

    public enum Typography {
        public static let heroNumber = Font.system(size: 38, weight: .light, design: .rounded)
    }
}

/// Holds the user's explicit Appearance choice (System/Light/Dark) so `Theme.Colors`'s dynamic
/// `NSColor`s can honor it directly. `nil` means "follow the system", matching `.system`.
/// AppState updates this whenever `settings.appearance` changes; it must stay in sync with that,
/// not be written from anywhere else.
enum ThemeAppearanceOverride {
    // Read from NSColor's dynamicProvider, which AppKit can invoke off the main thread during
    // drawing; written only from AppState on the main actor when the user changes Appearance.
    // A stale read is at worst one frame of the previous appearance, so this doesn't need a lock.
    nonisolated(unsafe) static var isDark: Bool? = nil
}

/// The window-level backdrop every popover/window content sits on: a blurred system material
/// with a translucent color wash on top, so `Theme.Colors.card`'s own translucency has something
/// to show through.
struct GlassBackdrop: View {
    var body: some View {
        ZStack {
            Rectangle().fill(.regularMaterial)
            Theme.Colors.bg.opacity(0.55)
        }
    }
}

extension View {
    /// The shared "glass card" treatment: translucent material fill, a soft light-catching edge,
    /// and a diffuse shadow — used for every elevated tile, button and detail group.
    func glassCard(radius: CGFloat = Theme.Layout.cardRadius) -> some View {
        self
            .background(Theme.Colors.card, in: RoundedRectangle(cornerRadius: radius))
            .overlay(RoundedRectangle(cornerRadius: radius).stroke(Theme.Colors.border, lineWidth: 1))
            .shadow(color: Theme.Colors.cardShadow, radius: 10, x: 0, y: 4)
    }

    /// A plain, opaque card — same shape language as `glassCard`, no material or translucency.
    func solidCard(radius: CGFloat = Theme.Layout.cardRadius) -> some View {
        self
            .background(Theme.Colors.solidCard, in: RoundedRectangle(cornerRadius: radius))
            .overlay(RoundedRectangle(cornerRadius: radius).stroke(Theme.Colors.solidBorder, lineWidth: 1))
            .shadow(color: Theme.Colors.cardShadow, radius: 10, x: 0, y: 4)
    }
}
