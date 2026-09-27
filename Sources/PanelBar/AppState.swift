import SwiftUI
import AppKit
import ServiceManagement
import PanelBarCore

public enum ConnectionState: Equatable {
    case offline
    case unauthorized
    case online
}

public enum PopoverView: Equatable {
    case dashboard, addServer, settings
}

public enum CPanelTab: String, CaseIterable { case overview = "Overview", domains = "Domains" }
public enum WHMTab: String, CaseIterable { case overview = "Overview", accounts = "Accounts", services = "Services" }

@MainActor
public final class AppState: ObservableObject {
    // MARK: Profiles

    @Published public var profiles: [ConnectionProfile] = [] {
        didSet { if !isSnapshot { ConnectionProfile.saveAll(profiles) } }
    }
    @Published public var activeProfileID: UUID? {
        didSet {
            guard oldValue != activeProfileID else { return }
            if !isSnapshot, let id = activeProfileID { UserDefaults.standard.set(id.uuidString, forKey: ConnectionProfile.activeIDKey) }
            Task { await handleActiveProfileChanged() }
        }
    }
    public var activeProfile: ConnectionProfile? { profiles.first { $0.id == activeProfileID } }

    // MARK: Navigation

    @Published public var currentView: PopoverView = .dashboard
    @Published public var cpanelTab: CPanelTab = .overview
    @Published public var whmTab: WHMTab = .overview
    @Published public var searchQuery: String = ""
    @Published public var isProfileSwitcherOpen: Bool = false
    /// Which Settings dropdown picker (if any) is currently open — identified by a short string
    /// key ("appearance", "language", etc). Only one can be open at a time.
    @Published public var openSettingsPickerID: String? = nil

    // MARK: Connection + data

    @Published public var connection: ConnectionState = .offline
    @Published public var connectionError: PanelClientError?
    @Published public var isLoading = false
    @Published public var lastChecked: Date?
    @Published public var apiKeyDraft: String = ""

    @Published public var quota: QuotaInfo?
    @Published public var domainStatuses: [DomainSSLStatus] = []

    @Published public var whmAccounts: [WHMAccount] = []
    @Published public var selectedWHMAccount: WHMAccount? = nil
    @Published public var whmServices: [WHMService] = []
    @Published public var systemLoad: WHMSystemLoad?
    @Published public var diskUsage: WHMDiskUsageResult?
    @Published public var hostname: String?
    @Published public var whmVersion: String?

    // MARK: Add / connect form

    @Published public var newName = ""
    @Published public var newKind: ConnectionKind = .cpanel
    @Published public var newURL = "https://host.example.com:2083"
    @Published public var newUsername = ""
    @Published public var newToken = ""
    @Published public var newAllowInsecure = false
    @Published public var isTestingConnection = false
    @Published public var testResult: String?
    @Published public var testSuccess: Bool?
    @Published public var testNeedsKey = false

    // MARK: Edit server form

    @Published public var editingProfile: ConnectionProfile? = nil
    @Published public var editName = ""
    @Published public var editKind: ConnectionKind = .cpanel
    @Published public var editURL = ""
    @Published public var editUsername = ""
    @Published public var editToken = ""
    @Published public var editAllowInsecure = false
    @Published public var isTestingEditConnection = false
    @Published public var editTestResult: String?
    @Published public var editTestSuccess: Bool?
    @Published public var editTestNeedsKey = false
    @Published public var isConfirmingDeleteProfile = false

    // MARK: Onboarding

    @Published public var hasCompletedOnboarding: Bool {
        didSet { if !isSnapshot { UserDefaults.standard.set(hasCompletedOnboarding, forKey: "panelbar_has_completed_onboarding") } }
    }
    @Published public var onboardingStep: Int = 0

    // MARK: Settings

    @Published public var settings: AppSettings {
        didSet {
            let clean = settings.normalized()
            if clean != settings { settings = clean; return }
            if !isSnapshot { settings.save() }
            if oldValue.backgroundRefreshMinutes != settings.backgroundRefreshMinutes { startBackgroundTimer() }
            if oldValue.appearance != settings.appearance { updateThemeAppearanceOverride() }
        }
    }

    private func updateThemeAppearanceOverride() {
        switch settings.appearance {
        case .system: ThemeAppearanceOverride.isDark = nil
        case .light: ThemeAppearanceOverride.isDark = false
        case .dark: ThemeAppearanceOverride.isDark = true
        }
    }
    public var language: AppLanguage { settings.language.resolved }
    public var strings: LocalizedStrings { language.strings }

    public func setLanguage(_ value: AppLanguage) {
        settings.language = value
    }

    @Published public var launchAtLogin: Bool = false {
        didSet { setLaunchAtLogin(launchAtLogin) }
    }
    @Published public var launchAtLoginMessage: String?
    @Published public var requireTouchID: Bool = UserDefaults.standard.bool(forKey: "panelbar_require_touch_id") {
        didSet { if !isSnapshot { UserDefaults.standard.set(requireTouchID, forKey: "panelbar_require_touch_id") } }
    }

    @Published public var isPopoverOpen: Bool = false {
        didSet {
            guard isPopoverOpen != oldValue else { return }
            if isPopoverOpen { startOpenRefreshLoop() } else { openRefreshTask?.cancel(); openRefreshTask = nil }
        }
    }

    // MARK: Updates

    public enum UpdateStatus: Equatable {
        case idle
        case checking
        case upToDate(version: String)
        case updateAvailable(version: String, releaseURL: URL)
        case error(message: String)
    }

    @Published public var updateStatus: UpdateStatus = .idle
    private lazy var updateChecker = UpdateChecker(currentVersion: appVersion)

    public var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.1.0"
    }

    public let isSnapshot: Bool
    private var client: PanelClient?
    private var backgroundTimer: Timer?
    private var openRefreshTask: Task<Void, Never>?
    private var isRevertingLaunchAtLogin = false

    public init(startServices: Bool = true) {
        self.isSnapshot = !startServices
        self.settings = startServices ? AppSettings.load() : AppSettings()
        self.hasCompletedOnboarding = startServices ? UserDefaults.standard.bool(forKey: "panelbar_has_completed_onboarding") : true
        // didSet doesn't fire for this first assignment, so the override needs setting explicitly.
        switch self.settings.appearance {
        case .system: ThemeAppearanceOverride.isDark = nil
        case .light: ThemeAppearanceOverride.isDark = false
        case .dark: ThemeAppearanceOverride.isDark = true
        }

        let loaded = startServices ? ConnectionProfile.loadAll() : []
        self.profiles = loaded
        let savedID = startServices ? UserDefaults.standard.string(forKey: ConnectionProfile.activeIDKey).flatMap(UUID.init) : nil
        self.activeProfileID = savedID ?? loaded.first?.id

        if #available(macOS 13.0, *) { self.launchAtLogin = SMAppService.mainApp.status == .enabled }

        guard startServices else { return }
        Task {
            await handleActiveProfileChanged()
            startBackgroundTimer()
            if profiles.isEmpty { launchOnboardingWindow() }
        }
    }

    public func launchOnboardingWindow(step: Int = 0) {
        onboardingStep = step
        resetForm()
        OnboardingWindowManager.shared.show(appState: self)
    }

    // MARK: Profile switching

    private func handleActiveProfileChanged() async {
        guard let profile = activeProfile else {
            client = nil
            connection = .offline
            return
        }
        let token = await KeychainManager.shared.getToken(for: profile.id) ?? ""
        guard let credentials = profile.credentials(apiToken: token) else {
            client = nil
            return
        }
        client = PanelClient(credentials: credentials)
        await refreshAll()
    }

    public func switchProfile(to profile: ConnectionProfile) {
        guard activeProfileID != profile.id else { return }
        activeProfileID = profile.id
    }

    public func deleteProfile(_ id: UUID) {
        Task {
            if requireTouchID && TouchIDManager.shared.isTouchIDAvailable {
                let ok = await TouchIDManager.shared.authenticate(reason: strings.touchIDPromptDelete)
                guard ok else { return }
            }
            profiles.removeAll { $0.id == id }
            try? await KeychainManager.shared.deleteToken(for: id)
            if activeProfileID == id {
                activeProfileID = profiles.first?.id
                if activeProfileID == nil { clearData() }
            }
            if editingProfile?.id == id { editingProfile = nil }
        }
    }

    public func updateProfile(_ profile: ConnectionProfile, newApiToken: String? = nil) {
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[index] = profile
            if let newApiToken = newApiToken, !newApiToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Task {
                    try? await KeychainManager.shared.saveToken(newApiToken.trimmingCharacters(in: .whitespacesAndNewlines), for: profile.id)
                    if activeProfileID == profile.id {
                        await handleActiveProfileChanged()
                    }
                }
            } else if activeProfileID == profile.id {
                Task { await handleActiveProfileChanged() }
            }
        }
    }

    public func startEditingProfile(_ profile: ConnectionProfile) {
        Task {
            if requireTouchID && TouchIDManager.shared.isTouchIDAvailable {
                let ok = await TouchIDManager.shared.authenticate(reason: strings.touchIDPromptEdit(name: profile.name))
                guard ok else { return }
            }
            editingProfile = profile
            editName = profile.name
            editKind = profile.kind
            editURL = profile.urlString
            editUsername = profile.username
            editToken = ""
            editAllowInsecure = profile.allowInsecureHTTP
            editTestResult = nil
            editTestSuccess = nil
            editTestNeedsKey = false
            if let token = await KeychainManager.shared.getToken(for: profile.id) {
                editToken = token
            }
        }
    }

    public func toggleTouchID() {
        Task {
            if !requireTouchID {
                let ok = await TouchIDManager.shared.authenticate(reason: strings.touchIDPromptEnable)
                if ok { requireTouchID = true }
            } else {
                let ok = await TouchIDManager.shared.authenticate(reason: strings.touchIDPromptDisable)
                if ok { requireTouchID = false }
            }
        }
    }

    public func saveEditedProfile() {
        guard let existing = editingProfile else { return }
        let updated = ConnectionProfile(
            id: existing.id,
            name: editName.isEmpty ? (editKind == .cpanel ? "cPanel account" : "WHM server") : editName,
            kind: editKind,
            urlString: editURL.trimmingCharacters(in: .whitespacesAndNewlines),
            username: editUsername.trimmingCharacters(in: .whitespacesAndNewlines),
            allowInsecureHTTP: editAllowInsecure
        )
        updateProfile(updated, newApiToken: editToken)
        editingProfile = nil
    }

    public func cancelEditingProfile() {
        editingProfile = nil
    }

    public func testEditConnection() async {
        isTestingEditConnection = true
        editTestResult = nil; editTestSuccess = nil; editTestNeedsKey = false
        defer { isTestingEditConnection = false }

        guard let url = URL(string: editURL.trimmingCharacters(in: .whitespacesAndNewlines)), url.host != nil else {
            editTestResult = "Invalid server URL"; editTestSuccess = false; return
        }
        let credentials = AccountCredentials(kind: editKind, baseURL: url, username: editUsername, apiToken: editToken, allowInsecureHTTP: editAllowInsecure)
        let testClient = PanelClient(credentials: credentials)
        do {
            try await testClient.verifyConnection()
            let extra: String
            switch editKind {
            case .cpanel:
                let domains = (try? await testClient.fetchDomains())?.all.count ?? 0
                extra = "\(domains) domain\(domains == 1 ? "" : "s")"
            case .whm:
                if let accounts = try? await testClient.fetchAccounts() {
                    extra = "\(accounts.count) account\(accounts.count == 1 ? "" : "s")"
                } else if let version = try? await testClient.fetchWHMVersion() {
                    extra = "v\(version)"
                } else {
                    extra = "Online"
                }
            }
            editTestResult = "Connected · \(extra)"
            editTestSuccess = true
        } catch PanelClientError.unauthorized {
            editTestResult = "Server reachable, but the token was rejected"
            editTestSuccess = false
            editTestNeedsKey = true
        } catch let error as PanelClientError {
            editTestResult = error.errorDescription
            editTestSuccess = false
        } catch {
            editTestResult = error.localizedDescription
            editTestSuccess = false
        }
    }

    // MARK: Add server / test connection

    public func resetForm() {
        newName = ""; newKind = .cpanel; newURL = "https://host.example.com:2083"; newUsername = ""; newToken = ""
        newAllowInsecure = false
        resetTestResult()
    }

    public func resetTestResult() {
        testResult = nil; testSuccess = nil; testNeedsKey = false
    }

    public func navigateToAddServer() {
        resetForm()
        currentView = .addServer
    }

    public func testConnection() async {
        isTestingConnection = true
        resetTestResult()
        defer { isTestingConnection = false }

        guard let url = URL(string: newURL.trimmingCharacters(in: .whitespacesAndNewlines)), url.host != nil else {
            testResult = "Invalid server URL"; testSuccess = false; return
        }
        let credentials = AccountCredentials(kind: newKind, baseURL: url, username: newUsername, apiToken: newToken, allowInsecureHTTP: newAllowInsecure)
        let testClient = PanelClient(credentials: credentials)
        do {
            try await testClient.verifyConnection()
            let extra: String
            switch newKind {
            case .cpanel:
                let domains = (try? await testClient.fetchDomains())?.all.count ?? 0
                extra = "\(domains) domain\(domains == 1 ? "" : "s")"
            case .whm:
                if let accounts = try? await testClient.fetchAccounts() {
                    extra = "\(accounts.count) account\(accounts.count == 1 ? "" : "s")"
                } else if let version = try? await testClient.fetchWHMVersion() {
                    extra = "v\(version)"
                } else {
                    extra = "Online"
                }
            }
            testResult = "Connected · \(extra)"
            testSuccess = true
        } catch PanelClientError.unauthorized {
            testResult = "Server reachable, but the token was rejected"
            testSuccess = false
            testNeedsKey = true
        } catch let error as PanelClientError {
            testResult = error.errorDescription
            testSuccess = false
        } catch {
            testResult = error.localizedDescription
            testSuccess = false
        }
    }

    public func saveNewProfile() {
        let profile = ConnectionProfile(
            name: newName.isEmpty ? (newKind == .cpanel ? "cPanel account" : "WHM server") : newName,
            kind: newKind,
            urlString: newURL.trimmingCharacters(in: .whitespacesAndNewlines),
            username: newUsername.trimmingCharacters(in: .whitespacesAndNewlines),
            allowInsecureHTTP: newAllowInsecure
        )
        let token = newToken
        profiles.append(profile)
        Task { try? await KeychainManager.shared.saveToken(token, for: profile.id) }
        switchProfile(to: profile)
    }

    /// Saves a replacement token for the active profile (the "needs a token" recovery path).
    public func saveApiKey(_ key: String) async {
        let clean = key.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty, let profile = activeProfile else { return }
        try? await KeychainManager.shared.saveToken(clean, for: profile.id)
        await handleActiveProfileChanged()
    }

    // MARK: Refresh

    private func startOpenRefreshLoop() {
        openRefreshTask?.cancel()
        guard !isSnapshot else { return }
        openRefreshTask = Task { [weak self] in
            while !Task.isCancelled {
                guard let self else { return }
                await self.refreshAll()
                try? await Task.sleep(nanoseconds: UInt64(self.settings.openRefreshMinutes) * 60_000_000_000)
            }
        }
    }

    private func startBackgroundTimer() {
        backgroundTimer?.invalidate(); backgroundTimer = nil
        guard !isSnapshot, settings.backgroundRefreshMinutes > 0 else { return }
        backgroundTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(settings.backgroundRefreshMinutes * 60), repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self, !self.isPopoverOpen else { return }
                await self.refreshAll()
            }
        }
    }

    public func refreshAll() async {
        guard let client, let profile = activeProfile else { return }
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false; lastChecked = Date() }

        do {
            try await client.verifyConnection()
        } catch PanelClientError.unauthorized {
            connection = .unauthorized
            connectionError = .unauthorized
            clearData()
            return
        } catch {
            connection = .offline
            connectionError = error as? PanelClientError
            clearData()
            return
        }

        switch profile.kind {
        case .cpanel:
            async let quotaTask = try? client.fetchQuota()
            async let domainsTask = try? client.fetchDomains()
            async let certsTask = try? client.fetchCertificates()
            let (q, domains, certs) = await (quotaTask, domainsTask, certsTask)
            quota = q
            if let domains { domainStatuses = DomainSSL.merge(domains: domains, certificates: certs ?? []) }
        case .whm:
            async let accountsTask = try? client.fetchAccounts()
            async let servicesTask = try? client.fetchServices()
            async let loadTask = try? client.fetchSystemLoad()
            async let diskTask = try? client.fetchDiskUsage()
            async let hostTask = try? client.fetchHostname()
            async let versionTask = try? client.fetchWHMVersion()
            let (accounts, services, load, disk, host, version) = await (accountsTask, servicesTask, loadTask, diskTask, hostTask, versionTask)
            whmAccounts = accounts ?? []
            whmServices = services ?? []
            systemLoad = load
            diskUsage = disk
            hostname = host
            whmVersion = version
        }
        connection = .online
        connectionError = nil
    }

    private func clearData() {
        quota = nil; domainStatuses = []
        whmAccounts = []; selectedWHMAccount = nil; whmServices = []; systemLoad = nil; diskUsage = nil; hostname = nil; whmVersion = nil
    }

    public var isHealthy: Bool { connection == .online }
    public var isUnauthorized: Bool { connection == .unauthorized }

    // MARK: Menu bar

    public var menuBarText: String? {
        guard let profile = activeProfile else { return nil }
        switch connection {
        case .offline:
            return settings.hideStatWhenOffline ? nil : "off"
        case .unauthorized:
            return settings.menuBarStat == .none ? nil : "key"
        case .online:
            switch settings.menuBarStat {
            case .none: return nil
            case .primary:
                switch profile.kind {
                case .cpanel:
                    guard let fraction = quota?.usedFraction else { return "\u{221E}" }
                    return "\(Int((fraction * 100).rounded()))%"
                case .whm:
                    return "\(whmAccounts.count)"
                }
            case .sslDaysLeft:
                if profile.kind == .cpanel {
                    return domainStatuses.first?.daysLeft.map { "\($0)d" } ?? "\u{2014}"
                }
                return "\(whmServices.down.count)"
            }
        }
    }

    public var menuBarTooltip: String {
        var parts = ["PanelBar"]
        if let profile = activeProfile { parts.append(profile.name) }
        switch connection {
        case .online: parts.append(strings.statusOnline)
        case .unauthorized: parts.append(strings.statusNeedsToken)
        case .offline: parts.append(strings.statusOffline)
        }
        return parts.joined(separator: " \u{B7} ")
    }

    public var isDegraded: Bool {
        guard connection == .online, let profile = activeProfile else { return false }
        switch profile.kind {
        case .cpanel: return domainStatuses.contains { SSLUrgency(daysLeft: $0.daysLeft) != .none }
        case .whm: return !whmServices.down.isEmpty || whmAccounts.contains { $0.isSuspended }
        }
    }

    // MARK: Actions

    public func openDashboard() {
        guard let profile = activeProfile, let url = URL(string: profile.urlString) else { return }
        NSWorkspace.shared.open(url)
    }

    public func openWebmail() {
        guard let profile = activeProfile, let url = URL(string: profile.urlString), let host = url.host else { return }
        let webmailURL = URL(string: "https://\(host):2096") ?? url
        NSWorkspace.shared.open(webmailURL)
    }

    public func openURL(_ url: URL) {
        NSWorkspace.shared.open(url)
    }

    public func copyText(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }

    public func openSettings() { currentView = .settings }
    public func closeSettings() { currentView = .dashboard }
    public func closeAddServer() { currentView = .dashboard }

    private func setLaunchAtLogin(_ enabled: Bool) {
        guard !isRevertingLaunchAtLogin, !isSnapshot else { return }
        let status = SMAppService.mainApp.status
        let isOn = status == .enabled || status == .requiresApproval
        guard enabled != isOn else {
            launchAtLoginMessage = status == .requiresApproval ? "Approve PanelBar in System Settings > Login Items." : nil
            return
        }
        do {
            if enabled { try SMAppService.mainApp.register() } else { try SMAppService.mainApp.unregister() }
            launchAtLoginMessage = SMAppService.mainApp.status == .requiresApproval ? "Approve PanelBar in System Settings > Login Items." : nil
        } catch {
            launchAtLoginMessage = "Couldn't change Launch at login: \(error.localizedDescription)"
            isRevertingLaunchAtLogin = true
            launchAtLogin = !enabled
            isRevertingLaunchAtLogin = false
        }
    }

    public func checkForUpdates() async {
        guard updateStatus != .checking else { return }
        updateStatus = .checking
        do {
            let result = try await updateChecker.checkForUpdates()
            switch result {
            case .upToDate(let version):
                updateStatus = .upToDate(version: version)
            case .updateAvailable(let version, let url):
                updateStatus = .updateAvailable(version: version, releaseURL: url)
            }
        } catch {
            updateStatus = .error(message: "Couldn't check for updates")
        }
    }

    public func exitApp() {
        NSApplication.shared.terminate(nil)
    }
}
