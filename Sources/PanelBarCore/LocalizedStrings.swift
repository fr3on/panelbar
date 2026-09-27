import Foundation

/// Centralized, type-safe localization strings for PanelBar.
public struct LocalizedStrings: Sendable {
    public let language: AppLanguage

    public init(language: AppLanguage) {
        self.language = language.resolved
    }

    // MARK: - Settings & Menus

    public var settings: String {
        switch language {
        case .zhHans: "设置"
        case .ja: "設定"
        case .de: "Einstellungen"
        case .es: "Ajustes"
        case .fr: "Réglages"
        case .tr: "Ayarlar"
        default: "Settings"
        }
    }

    public var languageTitle: String {
        switch language {
        case .zhHans: "语言"
        case .ja: "言語"
        case .de: "Sprache"
        case .es: "Idioma"
        case .fr: "Langue"
        case .tr: "Dil"
        default: "Language"
        }
    }

    public var systemDefault: String {
        switch language {
        case .zhHans: "系统默认"
        case .ja: "システム標準"
        case .de: "Systemstandard"
        case .es: "Predeterminado del sistema"
        case .fr: "Par défaut du système"
        case .tr: "Sistem Varsayılanı"
        default: "System Default"
        }
    }

    public var back: String {
        switch language {
        case .zhHans: "返回"
        case .ja: "戻る"
        case .de: "Zurück"
        case .es: "Atrás"
        case .fr: "Retour"
        case .tr: "Geri"
        default: "Back"
        }
    }

    public var cancel: String {
        switch language {
        case .zhHans: "取消"
        case .ja: "キャンセル"
        case .de: "Abbrechen"
        case .es: "Cancelar"
        case .fr: "Annuler"
        case .tr: "İptal"
        default: "Cancel"
        }
    }

    public var done: String {
        switch language {
        case .zhHans: "完成"
        case .ja: "完了"
        case .de: "Fertig"
        case .es: "Listo"
        case .fr: "Terminé"
        case .tr: "Bitti"
        default: "Done"
        }
    }

    public var quit: String {
        switch language {
        case .zhHans: "退出"
        case .ja: "終了"
        case .de: "Beenden"
        case .es: "Salir"
        case .fr: "Quitter"
        case .tr: "Çıkış"
        default: "Quit"
        }
    }

    public var quitApp: String {
        switch language {
        case .zhHans: "退出应用"
        case .ja: "アプリを終了"
        case .de: "App beenden"
        case .es: "Salir de la app"
        case .fr: "Quitter l'application"
        case .tr: "Uygulamadan Çık"
        default: "Quit App"
        }
    }

    public var quitTooltip: String {
        switch language {
        case .zhHans: "退出 PanelBar (⌘Q)"
        case .ja: "PanelBar を終了 (⌘Q)"
        case .de: "PanelBar beenden (⌘Q)"
        case .es: "Salir de PanelBar (⌘Q)"
        case .fr: "Quitter PanelBar (⌘Q)"
        case .tr: "PanelBar'dan Çık (⌘Q)"
        default: "Quit PanelBar (⌘Q)"
        }
    }

    public var settingsTooltip: String {
        switch language {
        case .zhHans: "设置 (⌘,)"
        case .ja: "設定 (⌘,)"
        case .de: "Einstellungen (⌘,)"
        case .es: "Ajustes (⌘,)"
        case .fr: "Réglages (⌘,)"
        case .tr: "Ayarlar (⌘,)"
        default: "Settings (⌘,)"
        }
    }

    public var refreshTooltip: String {
        switch language {
        case .zhHans: "刷新 (⌘R)"
        case .ja: "更新 (⌘R)"
        case .de: "Aktualisieren (⌘R)"
        case .es: "Actualizar (⌘R)"
        case .fr: "Actualiser (⌘R)"
        case .tr: "Yenile (⌘R)"
        default: "Refresh (⌘R)"
        }
    }

    public var refresh: String {
        switch language {
        case .zhHans: "刷新"
        case .ja: "更新"
        case .de: "Aktualisieren"
        case .es: "Actualizar"
        case .fr: "Actualiser"
        case .tr: "Yenile"
        default: "Refresh"
        }
    }

    public var changesSaveInstantly: String {
        switch language {
        case .zhHans: "更改即时保存"
        case .ja: "変更は即座に保存されます"
        case .de: "Änderungen werden sofort gespeichert"
        case .es: "Los cambios se guardan al instante"
        case .fr: "Modifications enregistrées instantanément"
        case .tr: "Değişiklikler anında kaydedilir"
        default: "Changes save instantly"
        }
    }

    // MARK: - Menu Bar & Appearance Settings

    public var menuBarSection: String {
        switch language {
        case .zhHans: "菜单栏"
        case .ja: "メニューバー"
        case .de: "Menüleiste"
        case .es: "Barra de menús"
        case .fr: "Barre des menus"
        case .tr: "Menü çubuğu"
        default: "Menu bar"
        }
    }

    public var showNextToIcon: String {
        switch language {
        case .zhHans: "在图标旁显示"
        case .ja: "アイコンの隣に表示"
        case .de: "Neben dem Icon anzeigen"
        case .es: "Mostrar junto al icono"
        case .fr: "Afficher à côté de l'icône"
        case .tr: "Simgenin yanında göster"
        default: "Show next to the icon"
        }
    }

    public var statIconOnly: String {
        switch language {
        case .zhHans: "仅图标"
        case .ja: "アイコンのみ"
        case .de: "Nur Icon"
        case .es: "Solo icono"
        case .fr: "Icône seulement"
        case .tr: "Yalnızca simge"
        default: "Icon only"
        }
    }

    public var statDiskAccounts: String {
        switch language {
        case .zhHans: "磁盘 / 账户"
        case .ja: "ディスク / アカウント"
        case .de: "Speicher / Konten"
        case .es: "Disco / cuentas"
        case .fr: "Disque / comptes"
        case .tr: "Disk / hesaplar"
        default: "Disk / accounts"
        }
    }

    public var statSSLDaysServices: String {
        switch language {
        case .zhHans: "SSL 天数 / 异常服务"
        case .ja: "SSL 残り日数 / 停止サービス"
        case .de: "SSL-Tage / Gestoppte Dienste"
        case .es: "Días de SSL / servicios caídos"
        case .fr: "Jours SSL / services arrêtés"
        case .tr: "SSL günleri / duran servisler"
        default: "SSL days / down services"
        }
    }

    public var iconAndDotOnlyWhenOffline: String {
        switch language {
        case .zhHans: "仅在离线时显示图标和圆点"
        case .ja: "オフライン時はアイコンとドットのみ表示"
        case .de: "Nur Icon und Punkt bei Offline-Status"
        case .es: "Solo icono y punto cuando esté desconectado"
        case .fr: "Icône et point uniquement hors ligne"
        case .tr: "Çevrimdışıyken yalnızca simge ve nokta"
        default: "Icon and dot only when offline"
        }
    }

    public var refreshSection: String {
        switch language {
        case .zhHans: "刷新"
        case .ja: "更新"
        case .de: "Aktualisierung"
        case .es: "Actualización"
        case .fr: "Actualisation"
        case .tr: "Yenileme"
        default: "Refresh"
        }
    }

    public var whilePopoverOpen: String {
        switch language {
        case .zhHans: "当弹窗打开时"
        case .ja: "ポップオーバー表示中"
        case .de: "Wenn Popover geöffnet ist"
        case .es: "Con el panel abierto"
        case .fr: "Pendant que le popover est ouvert"
        case .tr: "Açılır pencere açıkken"
        default: "While the popover is open"
        }
    }

    public var refreshGentleNote: String {
        switch language {
        case .zhHans: "默认为温和模式：共享主机通常会限制 API 频率。"
        case .ja: "標準で控えめ設定: 共有サーバーではAPI利用制限がよくあります。"
        case .de: "Standardmäßig schonend: Shared-Hosts begrenzen oft API-Raten."
        case .es: "Moderado por defecto: los alojamientos compartidos suelen limitar la API."
        case .fr: "Modéré par défaut : les hébergements partagés limitent souvent l'API."
        case .tr: "Varsayılan olarak ılımlı: paylaşımlı sunucular API isteklerini sıklıkla sınırlar."
        default: "Gentle by default: shared hosts often rate-limit the API."
        }
    }

    public var inTheBackground: String {
        switch language {
        case .zhHans: "后台运行中"
        case .ja: "バックグラウンド"
        case .de: "Im Hintergrund"
        case .es: "En segundo plano"
        case .fr: "En arrière-plan"
        case .tr: "Arka planda"
        default: "In the background"
        }
    }

    public func minutes(count: Int) -> String {
        switch language {
        case .zhHans: "\(count) 分钟"
        case .ja: "\(count)分"
        case .de: "\(count) Min"
        case .es: "\(count) min"
        case .fr: "\(count) min"
        case .tr: "\(count) dk"
        default: "\(count) min"
        }
    }

    public var off: String {
        switch language {
        case .zhHans: "关闭"
        case .ja: "オフ"
        case .de: "Aus"
        case .es: "Desactivado"
        case .fr: "Désactivé"
        case .tr: "Kapalı"
        default: "Off"
        }
    }

    public var generalSection: String {
        switch language {
        case .zhHans: "通用"
        case .ja: "一般"
        case .de: "Allgemein"
        case .es: "General"
        case .fr: "Général"
        case .tr: "Genel"
        default: "General"
        }
    }

    public var launchAtLogin: String {
        switch language {
        case .zhHans: "开机自启"
        case .ja: "ログイン時に起動"
        case .de: "Bei der Anmeldung starten"
        case .es: "Iniciar al arrancar"
        case .fr: "Lancer à la connexion"
        case .tr: "Girişte Başlat"
        default: "Launch at login"
        }
    }

    public var approveInLoginItems: String {
        switch language {
        case .zhHans: "请在“系统设置 > 登录项”中批准 PanelBar。"
        case .ja: "システム設定 > ログイン項目で PanelBar を承認してください。"
        case .de: "PanelBar in Systemeinstellungen > Anmeldeobjekte genehmigen."
        case .es: "Aprueba PanelBar en Ajustes del Sistema > Ítems de inicio."
        case .fr: "Approuvez PanelBar dans Réglages Système > Éléments de connexion."
        case .tr: "PanelBar'ı Sistem Ayarları > Giriş Öğeleri'nden onaylayın."
        default: "Approve PanelBar in System Settings > Login Items."
        }
    }

    public var appearance: String {
        switch language {
        case .zhHans: "外观"
        case .ja: "外観"
        case .de: "Erscheinungsbild"
        case .es: "Aspecto"
        case .fr: "Apparence"
        case .tr: "Görünüm"
        default: "Appearance"
        }
    }

    public var appearanceSystem: String {
        switch language {
        case .zhHans: "系统"
        case .ja: "システム"
        case .de: "System"
        case .es: "Sistema"
        case .fr: "Système"
        case .tr: "Sistem"
        default: "System"
        }
    }

    public var appearanceLight: String {
        switch language {
        case .zhHans: "浅色"
        case .ja: "ライト"
        case .de: "Hell"
        case .es: "Claro"
        case .fr: "Clair"
        case .tr: "Açık"
        default: "Light"
        }
    }

    public var appearanceDark: String {
        switch language {
        case .zhHans: "深色"
        case .ja: "ダーク"
        case .de: "Dunkel"
        case .es: "Oscuro"
        case .fr: "Sombre"
        case .tr: "Koyu"
        default: "Dark"
        }
    }

    // MARK: - Security & Touch ID

    public var securitySection: String {
        switch language {
        case .zhHans: "安全"
        case .ja: "セキュリティ"
        case .de: "Sicherheit"
        case .es: "Seguridad"
        case .fr: "Sécurité"
        case .tr: "Güvenlik"
        default: "Security"
        }
    }

    public var protectWithTouchID: String {
        switch language {
        case .zhHans: "使用触控 ID 保护"
        case .ja: "Touch ID で保護"
        case .de: "Mit Touch ID schützen"
        case .es: "Proteger con Touch ID"
        case .fr: "Protéger avec Touch ID"
        case .tr: "Touch ID ile Koru"
        default: "Protect with Touch ID"
        }
    }

    public var touchIDDetailAvailable: String {
        switch language {
        case .zhHans: "编辑或删除服务器连接时需要触控 ID。"
        case .ja: "サーバー接続の編集や削除に Touch ID を要求します。"
        case .de: "Erfordert Touch ID zum Bearbeiten oder Löschen von Serververbindungen."
        case .es: "Requiere Touch ID para editar o eliminar conexiones de servidores."
        case .fr: "Exige Touch ID pour modifier ou supprimer des connexions de serveurs."
        case .tr: "Sunucu bağlantılarını düzenlemek veya silmek için Touch ID gerektir."
        default: "Require Touch ID to edit or delete server connections."
        }
    }

    public var touchIDDetailUnavailable: String {
        switch language {
        case .zhHans: "此 Mac 上触控 ID 不可用或未注册指纹。"
        case .ja: "このMacでは Touch ID が利用できないか登録されていません。"
        case .de: "Touch ID ist auf diesem Mac nicht verfügbar oder nicht eingerichtet."
        case .es: "Touch ID no está disponible o no está configurado en este Mac."
        case .fr: "Touch ID n'est pas disponible ou configuré sur ce Mac."
        case .tr: "Touch ID bu Mac'te mevcut değil veya ayarlanmamış."
        default: "Touch ID is not available or not enrolled on this Mac."
        }
    }

    public var touchIDPromptEnable: String {
        switch language {
        case .zhHans: "扫描指纹以启用触控 ID 保护"
        case .ja: "指紋をスキャンして Touch ID 保護を有効にします"
        case .de: "Fingerabdruck scannen, um Touch ID-Schutz zu aktivieren"
        case .es: "Escanea tu huella para activar la protección con Touch ID"
        case .fr: "Scannez votre empreinte pour activer la protection Touch ID"
        case .tr: "Touch ID korumasını etkinleştirmek için parmak izinizi tarayın"
        default: "Scan your fingerprint to enable Touch ID protection"
        }
    }

    public var touchIDPromptDisable: String {
        switch language {
        case .zhHans: "扫描指纹以禁用触控 ID 保护"
        case .ja: "指紋をスキャンして Touch ID 保護を無効にします"
        case .de: "Fingerabdruck scannen, um Touch ID-Schutz zu deaktivieren"
        case .es: "Escanea tu huella para desactivar la protección con Touch ID"
        case .fr: "Scannez votre empreinte pour désactiver la protection Touch ID"
        case .tr: "Touch ID korumasını devre dışı bırakmak için parmak izinizi tarayın"
        default: "Scan your fingerprint to disable Touch ID protection"
        }
    }

    public var touchIDPromptDelete: String {
        switch language {
        case .zhHans: "使用触控 ID 验证以删除此服务器"
        case .ja: "このサーバーを削除するには Touch ID で認証してください"
        case .de: "Mit Touch ID authentifizieren, um diesen Server zu löschen"
        case .es: "Autentícate con Touch ID para eliminar este servidor"
        case .fr: "Authentifiez-vous avec Touch ID pour supprimer ce serveur"
        case .tr: "Bu sunucuyu silmek için Touch ID ile kimlik doğrulaması yapın"
        default: "Authenticate with Touch ID to delete this server"
        }
    }

    public func touchIDPromptEdit(name: String) -> String {
        switch language {
        case .zhHans: "使用触控 ID 验证以编辑 \(name)"
        case .ja: "\(name) を編集するには Touch ID で認証してください"
        case .de: "Mit Touch ID authentifizieren, um \(name) zu bearbeiten"
        case .es: "Autentícate con Touch ID para editar \(name)"
        case .fr: "Authentifiez-vous avec Touch ID pour modifier \(name)"
        case .tr: "\(name) sunucusunu düzenlemek için Touch ID ile kimlik doğrulaması yapın"
        default: "Authenticate with Touch ID to edit \(name)"
        }
    }

    public var enabled: String {
        switch language {
        case .zhHans: "已启用"
        case .ja: "有効"
        case .de: "Aktiviert"
        case .es: "Activado"
        case .fr: "Activé"
        case .tr: "Etkin"
        default: "Enabled"
        }
    }

    public var disabled: String {
        switch language {
        case .zhHans: "已禁用"
        case .ja: "無効"
        case .de: "Deaktiviert"
        case .es: "Desactivado"
        case .fr: "Désactivé"
        case .tr: "Devre Dışı"
        default: "Disabled"
        }
    }

    public var unavailable: String {
        switch language {
        case .zhHans: "不可用"
        case .ja: "利用不可"
        case .de: "Nicht verfügbar"
        case .es: "No disponible"
        case .fr: "Indisponible"
        case .tr: "Kullanılamıyor"
        default: "Unavailable"
        }
    }

    // MARK: - Servers & Privacy & About

    public var serversSection: String {
        switch language {
        case .zhHans: "账户与服务器"
        case .ja: "アカウントとサーバー"
        case .de: "Konten und Server"
        case .es: "Cuentas y servidores"
        case .fr: "Comptes et serveurs"
        case .tr: "Hesaplar ve sunucular"
        default: "Accounts and servers"
        }
    }

    public var active: String {
        switch language {
        case .zhHans: "活跃"
        case .ja: "アクティブ"
        case .de: "Aktiv"
        case .es: "Activo"
        case .fr: "Actif"
        case .tr: "Aktif"
        default: "Active"
        }
    }

    public var editServer: String {
        switch language {
        case .zhHans: "编辑服务器"
        case .ja: "サーバーを編集"
        case .de: "Server bearbeiten"
        case .es: "Editar servidor"
        case .fr: "Modifier le serveur"
        case .tr: "Sunucuyu düzenle"
        default: "Edit server"
        }
    }

    public var deleteServer: String {
        switch language {
        case .zhHans: "删除服务器"
        case .ja: "サーバーを削除"
        case .de: "Server löschen"
        case .es: "Eliminar servidor"
        case .fr: "Supprimer le serveur"
        case .tr: "Sunucuyu sil"
        default: "Delete server"
        }
    }

    public var addAnotherServer: String {
        switch language {
        case .zhHans: "添加其他服务器…"
        case .ja: "別のサーバーを追加…"
        case .de: "Weitere Server hinzufügen…"
        case .es: "Añadir otro servidor…"
        case .fr: "Ajouter un autre serveur…"
        case .tr: "Başka bir sunucu ekle…"
        default: "Add another server…"
        }
    }

    public var privacySection: String {
        switch language {
        case .zhHans: "隐私"
        case .ja: "プライバシー"
        case .de: "Datenschutz"
        case .es: "Privacidad"
        case .fr: "Confidentialité"
        case .tr: "Gizlilik"
        default: "Privacy"
        }
    }

    public var privacyNote: String {
        switch language {
        case .zhHans: "API 令牌保留在您的钥匙串中。无分析或追踪：PanelBar 仅与您添加的账户和服务器通信。"
        case .ja: "APIトークンはキーチェーンに安全に保管されます。トラッキングや分析は一切行わず、登録したサーバーとのみ通信します。"
        case .de: "API-Tokens bleiben in Ihrem Schlüsselbund. Kein Tracking oder Analysen: PanelBar kommuniziert nur mit Ihren Servern."
        case .es: "Los tokens API se guardan en tu Llavero. Sin analíticas ni rastreo: PanelBar solo se comunica con los servidores que añadas."
        case .fr: "Les jetons API restent dans votre trousseau d'accès. Pas d'analyse ni de suivi : PanelBar ne communique qu'avec vos serveurs."
        case .tr: "API token'ları Anahtar Zincirinizde kalır. Analiz veya izleme yoktur: PanelBar yalnızca eklediğiniz sunucularla iletişim kurar."
        default: "API tokens stay in your Keychain. No analytics or tracking: PanelBar only talks to the accounts and servers you add."
        }
    }

    public var aboutSection: String {
        switch language {
        case .zhHans: "关于"
        case .ja: "情報"
        case .de: "Über"
        case .es: "Acerca de"
        case .fr: "À propos"
        case .tr: "Hakkında"
        default: "About"
        }
    }

    public func unofficialDisclaimer(version: String) -> String {
        switch language {
        case .zhHans: "版本 \(version) · 非官方，与 cPanel 或 WHM 无关联"
        case .ja: "バージョン \(version) · 非公式（cPanelおよびWHMとは提携していません）"
        case .de: "Version \(version) · Inoffiziell, nicht mit cPanel oder WHM verbunden"
        case .es: "Versión \(version) · No oficial, no afiliado con cPanel o WHM"
        case .fr: "Version \(version) · Non officiel, non affilié à cPanel ou WHM"
        case .tr: "Sürüm \(version) · Gayri resmi, cPanel veya WHM ile bağlantılı değildir"
        default: "Version \(version) · Unofficial, not affiliated with cPanel or WHM"
        }
    }

    public var checkForUpdates: String {
        switch language {
        case .zhHans: "检查更新"
        case .ja: "アップデートを確認"
        case .de: "Nach Updates suchen"
        case .es: "Buscar actualizaciones"
        case .fr: "Rechercher des mises à jour"
        case .tr: "Güncellemeleri kontrol et"
        default: "Check for updates"
        }
    }

    public var checkingForUpdates: String {
        switch language {
        case .zhHans: "正在 GitHub 上检查发布版本…"
        case .ja: "GitHub で最新リリースを確認中…"
        case .de: "GitHub wird nach Releases durchsucht…"
        case .es: "Buscando versiones en GitHub…"
        case .fr: "Vérification des versions sur GitHub…"
        case .tr: "GitHub'da yeni sürümler kontrol ediliyor…"
        default: "Checking GitHub for releases…"
        }
    }

    public func upToDate(version: String) -> String {
        switch language {
        case .zhHans: "PanelBar \(version) 已是最新版本"
        case .ja: "PanelBar \(version) は最新です"
        case .de: "PanelBar \(version) ist auf dem neuesten Stand"
        case .es: "PanelBar \(version) está actualizado"
        case .fr: "PanelBar \(version) est à jour"
        case .tr: "PanelBar \(version) güncel"
        default: "PanelBar \(version) is up to date"
        }
    }

    public func updateAvailable(version: String) -> String {
        switch language {
        case .zhHans: "PanelBar \(version) 已发布"
        case .ja: "PanelBar \(version) が利用可能です"
        case .de: "PanelBar \(version) ist verfügbar"
        case .es: "PanelBar \(version) está disponible"
        case .fr: "PanelBar \(version) est disponible"
        case .tr: "PanelBar \(version) mevcut"
        default: "PanelBar \(version) is available"
        }
    }

    public var viewRelease: String {
        switch language {
        case .zhHans: "查看发布"
        case .ja: "リリースを表示"
        case .de: "Release ansehen"
        case .es: "Ver lanzamiento"
        case .fr: "Voir la release"
        case .tr: "Sürümü görüntüle"
        default: "View release"
        }
    }

    public var manualCheckOnlyNote: String {
        switch language {
        case .zhHans: "仅在点击按钮时检查 GitHub。绝不在启动时或定时检查。"
        case .ja: "ボタンを押した時のみ GitHub を確認します。起動時や定期的な通信は行いません。"
        case .de: "Prüft GitHub nur beim Klicken. Niemals beim Start, niemals per Timer."
        case .es: "Solo consulta GitHub al pulsar el botón. Nunca al arrancar ni con temporizador."
        case .fr: "Vérifie GitHub uniquement quand vous cliquez. Jamais au lancement ni périodiquement."
        case .tr: "Yalnızca düğmeye bastığınızda GitHub'ı kontrol eder. Asla açılışta veya zamanlayıcıyla değil."
        default: "Checks GitHub only when you press the button. Never on launch, never on a timer."
        }
    }

    public var sourceCodeOnGitHub: String {
        switch language {
        case .zhHans: "GitHub 源码"
        case .ja: "GitHub のソースコード"
        case .de: "Quellcode auf GitHub"
        case .es: "Código fuente en GitHub"
        case .fr: "Code source sur GitHub"
        case .tr: "GitHub'daki Kaynak Kod"
        default: "Source code on GitHub"
        }
    }

    // MARK: - Dashboard & Status

    public var activeServer: String {
        switch language {
        case .zhHans: "当前活动服务器"
        case .ja: "アクティブなサーバー"
        case .de: "Aktiver Server"
        case .es: "Servidor activo"
        case .fr: "Serveur actif"
        case .tr: "Aktif Sunucu"
        default: "Active Server"
        }
    }

    public var addServer: String {
        switch language {
        case .zhHans: "添加服务器"
        case .ja: "サーバーを追加"
        case .de: "Server hinzufügen"
        case .es: "Añadir servidor"
        case .fr: "Ajouter un serveur"
        case .tr: "Sunucu ekle"
        default: "Add Server"
        }
    }

    public var addServerEllipsis: String {
        switch language {
        case .zhHans: "添加服务器…"
        case .ja: "サーバーを追加…"
        case .de: "Server hinzufügen…"
        case .es: "Añadir servidor…"
        case .fr: "Ajouter un serveur…"
        case .tr: "Sunucu ekle…"
        default: "Add Server…"
        }
    }

    public var addAServer: String {
        switch language {
        case .zhHans: "添加服务器"
        case .ja: "サーバーを追加"
        case .de: "Einen Server hinzufügen"
        case .es: "Añadir un servidor"
        case .fr: "Ajouter un serveur"
        case .tr: "Sunucu ekle"
        default: "Add a server"
        }
    }

    public var noServerConnected: String {
        switch language {
        case .zhHans: "未连接服务器"
        case .ja: "サーバーが接続されていません"
        case .de: "Kein Server verbunden"
        case .es: "Ningún servidor conectado"
        case .fr: "Aucun serveur connecté"
        case .tr: "Bağlı sunucu yok"
        default: "No server connected"
        }
    }

    public var addServerDescription: String {
        switch language {
        case .zhHans: "添加 cPanel 账户或 WHM 服务器以开始监控。"
        case .ja: "cPanelアカウントまたはWHMサーバーを追加して監視を開始します。"
        case .de: "Fügen Sie ein cPanel-Konto oder einen WHM-Server hinzu, um mit der Überwachung zu beginnen."
        case .es: "Añade una cuenta de cPanel o un servidor WHM para comenzar a monitorizar."
        case .fr: "Ajoutez un compte cPanel ou un serveur WHM pour commencer la surveillance."
        case .tr: "İzlemeye başlamak için bir cPanel hesabı veya WHM sunucusu ekleyin."
        default: "Add a cPanel account or WHM server to start monitoring."
        }
    }

    public var tokenRejected: String {
        switch language {
        case .zhHans: "令牌被拒绝"
        case .ja: "トークンが拒否されました"
        case .de: "Token abgelehnt"
        case .es: "Token rechazado"
        case .fr: "Jeton rejeté"
        case .tr: "Token reddedildi"
        default: "Token rejected"
        }
    }

    public func tokenRejectedBody(host: String) -> String {
        switch language {
        case .zhHans: "\(host) 可访问，但 API 令牌未被接受。"
        case .ja: "\(host) に接続できましたが、APIトークンが承認されませんでした。"
        case .de: "\(host) ist erreichbar, aber das API-Token wurde abgelehnt."
        case .es: "\(host) es accesible, pero el token API no fue aceptado."
        case .fr: "\(host) est accessible, mais le jeton API n'a pas été accepté."
        case .tr: "\(host) adresine ulaşılabiliyor ancak API token'ı kabul edilmedi."
        default: "\(host) is reachable, but the API token was not accepted."
        }
    }

    public var unreachable: String {
        switch language {
        case .zhHans: "无法连接"
        case .ja: "接続不能"
        case .de: "Nicht erreichbar"
        case .es: "Inaccesible"
        case .fr: "Inaccessible"
        case .tr: "Ulaşılamıyor"
        default: "Unreachable"
        }
    }

    public func couldNotConnect(host: String) -> String {
        switch language {
        case .zhHans: "无法连接到 \(host)。"
        case .ja: "\(host) に接続できませんでした。"
        case .de: "Verbindung zu \(host) fehlgeschlagen."
        case .es: "No se pudo conectar a \(host)."
        case .fr: "Impossible de se connecter à \(host)."
        case .tr: "\(host) adresine bağlanılamadı."
        default: "Could not connect to \(host)."
        }
    }

    public var apiToken: String {
        switch language {
        case .zhHans: "API 令牌"
        case .ja: "APIトークン"
        case .de: "API-Token"
        case .es: "Token API"
        case .fr: "Jeton API"
        case .tr: "API Token'ı"
        default: "API token"
        }
    }

    public var pasteNewToken: String {
        switch language {
        case .zhHans: "粘贴新令牌"
        case .ja: "新しいトークンを貼り付け"
        case .de: "Neues Token einfügen"
        case .es: "Pega un nuevo token"
        case .fr: "Coller un nouveau jeton"
        case .tr: "Yeni bir token yapıştırın"
        default: "Paste a new token"
        }
    }

    public var saveToken: String {
        switch language {
        case .zhHans: "保存令牌"
        case .ja: "トークンを保存"
        case .de: "Token speichern"
        case .es: "Guardar token"
        case .fr: "Enregistrer le jeton"
        case .tr: "Token'ı kaydet"
        default: "Save token"
        }
    }

    public var retry: String {
        switch language {
        case .zhHans: "重试"
        case .ja: "再試行"
        case .de: "Wiederholen"
        case .es: "Reintentar"
        case .fr: "Réessayer"
        case .tr: "Tekrar Dene"
        default: "Retry"
        }
    }

    public var statusOnline: String {
        switch language {
        case .zhHans: "在线"
        case .ja: "オンライン"
        case .de: "Online"
        case .es: "En línea"
        case .fr: "En ligne"
        case .tr: "Çevrimiçi"
        default: "Online"
        }
    }

    public var statusOffline: String {
        switch language {
        case .zhHans: "离线"
        case .ja: "オフライン"
        case .de: "Offline"
        case .es: "Desconectado"
        case .fr: "Hors ligne"
        case .tr: "Çevrimdışı"
        default: "Offline"
        }
    }

    public var statusNeedsToken: String {
        switch language {
        case .zhHans: "需要令牌"
        case .ja: "トークンが必要"
        case .de: "Token erforderlich"
        case .es: "Requiere token"
        case .fr: "Jeton requis"
        case .tr: "Token Gerekli"
        default: "Needs Token"
        }
    }

    public var statusLocked: String {
        switch language {
        case .zhHans: "已锁定"
        case .ja: "ロック中"
        case .de: "Gesperrt"
        case .es: "Bloqueado"
        case .fr: "Verrouillé"
        case .tr: "Kilitli"
        default: "Locked"
        }
    }

    public var checking: String {
        switch language {
        case .zhHans: "正在检查…"
        case .ja: "確認中…"
        case .de: "Wird geprüft…"
        case .es: "Comprobando…"
        case .fr: "Vérification…"
        case .tr: "Kontrol ediliyor…"
        default: "Checking…"
        }
    }

    public func lastChecked(time: String) -> String {
        switch language {
        case .zhHans: "上次检查于 \(time)"
        case .ja: "最終確認: \(time)"
        case .de: "Zuletzt geprüft: \(time)"
        case .es: "Última comprobación: \(time)"
        case .fr: "Dernière vérification : \(time)"
        case .tr: "Son kontrol: \(time)"
        default: "Last checked \(time)"
        }
    }

    public var justNow: String {
        switch language {
        case .zhHans: "刚刚"
        case .ja: "たった今"
        case .de: "gerade eben"
        case .es: "hace un momento"
        case .fr: "à l'instant"
        case .tr: "az önce"
        default: "just now"
        }
    }

    public func secondsAgo(count: Int) -> String {
        switch language {
        case .zhHans: "\(count) 秒前"
        case .ja: "\(count)秒前"
        case .de: "vor \(count) s"
        case .es: "hace \(count) s"
        case .fr: "il y a \(count) s"
        case .tr: "\(count) sn önce"
        default: "\(count)s ago"
        }
    }

    public func minutesAgo(count: Int) -> String {
        switch language {
        case .zhHans: "\(count) 分钟前"
        case .ja: "\(count)分前"
        case .de: "vor \(count) min"
        case .es: "hace \(count) min"
        case .fr: "il y a \(count) min"
        case .tr: "\(count) dk önce"
        default: "\(count)m ago"
        }
    }

    // MARK: - Hero & Navigation

    public var domainsHosted: String {
        switch language {
        case .zhHans: "个托管域名"
        case .ja: "件のドメインを運用中"
        case .de: "gehostete Domains"
        case .es: "dominios alojados"
        case .fr: "domaines hébergés"
        case .tr: "barındırılan alan adı"
        default: "domains hosted"
        }
    }

    public var accountsHosted: String {
        switch language {
        case .zhHans: "个托管账户"
        case .ja: "件のアカウントを運用中"
        case .de: "gehostete Konten"
        case .es: "cuentas alojadas"
        case .fr: "comptes hébergés"
        case .tr: "barındırılan hesap"
        default: "accounts hosted"
        }
    }

    public var openCPanel: String {
        switch language {
        case .zhHans: "打开 cPanel"
        case .ja: "cPanel を開く"
        case .de: "cPanel öffnen"
        case .es: "Abrir cPanel"
        case .fr: "Ouvrir cPanel"
        case .tr: "cPanel'i Aç"
        default: "Open cPanel"
        }
    }

    public var openWHM: String {
        switch language {
        case .zhHans: "打开 WHM"
        case .ja: "WHM を開く"
        case .de: "WHM öffnen"
        case .es: "Abrir WHM"
        case .fr: "Ouvrir WHM"
        case .tr: "WHM'yi Aç"
        default: "Open WHM"
        }
    }

    public var openCPanelInBrowser: String {
        switch language {
        case .zhHans: "在浏览器中打开 cPanel"
        case .ja: "ブラウザで cPanel を開く"
        case .de: "cPanel im Browser öffnen"
        case .es: "Abrir cPanel en el navegador"
        case .fr: "Ouvrir cPanel dans le navigateur"
        case .tr: "Tarayıcıda cPanel'i aç"
        default: "Open cPanel in browser"
        }
    }

    public var openWHMInBrowser: String {
        switch language {
        case .zhHans: "在浏览器中打开 WHM"
        case .ja: "ブラウザで WHM を開く"
        case .de: "WHM im Browser öffnen"
        case .es: "Abrir WHM en el navegador"
        case .fr: "Ouvrir WHM dans le navigateur"
        case .tr: "Tarayıcıda WHM'yi aç"
        default: "Open WHM in browser"
        }
    }

    public var plainHTTPAnywayWarning: String {
        switch language {
        case .zhHans: "此服务器允许明文 HTTP：流量未经加密"
        case .ja: "このサーバーではHTTP平文通信が許可されています: 通信は暗号化されません"
        case .de: "Unverschlüsseltes HTTP ist für diesen Server aktiviert: Daten werden nicht verschlüsselt"
        case .es: "HTTP sin cifrar permitido para este servidor: el tráfico no está cifrado"
        case .fr: "HTTP non chiffré autorisé pour ce serveur : le trafic n'est pas sécurisé"
        case .tr: "Bu sunucu için şifresiz HTTP'ye izin verildi: trafik şifrelenmez"
        default: "Plain HTTP is allowed for this server: traffic is not encrypted"
        }
    }

    // MARK: - cPanel Tabs & Tiles

    public var tabOverview: String {
        switch language {
        case .zhHans: "概览"
        case .ja: "概要"
        case .de: "Übersicht"
        case .es: "Resumen"
        case .fr: "Vue d'ensemble"
        case .tr: "Genel Bakış"
        default: "Overview"
        }
    }

    public var tabDomains: String {
        switch language {
        case .zhHans: "域名"
        case .ja: "ドメイン"
        case .de: "Domains"
        case .es: "Dominios"
        case .fr: "Domaines"
        case .tr: "Alan Adları"
        default: "Domains"
        }
    }

    public var tabAccounts: String {
        switch language {
        case .zhHans: "账户"
        case .ja: "アカウント"
        case .de: "Konten"
        case .es: "Cuentas"
        case .fr: "Comptes"
        case .tr: "Hesaplar"
        default: "Accounts"
        }
    }

    public var tabServices: String {
        switch language {
        case .zhHans: "服务"
        case .ja: "サービス"
        case .de: "Dienste"
        case .es: "Servicios"
        case .fr: "Services"
        case .tr: "Servisler"
        default: "Services"
        }
    }

    public var resources: String {
        switch language {
        case .zhHans: "资源"
        case .ja: "リソース"
        case .de: "Ressourcen"
        case .es: "Recursos"
        case .fr: "Ressources"
        case .tr: "Kaynaklar"
        default: "Resources"
        }
    }

    public var accountAndServer: String {
        switch language {
        case .zhHans: "账户与服务器"
        case .ja: "アカウントとサーバー"
        case .de: "Konto & Server"
        case .es: "Cuenta y servidor"
        case .fr: "Compte et serveur"
        case .tr: "Hesap ve Sunucu"
        default: "Account & Server"
        }
    }

    public var cpanelUser: String {
        switch language {
        case .zhHans: "cPanel 用户"
        case .ja: "cPanel ユーザー"
        case .de: "cPanel-Benutzer"
        case .es: "Usuario de cPanel"
        case .fr: "Utilisateur cPanel"
        case .tr: "cPanel kullanıcısı"
        default: "cPanel user"
        }
    }

    public var serverHost: String {
        switch language {
        case .zhHans: "服务器主机"
        case .ja: "サーバーホスト"
        case .de: "Server-Host"
        case .es: "Host del servidor"
        case .fr: "Hôte du serveur"
        case .tr: "Sunucu adresi"
        default: "Server host"
        }
    }

    public var primaryDomain: String {
        switch language {
        case .zhHans: "主域名"
        case .ja: "プライマリドメイン"
        case .de: "Primäre Domain"
        case .es: "Dominio principal"
        case .fr: "Domaine principal"
        case .tr: "Birincil alan adı"
        default: "Primary domain"
        }
    }

    public var portAndProtocol: String {
        switch language {
        case .zhHans: "端口与协议"
        case .ja: "ポートとプロトコル"
        case .de: "Port & Protokoll"
        case .es: "Puerto y protocolo"
        case .fr: "Port et protocole"
        case .tr: "Port ve protokol"
        default: "Port & protocol"
        }
    }

    public var quickActions: String {
        switch language {
        case .zhHans: "快捷操作"
        case .ja: "クイックアクション"
        case .de: "Schnellaktionen"
        case .es: "Acciones rápidas"
        case .fr: "Actions rapides"
        case .tr: "Hızlı İşlemler"
        default: "Quick Actions"
        }
    }

    public var webmail: String {
        "Webmail"
    }

    public var copyHost: String {
        switch language {
        case .zhHans: "复制主机"
        case .ja: "ホストをコピー"
        case .de: "Host kopieren"
        case .es: "Copiar host"
        case .fr: "Copier l'hôte"
        case .tr: "Host'u Kopyala"
        default: "Copy Host"
        }
    }

    public var serverAddress: String {
        switch language {
        case .zhHans: "服务器地址"
        case .ja: "サーバーアドレス"
        case .de: "Serveradresse"
        case .es: "Dirección del servidor"
        case .fr: "Adresse du serveur"
        case .tr: "Sunucu adresi"
        default: "Server address"
        }
    }

    public func diskLimit(limit: String) -> String {
        switch language {
        case .zhHans: "磁盘 · 配额 \(limit)"
        case .ja: "ディスク · 上限 \(limit)"
        case .de: "Speicher · Limit \(limit)"
        case .es: "Disco · límite \(limit)"
        case .fr: "Disque · limite \(limit)"
        case .tr: "Disk · sınır \(limit)"
        default: "Disk · limit \(limit)"
        }
    }

    public var diskUsedUnlimited: String {
        switch language {
        case .zhHans: "磁盘使用量 · 无限制"
        case .ja: "ディスク使用量 · 無制限"
        case .de: "Speicher verwendet · Unbegrenzt"
        case .es: "Disco usado · ilimitado"
        case .fr: "Disque utilisé · illimité"
        case .tr: "Kullanılan disk · sınırsız"
        default: "Disk used · unlimited"
        }
    }

    public func percentUsed(percent: Int) -> String {
        switch language {
        case .zhHans: "已使用 \(percent)%"
        case .ja: "\(percent)% 使用中"
        case .de: "\(percent)% belegt"
        case .es: "\(percent)% usado"
        case .fr: "\(percent) % utilisé"
        case .tr: "%\(percent) kullanıldı"
        default: "\(percent)% used"
        }
    }

    public var noQuotaLimit: String {
        switch language {
        case .zhHans: "无配额限制"
        case .ja: "クォータ制限なし"
        case .de: "Kein Speicherlimit"
        case .es: "Sin límite de cuota"
        case .fr: "Aucune limite de quota"
        case .tr: "Kota sınırı yok"
        default: "No quota limit"
        }
    }

    public var nextSSLExpiry: String {
        switch language {
        case .zhHans: "下次 SSL 到期"
        case .ja: "直近のSSL有効期限"
        case .de: "Nächster SSL-Ablauf"
        case .es: "Próxima caducidad SSL"
        case .fr: "Prochaine expiration SSL"
        case .tr: "Sonraki SSL bitişi"
        default: "Next SSL expiry"
        }
    }

    public var noCertificates: String {
        switch language {
        case .zhHans: "无证书"
        case .ja: "証明書なし"
        case .de: "Keine Zertifikate"
        case .es: "Sin certificados"
        case .fr: "Aucun certificat"
        case .tr: "Sertifika yok"
        default: "No certificates"
        }
    }

    public func domainsHostedCount(count: Int) -> String {
        if count == 1 {
            switch language {
            case .zhHans: "1 个托管域名"
            case .ja: "1件のドメインを運用中"
            case .de: "1 gehostete Domain"
            case .es: "1 dominio alojado"
            case .fr: "1 domaine hébergé"
            case .tr: "1 alan adı barındırılıyor"
            default: "Domain hosted"
            }
        } else {
            switch language {
            case .zhHans: "\(count) 个托管域名"
            case .ja: "\(count)件のドメインを運用中"
            case .de: "\(count) gehostete Domains"
            case .es: "\(count) dominios alojados"
            case .fr: "\(count) domaines hébergés"
            case .tr: "\(count) alan adı barındırılıyor"
            default: "Domains hosted"
            }
        }
    }

    public func subAddon(count: Int) -> String {
        switch language {
        case .zhHans: "\(count) 个子/附加域名"
        case .ja: "\(count)件のサブ/アドオン"
        case .de: "\(count) Sub/Addon"
        case .es: "\(count) sub/addon"
        case .fr: "\(count) sous/suppl."
        case .tr: "\(count) alt/ek alan"
        default: "\(count) sub/addon"
        }
    }

    public var noneHosted: String {
        switch language {
        case .zhHans: "无托管"
        case .ja: "なし"
        case .de: "Keine gehostet"
        case .es: "Ninguno alojado"
        case .fr: "Aucun hébergé"
        case .tr: "Barındırılan yok"
        default: "None hosted"
        }
    }

    public var sslProtection: String {
        switch language {
        case .zhHans: "SSL 保护"
        case .ja: "SSL 保護"
        case .de: "SSL-Schutz"
        case .es: "Protección SSL"
        case .fr: "Protection SSL"
        case .tr: "SSL koruması"
        default: "SSL protection"
        }
    }

    public var noDomains: String {
        switch language {
        case .zhHans: "无域名"
        case .ja: "ドメインなし"
        case .de: "Keine Domains"
        case .es: "Sin dominios"
        case .fr: "Aucun domaine"
        case .tr: "Alan adı yok"
        default: "No domains"
        }
    }

    public var allDomainsCovered: String {
        switch language {
        case .zhHans: "所有域名均受保护"
        case .ja: "全ドメイン保護済み"
        case .de: "Alle Domains geschützt"
        case .es: "Todos los dominios protegidos"
        case .fr: "Tous les domaines protégés"
        case .tr: "Tüm alan adları korumalı"
        default: "All domains covered"
        }
    }

    public func unprotected(count: Int) -> String {
        switch language {
        case .zhHans: "\(count) 个未受保护"
        case .ja: "\(count)件が未保護"
        case .de: "\(count) ungeschützt"
        case .es: "\(count) sin protección"
        case .fr: "\(count) non protégés"
        case .tr: "\(count) korumasız"
        default: "\(count) unprotected"
        }
    }

    public var filterDomains: String {
        switch language {
        case .zhHans: "过滤域名"
        case .ja: "ドメインを絞り込み"
        case .de: "Domains filtern"
        case .es: "Filtrar dominios"
        case .fr: "Filtrer les domaines"
        case .tr: "Alan adlarını filtrele"
        default: "Filter domains"
        }
    }

    public var tableHeaderDomain: String {
        switch language {
        case .zhHans: "域名"
        case .ja: "ドメイン"
        case .de: "DOMAIN"
        case .es: "DOMINIO"
        case .fr: "DOMAINE"
        case .tr: "ALAN ADI"
        default: "DOMAIN"
        }
    }

    public var tableHeaderType: String {
        switch language {
        case .zhHans: "类型"
        case .ja: "種類"
        case .de: "TYP"
        case .es: "TIPO"
        case .fr: "TYPE"
        case .tr: "TÜR"
        default: "TYPE"
        }
    }

    public var tableHeaderSSL: String {
        "SSL"
    }

    public var noMatches: String {
        switch language {
        case .zhHans: "无匹配项"
        case .ja: "一致なし"
        case .de: "Keine Treffer"
        case .es: "Sin coincidencias"
        case .fr: "Aucun résultat"
        case .tr: "Eşleşme yok"
        default: "No matches"
        }
    }

    public var copyDomain: String {
        switch language {
        case .zhHans: "复制域名"
        case .ja: "ドメインをコピー"
        case .de: "Domain kopieren"
        case .es: "Copiar dominio"
        case .fr: "Copier le domaine"
        case .tr: "Alan adını kopyala"
        default: "Copy domain"
        }
    }

    // MARK: - WHM Tabs & Tiles

    public var systemSection: String {
        switch language {
        case .zhHans: "系统"
        case .ja: "システム"
        case .de: "System"
        case .es: "Sistema"
        case .fr: "Système"
        case .tr: "Sistem"
        default: "System"
        }
    }

    public var hostname: String {
        switch language {
        case .zhHans: "主机名"
        case .ja: "ホスト名"
        case .de: "Hostname"
        case .es: "Nombre de host"
        case .fr: "Nom d'hôte"
        case .tr: "Ana makine adı"
        default: "Hostname"
        }
    }

    public var whmVersion: String {
        switch language {
        case .zhHans: "WHM 版本"
        case .ja: "WHM バージョン"
        case .de: "WHM-Version"
        case .es: "Versión de WHM"
        case .fr: "Version de WHM"
        case .tr: "WHM sürümü"
        default: "WHM version"
        }
    }

    public var adminUser: String {
        switch language {
        case .zhHans: "管理员用户"
        case .ja: "管理者ユーザー"
        case .de: "Admin-Benutzer"
        case .es: "Usuario admin"
        case .fr: "Utilisateur admin"
        case .tr: "Yönetici kullanıcı"
        default: "Admin user"
        }
    }

    public func suspendedCount(count: Int) -> String {
        switch language {
        case .zhHans: "\(count) 个已暂停"
        case .ja: "\(count)件が一時停止中"
        case .de: "\(count) gesperrt"
        case .es: "\(count) suspendida(s)"
        case .fr: "\(count) suspendu(s)"
        case .tr: "\(count) askıya alınmış"
        default: "\(count) suspended"
        }
    }

    public var allActive: String {
        switch language {
        case .zhHans: "全部活跃"
        case .ja: "すべてアクティブ"
        case .de: "Alle aktiv"
        case .es: "Todos activos"
        case .fr: "Tous actifs"
        case .tr: "Tümü aktif"
        default: "All active"
        }
    }

    public var none: String {
        switch language {
        case .zhHans: "无"
        case .ja: "なし"
        case .de: "Keine"
        case .es: "Ninguno"
        case .fr: "Aucun"
        case .tr: "Yok"
        default: "None"
        }
    }

    public var loadAverage: String {
        switch language {
        case .zhHans: "系统负载"
        case .ja: "ロードアベレージ"
        case .de: "Lastdurchschnitt"
        case .es: "Carga media"
        case .fr: "Charge moyenne"
        case .tr: "Sistem yükü"
        default: "Load average"
        }
    }

    public var loadAverage1m: String {
        switch language {
        case .zhHans: "平均负载 (1分钟)"
        case .ja: "ロードアベレージ (1分)"
        case .de: "Lastdurchschnitt (1m)"
        case .es: "Carga media (1m)"
        case .fr: "Charge moyenne (1m)"
        case .tr: "Ortalama yük (1dk)"
        default: "Load average (1m)"
        }
    }

    public var diskUsed: String {
        switch language {
        case .zhHans: "磁盘使用量"
        case .ja: "ディスク使用量"
        case .de: "Speicher belegt"
        case .es: "Disco usado"
        case .fr: "Disque utilisé"
        case .tr: "Kullanılan disk"
        default: "Disk used"
        }
    }

    public func summedAcrossAccounts(count: Int) -> String {
        switch language {
        case .zhHans: "合计共 \(count) 个账户"
        case .ja: "\(count)件のアカウント合計"
        case .de: "summiert über \(count) Konten"
        case .es: "sumado en \(count) cuentas"
        case .fr: "total sur \(count) comptes"
        case .tr: "\(count) hesabın toplamı"
        default: "summed across \(count) accounts"
        }
    }

    public var summingAccounts: String {
        switch language {
        case .zhHans: "正在统计账户…"
        case .ja: "アカウントを集計中…"
        case .de: "Konten werden summiert…"
        case .es: "Sumando cuentas…"
        case .fr: "Calcul des comptes…"
        case .tr: "Hesaplar toplanıyor…"
        default: "Summing accounts…"
        }
    }

    public var servicesOnline: String {
        switch language {
        case .zhHans: "在线服务"
        case .ja: "稼働中のサービス"
        case .de: "Dienste online"
        case .es: "Servicios en línea"
        case .fr: "Services en ligne"
        case .tr: "Çalışan servisler"
        default: "Services online"
        }
    }

    public var allMonitoredRunning: String {
        switch language {
        case .zhHans: "所有受监控服务正常运行"
        case .ja: "監視対象はすべて稼働中"
        case .de: "Alle überwachten laufen"
        case .es: "Todos los monitorizados funcionan"
        case .fr: "Tous les services surveillés fonctionnent"
        case .tr: "İzlenenlerin tümü çalışıyor"
        default: "All monitored running"
        }
    }

    public func servicesDown(count: Int) -> String {
        switch language {
        case .zhHans: "\(count) 个服务异常"
        case .ja: "\(count)件のサービスが停止中"
        case .de: "\(count) Dienst(e) ausgefallen"
        case .es: "\(count) servicio(s) caído(s)"
        case .fr: "\(count) service(s) arrêté(s)"
        case .tr: "\(count) servis durdu"
        default: "\(count) service\(count == 1 ? "" : "s") down"
        }
    }

    public var servicesDownCardTitle: String {
        switch language {
        case .zhHans: "服务异常"
        case .ja: "停止中のサービス"
        case .de: "Ausgefallene Dienste"
        case .es: "Servicios caídos"
        case .fr: "Services arrêtés"
        case .tr: "Duran servisler"
        default: "Services down"
        }
    }

    public var inspect: String {
        switch language {
        case .zhHans: "检查"
        case .ja: "確認"
        case .de: "Prüfen"
        case .es: "Inspeccionar"
        case .fr: "Inspecter"
        case .tr: "İncele"
        default: "Inspect"
        }
    }

    public func accountSuspendedTitle(count: Int) -> String {
        if count == 1 {
            switch language {
            case .zhHans: "1 个账户已暂停"
            case .ja: "1件のアカウントが一時停止中"
            case .de: "1 Konto gesperrt"
            case .es: "1 cuenta suspendida"
            case .fr: "1 compte suspendu"
            case .tr: "1 hesap askıya alınmış"
            default: "1 account suspended"
            }
        } else {
            switch language {
            case .zhHans: "\(count) 个账户已暂停"
            case .ja: "\(count)件のアカウントが一時停止中"
            case .de: "\(count) Konten gesperrt"
            case .es: "\(count) cuentas suspendidas"
            case .fr: "\(count) comptes suspendus"
            case .tr: "\(count) hesap askıya alınmış"
            default: "\(count) accounts suspended"
            }
        }
    }

    public var view: String {
        switch language {
        case .zhHans: "查看"
        case .ja: "表示"
        case .de: "Ansehen"
        case .es: "Ver"
        case .fr: "Voir"
        case .tr: "Görüntüle"
        default: "View"
        }
    }

    public var tableHeaderAccount: String {
        switch language {
        case .zhHans: "账户"
        case .ja: "アカウント"
        case .de: "KONTO"
        case .es: "CUENTA"
        case .fr: "COMPTE"
        case .tr: "HESAP"
        default: "ACCOUNT"
        }
    }

    public var tableHeaderDisk: String {
        switch language {
        case .zhHans: "磁盘"
        case .ja: "ディスク"
        case .de: "SPEICHER"
        case .es: "DISCO"
        case .fr: "DISQUE"
        case .tr: "DİSK"
        default: "DISK"
        }
    }

    public var tableHeaderService: String {
        switch language {
        case .zhHans: "服务"
        case .ja: "サービス"
        case .de: "DIENST"
        case .es: "SERVICIO"
        case .fr: "SERVICE"
        case .tr: "SERVİS"
        default: "SERVICE"
        }
    }

    public var tableHeaderStatus: String {
        switch language {
        case .zhHans: "状态"
        case .ja: "ステータス"
        case .de: "STATUS"
        case .es: "ESTADO"
        case .fr: "STATUT"
        case .tr: "DURUM"
        default: "STATUS"
        }
    }

    public var suspended: String {
        switch language {
        case .zhHans: "已暂停"
        case .ja: "一時停止"
        case .de: "Gesperrt"
        case .es: "Suspendida"
        case .fr: "Suspendu"
        case .tr: "Askıda"
        default: "Suspended"
        }
    }

    public var serviceUp: String {
        switch language {
        case .zhHans: "正常"
        case .ja: "稼働中"
        case .de: "Aktiv"
        case .es: "En marcha"
        case .fr: "Actif"
        case .tr: "Çalışıyor"
        default: "Up"
        }
    }

    public var serviceDown: String {
        switch language {
        case .zhHans: "已停止"
        case .ja: "停止"
        case .de: "Down"
        case .es: "Caído"
        case .fr: "Arrêté"
        case .tr: "Durdu"
        default: "Down"
        }
    }

    public var serviceNotMonitored: String {
        switch language {
        case .zhHans: "未监控"
        case .ja: "監視対象外"
        case .de: "Nicht überwacht"
        case .es: "No monitorizado"
        case .fr: "Non surveillé"
        case .tr: "İzlenmiyor"
        default: "Not monitored"
        }
    }

    public var serviceNotInstalled: String {
        switch language {
        case .zhHans: "未安装"
        case .ja: "未インストール"
        case .de: "Nicht installiert"
        case .es: "No instalado"
        case .fr: "Non installé"
        case .tr: "Yüklü değil"
        default: "Not installed"
        }
    }

    public var viewAccountDetails: String {
        switch language {
        case .zhHans: "查看账户详情"
        case .ja: "アカウント詳細を表示"
        case .de: "Kontodetails anzeigen"
        case .es: "Ver detalles de la cuenta"
        case .fr: "Voir les détails du compte"
        case .tr: "Hesap detaylarını görüntüle"
        default: "View account details"
        }
    }

    public var copyUsername: String {
        switch language {
        case .zhHans: "复制用户名"
        case .ja: "ユーザー名をコピー"
        case .de: "Benutzername kopieren"
        case .es: "Copiar usuario"
        case .fr: "Copier le nom d'utilisateur"
        case .tr: "Kullanıcı adını kopyala"
        default: "Copy username"
        }
    }

    // MARK: - Account Detail View

    public var accountInformation: String {
        switch language {
        case .zhHans: "账户信息"
        case .ja: "アカウント情報"
        case .de: "Kontoinformationen"
        case .es: "Información de la cuenta"
        case .fr: "Informations du compte"
        case .tr: "Hesap Bilgileri"
        default: "Account Information"
        }
    }

    public var username: String {
        switch language {
        case .zhHans: "用户名"
        case .ja: "ユーザー名"
        case .de: "Benutzername"
        case .es: "Usuario"
        case .fr: "Nom d'utilisateur"
        case .tr: "Kullanıcı adı"
        default: "Username"
        }
    }

    public var contactEmail: String {
        switch language {
        case .zhHans: "联系邮箱"
        case .ja: "連絡先メール"
        case .de: "Kontakt-E-Mail"
        case .es: "Correo de contacto"
        case .fr: "E-mail de contact"
        case .tr: "İletişim e-postası"
        default: "Contact email"
        }
    }

    public var ipAddress: String {
        switch language {
        case .zhHans: "IP 地址"
        case .ja: "IPアドレス"
        case .de: "IP-Adresse"
        case .es: "Dirección IP"
        case .fr: "Adresse IP"
        case .tr: "IP adresi"
        default: "IP address"
        }
    }

    public var hostingPackage: String {
        switch language {
        case .zhHans: "主机套餐"
        case .ja: "ホスティングプラン"
        case .de: "Hosting-Paket"
        case .es: "Paquete de alojamiento"
        case .fr: "Forfait d'hébergement"
        case .tr: "Barındırma paketi"
        default: "Hosting package"
        }
    }

    public var owner: String {
        switch language {
        case .zhHans: "所有者"
        case .ja: "所有者"
        case .de: "Eigentümer"
        case .es: "Propietario"
        case .fr: "Propriétaire"
        case .tr: "Sahibi"
        default: "Owner"
        }
    }

    public var createdDate: String {
        switch language {
        case .zhHans: "创建日期"
        case .ja: "作成日"
        case .de: "Erstellungsdatum"
        case .es: "Fecha de creación"
        case .fr: "Date de création"
        case .tr: "Oluşturulma tarihi"
        default: "Created date"
        }
    }

    public var cpanelTheme: String {
        switch language {
        case .zhHans: "cPanel 主题"
        case .ja: "cPanel テーマ"
        case .de: "cPanel-Theme"
        case .es: "Tema de cPanel"
        case .fr: "Thème cPanel"
        case .tr: "cPanel teması"
        default: "cPanel theme"
        }
    }

    public var quotasAndLimits: String {
        switch language {
        case .zhHans: "配额与限制"
        case .ja: "容量と制限"
        case .de: "Quotas & Limits"
        case .es: "Cuotas y límites"
        case .fr: "Quotas et limites"
        case .tr: "Kotalar ve Sınırlar"
        default: "Quotas & Limits"
        }
    }

    public var diskUsage: String {
        switch language {
        case .zhHans: "磁盘使用量"
        case .ja: "ディスク使用量"
        case .de: "Speichernutzung"
        case .es: "Uso de disco"
        case .fr: "Utilisation disque"
        case .tr: "Disk kullanımı"
        default: "Disk usage"
        }
    }

    public var maxAddonDomains: String {
        switch language {
        case .zhHans: "附加域名上限"
        case .ja: "アドオンドメイン上限"
        case .de: "Max. Addon-Domains"
        case .es: "Máx. dominios addon"
        case .fr: "Domaines suppl. max"
        case .tr: "Maks. ek alan adı"
        default: "Max addon domains"
        }
    }

    public var maxSubdomains: String {
        switch language {
        case .zhHans: "子域名上限"
        case .ja: "サブドメイン上限"
        case .de: "Max. Subdomains"
        case .es: "Máx. subdominios"
        case .fr: "Sous-domaines max"
        case .tr: "Maks. alt alan adı"
        default: "Max subdomains"
        }
    }

    public var maxEmailAccounts: String {
        switch language {
        case .zhHans: "邮箱账户上限"
        case .ja: "メールアカウント上限"
        case .de: "Max. E-Mail-Konten"
        case .es: "Máx. cuentas de correo"
        case .fr: "Comptes e-mail max"
        case .tr: "Maks. e-posta hesabı"
        default: "Max email accounts"
        }
    }

    public var maxSQLDatabases: String {
        switch language {
        case .zhHans: "SQL 数据库上限"
        case .ja: "SQLデータベース上限"
        case .de: "Max. SQL-Datenbanken"
        case .es: "Máx. bases de datos SQL"
        case .fr: "Bases SQL max"
        case .tr: "Maks. SQL veritabanı"
        default: "Max SQL databases"
        }
    }

    public var inodes: String {
        switch language {
        case .zhHans: "Inodes"
        case .ja: "Inode"
        case .de: "Inodes"
        case .es: "Inodos"
        case .fr: "Inodes"
        case .tr: "Inode'lar"
        default: "Inodes"
        }
    }

    public func usedOf(used: String, limit: String) -> String {
        switch language {
        case .zhHans: "\(used) 已用，共 \(limit)"
        case .ja: "\(limit) 中 \(used) を使用"
        case .de: "\(used) von \(limit) belegt"
        case .es: "\(used) usado de \(limit)"
        case .fr: "\(used) utilisés sur \(limit)"
        case .tr: "\(limit) sınırın \(used) kullanıldı"
        default: "\(used) used of \(limit)"
        }
    }

    public func quotaPercent(percent: Int) -> String {
        switch language {
        case .zhHans: "已用 \(percent)% 配额"
        case .ja: "クォータの \(percent)%"
        case .de: "\(percent)% der Quote"
        case .es: "\(percent)% de cuota"
        case .fr: "\(percent) % du quota"
        case .tr: "Kotanın %\(percent)'i"
        default: "\(percent)% quota"
        }
    }

    public var copyUser: String {
        switch language {
        case .zhHans: "复制用户"
        case .ja: "ユーザーをコピー"
        case .de: "Benutzer kopieren"
        case .es: "Copiar usuario"
        case .fr: "Copier l'utilisateur"
        case .tr: "Kullanıcıyı kopyala"
        default: "Copy user"
        }
    }

    // MARK: - Add / Edit Server & Connect Form

    public var serverType: String {
        switch language {
        case .zhHans: "服务器类型"
        case .ja: "サーバーの種類"
        case .de: "SERVER-TYP"
        case .es: "TIPO DE SERVIDOR"
        case .fr: "TYPE DE SERVEUR"
        case .tr: "SUNUCU TÜRÜ"
        default: "SERVER TYPE"
        }
    }

    public var cpanelAccount: String {
        switch language {
        case .zhHans: "cPanel 账户"
        case .ja: "cPanel アカウント"
        case .de: "cPanel-Konto"
        case .es: "Cuenta cPanel"
        case .fr: "Compte cPanel"
        case .tr: "cPanel hesabı"
        default: "cPanel account"
        }
    }

    public var whmServer: String {
        switch language {
        case .zhHans: "WHM 服务器"
        case .ja: "WHM サーバー"
        case .de: "WHM-Server"
        case .es: "Servidor WHM"
        case .fr: "Serveur WHM"
        case .tr: "WHM sunucusu"
        default: "WHM server"
        }
    }

    public var singleSiteAgency: String {
        switch language {
        case .zhHans: "单站点 / 代理机构"
        case .ja: "単一サイト / 代理店"
        case .de: "Einzelne Website / Agentur"
        case .es: "Sitio individual / agencia"
        case .fr: "Site unique / agence"
        case .tr: "Tek site / ajans"
        default: "Single site / agency"
        }
    }

    public var fullServerManager: String {
        switch language {
        case .zhHans: "完整服务器管理"
        case .ja: "サーバー全体の管理"
        case .de: "Komplette Serververwaltung"
        case .es: "Administrador completo del servidor"
        case .fr: "Gestionnaire de serveur complet"
        case .tr: "Tam sunucu yöneticisi"
        default: "Full server manager"
        }
    }

    public var connectionDetails: String {
        switch language {
        case .zhHans: "连接详情"
        case .ja: "接続の詳細"
        case .de: "VERBINDUNGSDETAILS"
        case .es: "DETALLES DE CONEXIÓN"
        case .fr: "DÉTAILS DE CONNEXION"
        case .tr: "BAĞLANTI DETAYLARI"
        default: "CONNECTION DETAILS"
        }
    }

    public var displayName: String {
        switch language {
        case .zhHans: "显示名称"
        case .ja: "表示名"
        case .de: "Anzeigename"
        case .es: "Nombre para mostrar"
        case .fr: "Nom d'affichage"
        case .tr: "Görünen Ad"
        default: "Display Name"
        }
    }

    public var hostURL: String {
        switch language {
        case .zhHans: "主机 URL"
        case .ja: "ホストURL"
        case .de: "Host-URL"
        case .es: "URL del host"
        case .fr: "URL de l'hôte"
        case .tr: "Host URL'si"
        default: "Host URL"
        }
    }

    public var authentication: String {
        switch language {
        case .zhHans: "身份验证"
        case .ja: "認証"
        case .de: "AUTHENTIFIZIERUNG"
        case .es: "AUTENTICACIÓN"
        case .fr: "AUTHENTIFICATION"
        case .tr: "KİMLİK DOĞRULAMA"
        default: "AUTHENTICATION"
        }
    }

    public var tokenHelpCPanel: String {
        switch language {
        case .zhHans: "创建令牌：cPanel > 安全 > 管理 API 令牌。"
        case .ja: "トークンを作成: cPanel > セキュリティ > APIトークンの管理。"
        case .de: "Token erstellen: cPanel > Sicherheit > API-Tokens verwalten."
        case .es: "Crear un token: cPanel > Seguridad > Administrar tokens de API."
        case .fr: "Créer un jeton : cPanel > Sécurité > Gérer les jetons API."
        case .tr: "Token oluşturun: cPanel > Güvenlik > API Token'larını Yönet."
        default: "Create a token: cPanel > Security > Manage API Tokens."
        }
    }

    public var tokenHelpWHM: String {
        switch language {
        case .zhHans: "创建令牌：WHM > 开发 > 管理 API 令牌。"
        case .ja: "トークンを作成: WHM > 開発 > APIトークンの管理。"
        case .de: "Token erstellen: WHM > Entwicklung > API-Tokens verwalten."
        case .es: "Crear un token: WHM > Desarrollo > Administrar tokens de API."
        case .fr: "Créer un jeton : WHM > Développement > Gérer les jetons API."
        case .tr: "Token oluşturun: WHM > Geliştirme > API Token'larını Yönet."
        default: "Create a token: WHM > Development > Manage API Tokens."
        }
    }

    public var plainHTTPWarning: String {
        switch language {
        case .zhHans: "明文 HTTP 警告"
        case .ja: "HTTP平文通信の警告"
        case .de: "Warnung vor unverschlüsseltem HTTP"
        case .es: "Aviso de HTTP sin cifrar"
        case .fr: "Avertissement HTTP non chiffré"
        case .tr: "Şifresiz HTTP Uyarısı"
        default: "Plain HTTP Warning"
        }
    }

    public var plainHTTPDescription: String {
        switch language {
        case .zhHans: "未加密的明文 HTTP 会在传输中暴露令牌。推荐使用 https 或 SSH 隧道。"
        case .ja: "暗号化されていないHTTP平文通信ではトークンが生テキストで送信されます。httpsまたはSSHトンネルを推奨します。"
        case .de: "Unverschlüsseltes HTTP überträgt Tokens im Klartext. HTTPS oder SSH-Tunnel empfohlen."
        case .es: "HTTP sin cifrar transmite tokens en texto plano. Se recomienda https o un túnel SSH."
        case .fr: "Le HTTP non chiffré transmet les jetons en clair. Préférez https ou un tunnel SSH."
        case .tr: "Şifrelenmemiş düz HTTP token'ları açık metin olarak iletir. https veya SSH tüneli tercih edin."
        default: "Unencrypted plain HTTP transmits tokens in cleartext. Prefer https or an SSH tunnel."
        }
    }

    public var allowUnencryptedHTTP: String {
        switch language {
        case .zhHans: "允许未加密的 HTTP"
        case .ja: "暗号化されていないHTTPを許可"
        case .de: "Unverschlüsseltes HTTP zulassen"
        case .es: "Permitir HTTP sin cifrar"
        case .fr: "Autoriser le HTTP non chiffré"
        case .tr: "Şifrelenmemiş HTTP'ye izin ver"
        default: "Allow unencrypted HTTP"
        }
    }

    public var testConnection: String {
        switch language {
        case .zhHans: "测试连接"
        case .ja: "接続テスト"
        case .de: "Verbindung testen"
        case .es: "Probar conexión"
        case .fr: "Tester la connexion"
        case .tr: "Bağlantıyı test et"
        default: "Test connection"
        }
    }

    public var testing: String {
        switch language {
        case .zhHans: "正在测试…"
        case .ja: "テスト中…"
        case .de: "Wird getestet…"
        case .es: "Probando…"
        case .fr: "Test en cours…"
        case .tr: "Test ediliyor…"
        default: "Testing…"
        }
    }

    public var saveAndConnect: String {
        switch language {
        case .zhHans: "保存并连接"
        case .ja: "保存して接続"
        case .de: "Speichern & verbinden"
        case .es: "Guardar y conectar"
        case .fr: "Enregistrer et connecter"
        case .tr: "Kaydet ve bağlan"
        default: "Save & connect"
        }
    }

    public var saveChanges: String {
        switch language {
        case .zhHans: "保存更改"
        case .ja: "変更を保存"
        case .de: "Änderungen speichern"
        case .es: "Guardar cambios"
        case .fr: "Enregistrer les modifications"
        case .tr: "Değişiklikleri Kaydet"
        default: "Save Changes"
        }
    }

    public var serverConnection: String {
        switch language {
        case .zhHans: "服务器连接"
        case .ja: "サーバー接続"
        case .de: "Server-Verbindung"
        case .es: "Conexión del servidor"
        case .fr: "Connexion serveur"
        case .tr: "Sunucu Bağlantısı"
        default: "Server Connection"
        }
    }

    public var serverName: String {
        switch language {
        case .zhHans: "服务器名称"
        case .ja: "サーバー名"
        case .de: "Server-Name"
        case .es: "Nombre del servidor"
        case .fr: "Nom du serveur"
        case .tr: "Sunucu Adı"
        default: "Server Name"
        }
    }

    public var verifyConnection: String {
        switch language {
        case .zhHans: "验证连接"
        case .ja: "接続を確認"
        case .de: "Verbindung prüfen"
        case .es: "Verificar conexión"
        case .fr: "Vérifier la connexion"
        case .tr: "Bağlantıyı Doğrula"
        default: "Verify Connection"
        }
    }

    public var connecting: String {
        switch language {
        case .zhHans: "正在连接…"
        case .ja: "接続中…"
        case .de: "Verbinde…"
        case .es: "Conectando…"
        case .fr: "Connexion…"
        case .tr: "Bağlanıyor…"
        default: "Connecting…"
        }
    }

    public var verifyingCredentials: String {
        switch language {
        case .zhHans: "正在验证凭据..."
        case .ja: "認証情報を確認中..."
        case .de: "Anmeldedaten werden überprüft..."
        case .es: "Verificando credenciales..."
        case .fr: "Vérification des identifiants..."
        case .tr: "Kimlik bilgileri doğrulanıyor..."
        default: "Verifying credentials..."
        }
    }

    public var dangerZone: String {
        switch language {
        case .zhHans: "危险区域"
        case .ja: "危険な操作"
        case .de: "Gefahrenzone"
        case .es: "Zona de peligro"
        case .fr: "Zone de danger"
        case .tr: "Tehlikeli Bölge"
        default: "Danger Zone"
        }
    }

    public var deleteThisConnection: String {
        switch language {
        case .zhHans: "删除此连接"
        case .ja: "この接続を削除"
        case .de: "Diese Verbindung löschen"
        case .es: "Eliminar esta conexión"
        case .fr: "Supprimer cette connexion"
        case .tr: "Bu bağlantıyı sil"
        default: "Delete this connection"
        }
    }

    public var deleteConnectionDescription: String {
        switch language {
        case .zhHans: "移除该服务器并从钥匙串中清除其令牌。"
        case .ja: "サーバーを削除し、キーチェーンからトークンを消去します。"
        case .de: "Entfernt den Server und löscht dessen Token aus dem Schlüsselbund."
        case .es: "Elimina el servidor y borra su token del Llavero."
        case .fr: "Supprime le serveur et efface son jeton du trousseau."
        case .tr: "Sunucuyu kaldırır ve token'ını Anahtar Zinciri'nden siler."
        default: "Removes the server and purges its token from Keychain."
        }
    }

    public var delete: String {
        switch language {
        case .zhHans: "删除"
        case .ja: "削除"
        case .de: "Löschen"
        case .es: "Eliminar"
        case .fr: "Supprimer"
        case .tr: "Sil"
        default: "Delete"
        }
    }

    public var areYouSureCannotBeUndone: String {
        switch language {
        case .zhHans: "确定吗？此操作无法撤销。"
        case .ja: "本当によろしいですか？この操作は取り消せません。"
        case .de: "Sind Sie sicher? Dies kann nicht rückgängig gemacht werden."
        case .es: "¿Estás seguro? Esta acción no se puede deshacer."
        case .fr: "Êtes-vous sûr ? Cette action est irréversible."
        case .tr: "Emin misiniz? Bu işlem geri alınamaz."
        default: "Are you sure? This cannot be undone."
        }
    }

    public var confirmDelete: String {
        switch language {
        case .zhHans: "确认删除"
        case .ja: "削除を確定"
        case .de: "Löschen bestätigen"
        case .es: "Confirmar eliminación"
        case .fr: "Confirmer la suppression"
        case .tr: "Silmeyi Onayla"
        default: "Confirm Delete"
        }
    }

    // MARK: - Onboarding Window

    public var onboardingWelcomeTag: String {
        switch language {
        case .zhHans: "仅监控 · 注重隐私"
        case .ja: "監視専用 · プライベート"
        case .de: "NUR ÜBERWACHUNG · PRIVAT"
        case .es: "SOLO MONITORIZACIÓN · PRIVADO"
        case .fr: "SURVEILLANCE SEULEMENT · PRIVÉ"
        case .tr: "YALNIZCA İZLEME · GİZLİ"
        default: "MONITOR ONLY · PRIVATE"
        }
    }

    public var welcomeToPanelBar: String {
        switch language {
        case .zhHans: "欢迎使用\nPanelBar"
        case .ja: "PanelBar へ\nようこそ"
        case .de: "Willkommen bei\nPanelBar"
        case .es: "Bienvenido a\nPanelBar"
        case .fr: "Bienvenue sur\nPanelBar"
        case .tr: "PanelBar'a\nHoş Geldiniz"
        default: "Welcome to\nPanelBar"
        }
    }

    public var onboardingSubtitle: String {
        switch language {
        case .zhHans: "一款菜单栏应用，同时支持 cPanel 账户和 WHM 服务器，各自拥有独立仪表盘。"
        case .ja: "cPanelアカウントとWHMサーバーを一元管理できる、専用ダッシュボード付きメニューバーアプリ。"
        case .de: "Eine Menüleisten-App für cPanel-Konten und WHM-Server mit jeweils eigenem Dashboard."
        case .es: "Una app de barra de menús para cuentas cPanel y servidores WHM, cada uno con su propio panel."
        case .fr: "Une application de barre des menus pour vos comptes cPanel et serveurs WHM, chacun avec son tableau de bord."
        case .tr: "Her biri kendi kontrol paneline sahip cPanel hesapları ve WHM sunucuları için menü çubuğu uygulaması."
        default: "One menu bar app for a cPanel account and a WHM server, each with its own dashboard."
        }
    }

    public var onboardingBullet1: String {
        switch language {
        case .zhHans: "读取使用量、SSL、服务与硬件状态。绝不会启动、停止或修改任何配置。"
        case .ja: "使用量、SSL、サービス、ハードウェア情報を取得します。設定の開始・停止・変更は一切行いません。"
        case .de: "Liest Auslastung, SSL, Dienste und Hardware. Startet, stoppt oder ändert niemals etwas."
        case .es: "Consulta uso, SSL, servicios y hardware. Nunca inicia, detiene ni modifica nada."
        case .fr: "Lit l'utilisation, le SSL, les services et le matériel. Ne démarre, n'arrête ni ne modifie rien."
        case .tr: "Kullanımı, SSL'i, servisleri ve donanımı okur. Asla hiçbir şeyi başlatmaz, durdurmaz veya değiştirmez."
        default: "Reads usage, SSL, services and hardware. Never starts, stops or changes anything."
        }
    }

    public var onboardingBullet2: String {
        switch language {
        case .zhHans: "令牌安全保存在钥匙串中。绝无任何统计分析。"
        case .ja: "トークンはキーチェーンに安全に保存されます。分析機能は一切ありません。"
        case .de: "Tokens bleiben in Ihrem Schlüsselbund. Keine Analysen, niemals."
        case .es: "Los tokens se guardan en tu Llavero. Sin analíticas, jamás."
        case .fr: "Les jetons restent dans votre trousseau. Aucune analyse, jamais."
        case .tr: "Token'lar Anahtar Zincirinizde saklanır. Asla analiz veya takip içermez."
        default: "Tokens stay in your Keychain. No analytics, ever."
        }
    }

    public var getStarted: String {
        switch language {
        case .zhHans: "开始使用  →"
        case .ja: "使ってみる  →"
        case .de: "Loslegen  →"
        case .es: "Empezar  →"
        case .fr: "Commencer  →"
        case .tr: "Başlayın  →"
        default: "Get started  \u{2192}"
        }
    }

    public var connectAccountOrServer: String {
        switch language {
        case .zhHans: "连接账户或服务器"
        case .ja: "アカウントまたはサーバーを接続"
        case .de: "Konto oder Server verbinden"
        case .es: "Conectar una cuenta o servidor"
        case .fr: "Connecter un compte ou serveur"
        case .tr: "Bir hesap veya sunucu bağlayın"
        default: "Connect an account or server"
        }
    }

    public var connectStepSubtitle: String {
        switch language {
        case .zhHans: "cPanel 和 WHM 使用不同的令牌并呈现不同的仪表盘。"
        case .ja: "cPanel と WHM では使用するトークンや表示されるダッシュボードが異なります。"
        case .de: "cPanel und WHM verwenden unterschiedliche Tokens und zeigen verschiedene Dashboards."
        case .es: "cPanel y WHM usan tokens diferentes y muestran paneles distintos."
        case .fr: "cPanel et WHM utilisent des jetons différents et affichent des tableaux de bord différents."
        case .tr: "cPanel ve WHM farklı token'lar kullanır ve farklı kontrol panelleri gösterir."
        default: "cPanel and WHM use different tokens and show different dashboards."
        }
    }

    public var saveAnyway: String {
        switch language {
        case .zhHans: "仍然保存"
        case .ja: "このまま保存"
        case .de: "Trotzdem speichern"
        case .es: "Guardar de todos modos"
        case .fr: "Enregistrer quand même"
        case .tr: "Yine de kaydet"
        default: "Save anyway"
        }
    }

    public var connectAndContinue: String {
        switch language {
        case .zhHans: "连接并继续  →"
        case .ja: "接続して次へ  →"
        case .de: "Verbinden & fortfahren  →"
        case .es: "Conectar y continuar  →"
        case .fr: "Connecter et continuer  →"
        case .tr: "Bağlan ve devam et  →"
        default: "Connect & continue  \u{2192}"
        }
    }

    public var youreConnected: String {
        switch language {
        case .zhHans: "连接成功"
        case .ja: "接続が完了しました"
        case .de: "Verbunden"
        case .es: "Conectado"
        case .fr: "Vous êtes connecté"
        case .tr: "Bağlandınız"
        default: "You're connected"
        }
    }

    public var saved: String {
        switch language {
        case .zhHans: "已保存"
        case .ja: "保存済み"
        case .de: "Gespeichert"
        case .es: "Guardado"
        case .fr: "Enregistré"
        case .tr: "Kaydedildi"
        default: "Saved"
        }
    }

    public var openPanelBar: String {
        switch language {
        case .zhHans: "打开 PanelBar"
        case .ja: "PanelBar を開く"
        case .de: "PanelBar öffnen"
        case .es: "Abrir PanelBar"
        case .fr: "Ouvrir PanelBar"
        case .tr: "PanelBar'ı Aç"
        default: "Open PanelBar"
        }
    }

    public var onboardingTip1: String {
        switch language {
        case .zhHans: "在菜单栏中找到 PanelBar。需要注意时圆点会变为琥珀色。"
        case .ja: "メニューバーに PanelBar が常駐します。確認事項がある時はドットがオレンジに変わります。"
        case .de: "PanelBar in der Menüleiste finden. Der Punkt wird bernsteinfarben, wenn Aufmerksamkeit nötig ist."
        case .es: "Encuentra PanelBar en la barra de menús. El punto se vuelve ámbar cuando requiere atención."
        case .fr: "Retrouvez PanelBar dans la barre des menus. Le point passe à l'ambre en cas d'attention requise."
        case .tr: "PanelBar'ı menü çubuğunda bulun. Dikkat gerektiğinde nokta sarı renge döner."
        default: "Find PanelBar in the menu bar. The dot turns amber when something needs attention."
        }
    }

    public var onboardingTip2: String {
        switch language {
        case .zhHans: "PanelBar 仅提供只读监控。所有修改操作仍在 cPanel 和 WHM 中进行。"
        case .ja: "PanelBar は情報表示のみ行います。設定の変更は各 cPanel や WHM で行われます。"
        case .de: "PanelBar liest nur Daten. Änderungen verbleiben in cPanel und WHM."
        case .es: "PanelBar es de solo lectura. Los cambios se gestionan desde cPanel y WHM."
        case .fr: "PanelBar est en lecture seule. Les modifications se font toujours dans cPanel et WHM."
        case .tr: "PanelBar yalnızca okuma amaçlıdır. Değişiklikler cPanel ve WHM üzerinde kalır."
        default: "PanelBar only reads. Changes stay in cPanel and WHM."
        }
    }

    public var onboardingTip3: String {
        switch language {
        case .zhHans: "随时可以在“设置”中添加更多账户或服务器。"
        case .ja: "いつでも「設定」から追加のアカウントやサーバーを登録できます。"
        case .de: "In den Einstellungen können Sie jederzeit weitere Konten oder Server hinzufügen."
        case .es: "Añade más cuentas o servidores en cualquier momento desde Ajustes."
        case .fr: "Ajoutez d'autres comptes ou serveurs à tout moment depuis les Réglages."
        case .tr: "Ayarlar'dan dilediğiniz zaman daha fazla hesap veya sunucu ekleyebilirsiniz."
        default: "Add more accounts or servers any time from Settings."
        }
    }
}

extension AppLanguage {
    public var strings: LocalizedStrings {
        LocalizedStrings(language: self)
    }
}
