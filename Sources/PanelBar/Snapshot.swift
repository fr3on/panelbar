#if DEBUG
import AppKit
import SwiftUI
import PanelBarCore

/// `PanelBar --snapshot out.png` renders the popover in several states with fixture data, then exits.
/// Never touches the network, the Keychain or saved profiles.
@MainActor
enum Snapshot {
    static func runIfRequested() {
        let args = CommandLine.arguments
        guard let flag = args.firstIndex(of: "--snapshot"), args.indices.contains(flag + 1) else { return }
        _ = NSApplication.shared

        func panel(_ title: String, _ state: AppState) -> some View {
            VStack(alignment: .leading, spacing: 10) {
                Text(title).font(.system(size: 13, weight: .medium)).foregroundStyle(.white.opacity(0.6))
                ContentView().environmentObject(state)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.12), lineWidth: 1))
            }
        }

        let board = HStack(alignment: .top, spacing: 26) {
            panel("cPanel \u{B7} Overview", cpanel())
            panel("cPanel \u{B7} needs a token", cpanelUnauthorized())
            panel("WHM \u{B7} Overview", whm())
            panel("WHM \u{B7} Accounts", whmAccounts())
            panel("WHM \u{B7} Services", whmServices())
            panel("WHM \u{B7} account detail", whmAccountDetail())
            panel("Settings", settings())
            panel("Add Server", addServer())
        }
        .padding(36)
        .background(Color(red: 0.06, green: 0.06, blue: 0.07))

        let renderer = ImageRenderer(content: board)
        renderer.scale = 2
        guard let image = renderer.nsImage, let tiff = image.tiffRepresentation,
              let rep = NSBitmapImageRep(data: tiff), let png = rep.representation(using: .png, properties: [:])
        else { print("snapshot failed"); exit(1) }
        try? png.write(to: URL(fileURLWithPath: args[flag + 1]))
        print("wrote \(args[flag + 1])")
        exit(0)
    }

    private static func cpanelProfile() -> ConnectionProfile {
        ConnectionProfile(name: "agency-client", kind: .cpanel, urlString: "https://host.example.com:2083", username: "agency")
    }
    private static func whmProfile() -> ConnectionProfile {
        ConnectionProfile(name: "srv1.host.example.com", kind: .whm, urlString: "https://srv1.host.example.com:2087", username: "root")
    }

    private static func cpanel() -> AppState {
        let state = AppState(startServices: false)
        state.profiles = [cpanelProfile()]
        state.activeProfileID = state.profiles[0].id
        state.connection = .online
        state.lastChecked = Date()
        state.quota = QuotaInfo(megabytesUsed: 5460, megabyteLimit: 40000, inodesUsed: 1035, inodeLimit: 0)
        state.domainStatuses = [
            DomainSSLStatus(name: "shop.agency-client.com", kind: "Subdomain", daysLeft: 6, issuer: "R3"),
            DomainSSLStatus(name: "agency-client.com", kind: "Primary", daysLeft: 82, issuer: "R3"),
            DomainSSLStatus(name: "old-brand.com", kind: "Addon", daysLeft: nil, issuer: nil),
        ]
        return state
    }

    private static func cpanelUnauthorized() -> AppState {
        let state = AppState(startServices: false)
        state.profiles = [cpanelProfile()]
        state.activeProfileID = state.profiles[0].id
        state.connection = .unauthorized
        state.lastChecked = Date()
        return state
    }

    private static func whm() -> AppState {
        let state = AppState(startServices: false)
        state.profiles = [whmProfile()]
        state.activeProfileID = state.profiles[0].id
        state.connection = .online
        state.lastChecked = Date()
        state.systemLoad = WHMSystemLoad(one: 0.64, five: 0.81, fifteen: 0.89)
        state.diskUsage = WHMDiskUsageResult(accounts: (0..<13).map { WHMDiskUsageAccount(user: "u\($0)", blocksUsed: 10_000_000, blocksLimit: nil, inodesUsed: 1000, inodesLimit: nil) })
        state.hostname = "srv1.host.example.com"
        state.whmVersion = "11.134.0.59"
        state.whmAccounts = [
            WHMAccount(user: "acct01", domain: "acct01.example.com", disklimit: "unlimited", diskused: "48363M", suspended: 1, suspendreason: "User transferred to another server"),
            WHMAccount(user: "acct02", domain: "acct02.example.com", disklimit: "unlimited", diskused: "48.3G", suspended: 1),
            WHMAccount(user: "acct03", domain: "acct03.example.com", disklimit: "unlimited", diskused: "34.8G", suspended: 0),
        ]
        state.whmServices = [
            WHMService(name: "httpd", displayName: "Apache Web Server", enabled: true, installed: true, monitored: true, running: true),
            WHMService(name: "mysql", displayName: "Database Server", enabled: true, installed: true, monitored: true, running: true),
            WHMService(name: "mailman", displayName: "Mailman", enabled: true, installed: true, monitored: true, running: false),
            WHMService(name: "cxswatch", displayName: "cxswatch", enabled: true, installed: true, monitored: true, running: false),
        ]
        return state
    }

    private static func whmServices() -> AppState {
        let state = whm()
        state.whmTab = .services
        return state
    }

    private static func whmAccounts() -> AppState {
        let state = whm()
        state.whmTab = .accounts
        return state
    }

    private static func whmAccountDetail() -> AppState {
        let state = whm()
        state.selectedWHMAccount = state.whmAccounts.first
        return state
    }

    private static func settings() -> AppState {
        let state = whm()
        state.profiles = [whmProfile(), cpanelProfile()]
        state.activeProfileID = state.profiles[0].id
        state.currentView = .settings
        state.updateStatus = .upToDate(version: "0.3.0")
        return state
    }

    private static func addServer() -> AppState {
        let state = whm()
        state.currentView = .addServer
        state.newKind = .cpanel
        state.newName = ""
        state.newURL = "https://host.example.com:2083"
        state.newUsername = "agency"
        return state
    }
}
#endif
