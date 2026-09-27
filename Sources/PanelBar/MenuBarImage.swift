import AppKit
import PanelBarCore

/// Draws the menu bar item: a plain glyph (following light/dark bar tinting) plus a status dot, and an
/// optional stat. No colored tile: that accent belongs to the popover, not the system menu bar.
@MainActor
enum MenuBarImage {
    private static let height: CGFloat = 18
    private static let glyphWidth: CGFloat = 17
    private static var font: NSFont { NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium) }
    private static var amber: NSColor { NSColor(red: 0.85, green: 0.62, blue: 0, alpha: 1) }

    static func make(state: AppState) -> NSImage {
        let text = state.menuBarText
        let textWidth = text.map { ceil(($0 as NSString).size(withAttributes: [.font: font]).width) } ?? 0
        let width = glyphWidth + (textWidth > 0 ? 3 + textWidth : 0) + 1
        let image = NSImage(size: NSSize(width: width, height: height), flipped: false) { _ in
            draw(state: state, text: text)
            return true
        }
        image.isTemplate = false
        image.accessibilityDescription = state.menuBarTooltip
        return image
    }

    private static func draw(state: AppState, text: String?) {
        let offline = state.connection == .offline
        let ink = NSColor.labelColor.withAlphaComponent(offline ? 0.4 : 0.9)

        let configuration = NSImage.SymbolConfiguration(pointSize: 12.5, weight: .semibold)
        if let symbol = NSImage(systemSymbolName: "cylinder.split.1x2", accessibilityDescription: nil)?
            .withSymbolConfiguration(configuration) {
            let target = NSRect(x: 0, y: 2, width: 15, height: 14)
            let tinted = NSImage(size: target.size, flipped: false) { rect in
                symbol.draw(in: rect)
                ink.set()
                rect.fill(using: .sourceAtop)
                return true
            }
            tinted.draw(in: target)
        }

        let badge = NSRect(x: 9, y: 0, width: 7, height: 7)
        if let context = NSGraphicsContext.current {
            context.saveGraphicsState()
            context.compositingOperation = .clear
            NSBezierPath(ovalIn: badge.insetBy(dx: -1.6, dy: -1.6)).fill()
            context.restoreGraphicsState()
        }

        if state.isUnauthorized {
            if let lock = NSImage(systemSymbolName: "lock.fill", accessibilityDescription: nil)?
                .withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 7, weight: .bold)) {
                let tinted = NSImage(size: lock.size, flipped: false) { rect in
                    lock.draw(in: rect)
                    amber.set()
                    rect.fill(using: .sourceAtop)
                    return true
                }
                tinted.draw(in: NSRect(x: badge.midX - lock.size.width / 2, y: badge.midY - lock.size.height / 2, width: lock.size.width, height: lock.size.height))
            }
        } else {
            dotColor(state).setFill()
            NSBezierPath(ovalIn: badge).fill()
        }

        if let text {
            let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: ink]
            let size = (text as NSString).size(withAttributes: attributes)
            (text as NSString).draw(at: NSPoint(x: glyphWidth + 3, y: (height - size.height) / 2), withAttributes: attributes)
        }
    }

    private static func dotColor(_ state: AppState) -> NSColor {
        switch state.connection {
        case .online: return state.isDegraded ? amber : .systemGreen
        case .unauthorized: return amber
        case .offline: return .systemGray
        }
    }
}
