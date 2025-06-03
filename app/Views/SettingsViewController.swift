import UIKit

class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Constants.Colors.backgroundColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "SwitchCell")
        return tableView
    }()
    
    // 设置数据
    private let settingSections: [(title: String, items: [(title: String, type: SettingItemType, icon: String, hasSwitch: Bool)])] = [
        ("賬號設置", [
            ("個人資料", .profile, "person.circle", false),
            ("寶寶資料", .babyProfile, "figure.and.child", false),
            ("家人共享", .familySharing, "person.2", false)
        ]),
        ("應用設置", [
            ("通知設置", .notifications, "bell", false),
            ("夜間模式", .darkMode, "moon", true),
            ("語言", .language, "globe", false)
        ]),
        ("數據管理", [
            ("雲端同步", .cloudSync, "cloud", true),
            ("數據導出", .dataExport, "square.and.arrow.up", false),
            ("備份與恢復", .backup, "arrow.clockwise", false)
        ]),
        ("隱私與安全", [
            ("隱私設置", .privacy, "hand.raised", false),
            ("密碼與安全", .security, "lock", false)
        ]),
        ("關於", [
            ("版本信息", .version, "info.circle", false),
            ("幫助與反饋", .help, "questionmark.circle", false),
            ("服務條款", .terms, "doc.text", false),
            ("隱私政策", .privacyPolicy, "shield", false)
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.backgroundColor
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        title = "設置"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingItem = settingSections[indexPath.section].items[indexPath.row]
        
        if settingItem.hasSwitch {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchTableViewCell
            cell.configure(title: settingItem.title, icon: settingItem.icon)
            
            // 设置开关初始状态
            switch settingItem.type {
            case .darkMode:
                cell.switchControl.isOn = UserDefaults.standard.bool(forKey: "darkModeEnabled")
                cell.switchValueChanged = { [weak self] isOn in
                    self?.toggleDarkMode(isOn: isOn)
                }
            case .cloudSync:
                cell.switchControl.isOn = UserDefaults.standard.bool(forKey: "cloudSyncEnabled")
                cell.switchValueChanged = { [weak self] isOn in
                    self?.toggleCloudSync(isOn: isOn)
                }
            default:
                break
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
            
            cell.textLabel?.text = settingItem.title
            cell.imageView?.image = UIImage(systemName: settingItem.icon)
            cell.imageView?.tintColor = Constants.Colors.primaryColor
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingSections[section].title
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let settingItem = settingSections[indexPath.section].items[indexPath.row]
        
        switch settingItem.type {
        case .profile:
            showProfileSettings()
        case .babyProfile:
            showBabyProfileSettings()
        case .familySharing:
            showFamilySharingSettings()
        case .notifications:
            showNotificationSettings()
        case .language:
            showLanguageSettings()
        case .dataExport:
            showDataExportOptions()
        case .backup:
            showBackupOptions()
        case .privacy:
            showPrivacySettings()
        case .security:
            showSecuritySettings()
        case .version:
            showVersionInfo()
        case .help:
            showHelpAndFeedback()
        case .terms:
            showTermsOfService()
        case .privacyPolicy:
            showPrivacyPolicy()
        default:
            break
        }
    }
}

// MARK: - Settings Actions
extension SettingsViewController {
    private func showProfileSettings() {
        let alertController = UIAlertController(title: "個人資料", message: "這裡將顯示個人資料設置頁面", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    private func showBabyProfileSettings() {
        let alertController = UIAlertController(title: "寶寶資料", message: "這裡將顯示寶寶資料設置頁面", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    private func showFamilySharingSettings() {
        let alertController = UIAlertController(title: "家人共享", message: "這裡將顯示家人共享設置頁面", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    private func showNotificationSettings() {
        // 导航到通知设置页面
        let notificationsVC = NotificationsViewController()
        navigationController?.pushViewController(notificationsVC, animated: true)
    }
    
    private func toggleDarkMode(isOn: Bool) {
        // 保存设置
        UserDefaults.standard.set(isOn, forKey: "darkModeEnabled")
        
        // 模拟切换深色模式
        let alertController = UIAlertController(
            title: isOn ? "已開啓夜間模式" : "已關閉夜間模式",
            message: "夜間模式設置已更新",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    private func showLanguageSettings() {
        let alertController = UIAlertController(title: "語言設置", message: "這裡將顯示語言設置頁面", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    private func toggleCloudSync(isOn: Bool) {
        // 保存设置
        UserDefaults.standard.set(isOn, forKey: "cloudSyncEnabled")
        
        // 提示状态变化
        let alertController = UIAlertController(
            title: isOn ? "已開啓雲端同步" : "已關閉雲端同步",
            message: "雲端同步設置已更新",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    private func showDataExportOptions() {
        // 导航到数据导出页面
        let dataExportVC = DataExportViewController()
        navigationController?.pushViewController(dataExportVC, animated: true)
    }
    
    private func exportData(format: String) {
        let alertController = UIAlertController(
            title: "導出成功",
            message: "數據已成功導出為\(format)格式",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    private func showBackupOptions() {
        // 导航到备份与恢复页面
        let backupRestoreVC = BackupRestoreViewController()
        navigationController?.pushViewController(backupRestoreVC, animated: true)
    }
    
    private func showPrivacySettings() {
        let alertController = UIAlertController(title: "隱私設置", message: "這裡將顯示隱私設置頁面", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    private func showSecuritySettings() {
        let alertController = UIAlertController(title: "密碼與安全", message: "這裡將顯示密碼與安全設置頁面", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    private func showVersionInfo() {
        let alertController = UIAlertController(
            title: "版本信息",
            message: "智能寶寶生活記錄 v1.0.0\n© 2023 BabyTracker Team",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    private func showHelpAndFeedback() {
        let alertController = UIAlertController(title: "幫助與反饋", message: "這裡將顯示幫助與反饋頁面", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    private func showTermsOfService() {
        let alertController = UIAlertController(title: "服務條款", message: "這裡將顯示服務條款頁面", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    private func showPrivacyPolicy() {
        let alertController = UIAlertController(title: "隱私政策", message: "這裡將顯示隱私政策頁面", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
}

// MARK: - Setting Item Type
enum SettingItemType {
    case profile
    case babyProfile
    case familySharing
    case notifications
    case darkMode
    case language
    case cloudSync
    case dataExport
    case backup
    case privacy
    case security
    case version
    case help
    case terms
    case privacyPolicy
}

// MARK: - SwitchTableViewCell
class SwitchTableViewCell: UITableViewCell {
    
    var switchValueChanged: ((Bool) -> Void)?
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.Colors.primaryColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = Constants.Colors.primaryColor
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(switchControl)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.heightAnchor.constraint(equalToConstant: 25),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        switchControl.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
    }
    
    func configure(title: String, icon: String) {
        titleLabel.text = title
        iconImageView.image = UIImage(systemName: icon)
    }
    
    @objc private func switchValueDidChange(_ sender: UISwitch) {
        switchValueChanged?(sender.isOn)
    }
} 