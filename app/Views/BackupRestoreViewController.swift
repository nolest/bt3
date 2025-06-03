import UIKit

class BackupRestoreViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Constants.Colors.backgroundColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    // 备份记录
    private var backupRecords: [(date: Date, size: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.backgroundColor
        setupNavigationBar()
        setupTableView()
        loadBackupRecords()
    }
    
    private func setupNavigationBar() {
        title = "備份與恢復"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(createBackupButtonTapped)
        )
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
    
    private func loadBackupRecords() {
        // 模拟加载备份记录
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        backupRecords = [
            (dateFormatter.date(from: "2023-06-15 10:30:00")!, "2.5 MB"),
            (dateFormatter.date(from: "2023-06-01 22:15:00")!, "2.3 MB"),
            (dateFormatter.date(from: "2023-05-15 16:45:00")!, "2.1 MB")
        ]
        
        tableView.reloadData()
    }
    
    @objc private func createBackupButtonTapped() {
        // 显示备份选项
        let alertController = UIAlertController(
            title: "創建備份",
            message: "請選擇備份方式",
            preferredStyle: .actionSheet
        )
        
        alertController.addAction(UIAlertAction(title: "本地備份", style: .default) { _ in
            self.performBackup(type: "本地")
        })
        
        alertController.addAction(UIAlertAction(title: "iCloud備份", style: .default) { _ in
            self.performBackup(type: "iCloud")
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    private func performBackup(type: String) {
        // 显示备份进度
        let progressAlert = UIAlertController(
            title: "正在創建\(type)備份",
            message: "請稍候...",
            preferredStyle: .alert
        )
        
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        progressAlert.view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: progressAlert.view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: progressAlert.view.trailingAnchor, constant: -20),
            progressView.topAnchor.constraint(equalTo: progressAlert.view.topAnchor, constant: 80),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        present(progressAlert, animated: true)
        
        // 模拟备份进度
        var progress: Float = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            progress += 0.05
            progressView.progress = progress
            
            if progress >= 1.0 {
                timer.invalidate()
                self.dismiss(animated: true) {
                    self.showBackupSuccess(type: type)
                    self.addNewBackupRecord()
                }
            }
        }
    }
    
    private func showBackupSuccess(type: String) {
        let alertController = UIAlertController(
            title: "備份成功",
            message: "數據已成功備份至\(type)",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    private func addNewBackupRecord() {
        // 添加新的备份记录
        let now = Date()
        backupRecords.insert((now, "2.6 MB"), at: 0)
        tableView.reloadData()
    }
    
    private func restoreFromBackup(at index: Int) {
        let backup = backupRecords[index]
        
        // 显示恢复确认
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: backup.date)
        
        let alertController = UIAlertController(
            title: "恢復數據",
            message: "您確定要從 \(dateString) 的備份恢復數據嗎？當前數據將被覆蓋。",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        alertController.addAction(UIAlertAction(title: "恢復", style: .destructive) { _ in
            self.performRestore(from: backup)
        })
        
        present(alertController, animated: true)
    }
    
    private func performRestore(from backup: (date: Date, size: String)) {
        // 显示恢复进度
        let progressAlert = UIAlertController(
            title: "正在恢復數據",
            message: "請稍候...",
            preferredStyle: .alert
        )
        
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        progressAlert.view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: progressAlert.view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: progressAlert.view.trailingAnchor, constant: -20),
            progressView.topAnchor.constraint(equalTo: progressAlert.view.topAnchor, constant: 80),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        present(progressAlert, animated: true)
        
        // 模拟恢复进度
        var progress: Float = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            progress += 0.05
            progressView.progress = progress
            
            if progress >= 1.0 {
                timer.invalidate()
                self.dismiss(animated: true) {
                    self.showRestoreSuccess()
                }
            }
        }
    }
    
    private func showRestoreSuccess() {
        let alertController = UIAlertController(
            title: "恢復成功",
            message: "數據已成功恢復",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    private func deleteBackup(at index: Int) {
        let backup = backupRecords[index]
        
        // 显示删除确认
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: backup.date)
        
        let alertController = UIAlertController(
            title: "刪除備份",
            message: "您確定要刪除 \(dateString) 的備份嗎？此操作無法撤銷。",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        alertController.addAction(UIAlertAction(title: "刪除", style: .destructive) { _ in
            self.backupRecords.remove(at: index)
            self.tableView.reloadData()
        })
        
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension BackupRestoreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backupRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let backup = backupRecords[indexPath.row]
        
        // 格式化日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: backup.date)
        
        cell.textLabel?.text = dateString
        cell.detailTextLabel?.text = backup.size
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "備份歷史記錄"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "點擊備份記錄可以查看詳情和恢復選項"
    }
}

// MARK: - UITableViewDelegate
extension BackupRestoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 显示备份详情和操作选项
        let backup = backupRecords[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: backup.date)
        
        let alertController = UIAlertController(
            title: "備份詳情",
            message: "日期: \(dateString)\n大小: \(backup.size)",
            preferredStyle: .actionSheet
        )
        
        alertController.addAction(UIAlertAction(title: "恢復此備份", style: .default) { _ in
            self.restoreFromBackup(at: indexPath.row)
        })
        
        alertController.addAction(UIAlertAction(title: "刪除此備份", style: .destructive) { _ in
            self.deleteBackup(at: indexPath.row)
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // 也可以响应详情按钮的点击
        let backup = backupRecords[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        let dateString = dateFormatter.string(from: backup.date)
        
        let alertController = UIAlertController(
            title: "備份詳細信息",
            message: "創建日期: \(dateString)\n備份大小: \(backup.size)\n備份類型: iCloud\n設備: iPhone",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        
        present(alertController, animated: true)
    }
} 