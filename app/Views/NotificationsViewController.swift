import UIKit

// 移除有问题的扩展

class NotificationsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Constants.Colors.backgroundColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(NotificationSwitchTableViewCell.self, forCellReuseIdentifier: "NotificationSwitchCell")
        return tableView
    }()
    
    // 通知设置数据
    private let notificationSections: [(title: String, items: [(title: String, description: String, isEnabled: Bool)])] = [
        ("常規提醒", [
            ("餵奶提醒", "定時提醒餵奶時間", true),
            ("換尿布提醒", "定時提醒更換尿布", true),
            ("睡眠提醒", "提醒寶寶的睡眠時間", true),
            ("藥物提醒", "提醒按時服藥", false)
        ]),
        ("智能提醒", [
            ("智能學習提醒", "根據寶寶習慣自動調整提醒時間", true),
            ("異常行為提醒", "當發現寶寶行為異常時提醒", false),
            ("成長里程碑提醒", "當寶寶達到成長里程碑時提醒", true)
        ]),
        ("社交提醒", [
            ("社群互動提醒", "當有人回覆您的帖子時提醒", true),
            ("專家回復提醒", "當專家回覆您的問題時提醒", true)
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.backgroundColor
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        title = "通知設置"
        navigationItem.largeTitleDisplayMode = .never
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
extension NotificationsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return notificationSections.count + 1 // 添加额外的一个部分用于显示主开关
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // 主开关部分只有一行
        }
        return notificationSections[section - 1].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // 主开关部分
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationSwitchCell", for: indexPath) as! NotificationSwitchTableViewCell
            cell.configure(title: "推送通知", description: "允許應用發送通知")
            
            // 获取当前设置
            let isEnabled = UserDefaults.standard.bool(forKey: "AllNotificationsEnabled")
            cell.switchControl.isOn = isEnabled
            
            cell.switchValueChanged = { [weak self] isOn in
                UserDefaults.standard.set(isOn, forKey: "AllNotificationsEnabled")
                self?.toggleAllNotifications(isOn: isOn)
            }
            
            return cell
        } else {
            // 具体通知项
            let sectionIndex = indexPath.section - 1
            let item = notificationSections[sectionIndex].items[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationSwitchCell", for: indexPath) as! NotificationSwitchTableViewCell
            cell.configure(title: item.title, description: item.description)
            
            let key = "Notification_\(sectionIndex)_\(indexPath.row)"
            
            // 获取保存的设置或使用默认值
            let isEnabled = UserDefaults.standard.object(forKey: key) as? Bool ?? item.isEnabled
            cell.switchControl.isOn = isEnabled
            
            cell.switchValueChanged = { isOn in
                // 保存设置
                UserDefaults.standard.set(isOn, forKey: key)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return notificationSections[section - 1].title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "開啟通知以接收寶寶活動和應用更新的提醒"
        }
        return nil
    }
    
    private func toggleAllNotifications(isOn: Bool) {
        // 遍历所有通知设置并更新
        for sectionIndex in 0..<notificationSections.count {
            for rowIndex in 0..<notificationSections[sectionIndex].items.count {
                let key = "Notification_\(sectionIndex)_\(rowIndex)"
                UserDefaults.standard.set(isOn, forKey: key)
            }
        }
        
        // 重新加载表格视图以更新UI
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension NotificationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 如果是主开关部分的行，不执行任何操作
        if indexPath.section == 0 {
            return
        }
        
        // 对于特定的通知项，可以执行其他操作，例如显示详细设置
        let sectionIndex = indexPath.section - 1
        let item = notificationSections[sectionIndex].items[indexPath.row]
        
        // 例如，对于餵奶提醒，显示详细设置
        if sectionIndex == 0 && indexPath.row == 0 {
            showFeedingNotificationSettings()
        }
    }
    
    private func showFeedingNotificationSettings() {
        let alertController = UIAlertController(title: "餵奶提醒設置", message: "設置餵奶提醒的頻率", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "每2小時", style: .default) { _ in
            self.setFeedingInterval(hours: 2)
        })
        
        alertController.addAction(UIAlertAction(title: "每3小時", style: .default) { _ in
            self.setFeedingInterval(hours: 3)
        })
        
        alertController.addAction(UIAlertAction(title: "每4小時", style: .default) { _ in
            self.setFeedingInterval(hours: 4)
        })
        
        alertController.addAction(UIAlertAction(title: "自定義", style: .default) { _ in
            self.showCustomIntervalPicker()
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    private func setFeedingInterval(hours: Int) {
        UserDefaults.standard.set(hours, forKey: "FeedingReminderInterval")
        
        let alertController = UIAlertController(
            title: "設置成功",
            message: "餵奶提醒已設置為每\(hours)小時",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    private func showCustomIntervalPicker() {
        let alertController = UIAlertController(title: "自定義間隔", message: "請輸入小時數（1-12）", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.keyboardType = .numberPad
            textField.placeholder = "小時"
        }
        
        let confirmAction = UIAlertAction(title: "確定", style: .default) { [weak self] _ in
            if let textField = alertController.textFields?.first,
               let hoursText = textField.text,
               let hours = Int(hoursText),
               hours >= 1 && hours <= 12 {
                self?.setFeedingInterval(hours: hours)
            } else {
                // 输入无效，显示错误提示
                let errorAlert = UIAlertController(
                    title: "輸入錯誤",
                    message: "請輸入1到12之間的數字",
                    preferredStyle: .alert
                )
                errorAlert.addAction(UIAlertAction(title: "確定", style: .default))
                self?.present(errorAlert, animated: true)
            }
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alertController, animated: true)
    }
}

// MARK: - NotificationSwitchTableViewCell
class NotificationSwitchTableViewCell: UITableViewCell {
    
    var switchValueChanged: ((Bool) -> Void)?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Constants.Colors.secondaryTextColor
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(switchControl)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        switchControl.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
    }
    
    func configure(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    @objc private func switchValueDidChange(_ sender: UISwitch) {
        switchValueChanged?(sender.isOn)
    }
} 