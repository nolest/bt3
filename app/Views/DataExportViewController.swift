import UIKit

class DataExportViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Constants.Colors.backgroundColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    // 导出选项
    private let exportSections: [(title: String, items: [(title: String, detail: String, icon: String)])] = [
        ("數據範圍", [
            ("所有數據", "導出所有記錄的數據", "square.and.arrow.up"),
            ("特定時間範圍", "選擇特定的時間範圍導出", "calendar")
        ]),
        ("數據類型", [
            ("餵奶記錄", "導出餵奶相關的記錄", "drop.fill"),
            ("睡眠記錄", "導出睡眠相關的記錄", "bed.double.fill"),
            ("換尿布記錄", "導出換尿布相關的記錄", "wind"),
            ("成長記錄", "導出身高體重等成長數據", "chart.line.uptrend.xyaxis"),
            ("里程碑記錄", "導出發展里程碑記錄", "flag.fill")
        ]),
        ("導出格式", [
            ("CSV格式", "適合在Excel等電子表格軟件中使用", "doc.text"),
            ("PDF報告", "格式化的報告，包含圖表與分析", "doc.richtext"),
            ("JSON格式", "適合開發者或其他應用程序使用", "curlybraces")
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.backgroundColor
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        title = "數據導出"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "導出",
            style: .done,
            target: self,
            action: #selector(exportButtonTapped)
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
    
    @objc private func exportButtonTapped() {
        // 检查选择的选项
        if let selectedRange = UserDefaults.standard.string(forKey: "SelectedDataRange"),
           let selectedFormat = UserDefaults.standard.string(forKey: "SelectedExportFormat") {
            
            // 获取选中的数据类型
            var selectedTypes: [String] = []
            for row in 0..<exportSections[1].items.count {
                let key = "DataType_\(row)"
                if UserDefaults.standard.bool(forKey: key) {
                    selectedTypes.append(exportSections[1].items[row].title)
                }
            }
            
            if selectedTypes.isEmpty {
                // 如果没有选择数据类型，显示错误提示
                let alertController = UIAlertController(
                    title: "未選擇數據類型",
                    message: "請至少選擇一種數據類型進行導出",
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "確定", style: .default))
                present(alertController, animated: true)
                return
            }
            
            // 模拟导出过程
            showExportProgress()
        } else {
            // 如果没有选择数据范围或格式，显示错误提示
            let alertController = UIAlertController(
                title: "導出設置不完整",
                message: "請選擇數據範圍和導出格式",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "確定", style: .default))
            present(alertController, animated: true)
        }
    }
    
    private func showExportProgress() {
        // 创建并显示进度提示
        let progressAlert = UIAlertController(
            title: "正在導出數據",
            message: "請稍候...",
            preferredStyle: .alert
        )
        
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加进度条到警告控制器
        progressAlert.view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: progressAlert.view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: progressAlert.view.trailingAnchor, constant: -20),
            progressView.topAnchor.constraint(equalTo: progressAlert.view.topAnchor, constant: 80),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        present(progressAlert, animated: true)
        
        // 模拟进度更新
        var progress: Float = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            progress += 0.05
            progressView.progress = progress
            
            if progress >= 1.0 {
                timer.invalidate()
                self.dismiss(animated: true) {
                    self.showExportSuccess()
                }
            }
        }
    }
    
    private func showExportSuccess() {
        let format = UserDefaults.standard.string(forKey: "SelectedExportFormat") ?? "CSV格式"
        
        let alertController = UIAlertController(
            title: "導出成功",
            message: "數據已成功導出為\(format)。您要如何處理導出的文件？",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "分享", style: .default) { _ in
            self.shareExportedFile()
        })
        
        alertController.addAction(UIAlertAction(title: "保存到設備", style: .default) { _ in
            self.saveToDevice()
        })
        
        alertController.addAction(UIAlertAction(title: "完成", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    private func shareExportedFile() {
        // 模拟分享操作
        let activityViewController = UIActivityViewController(
            activityItems: ["寶寶數據導出文件"],
            applicationActivities: nil
        )
        
        present(activityViewController, animated: true)
    }
    
    private func saveToDevice() {
        // 模拟保存操作
        let alertController = UIAlertController(
            title: "文件已保存",
            message: "數據文件已保存到設備",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension DataExportViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return exportSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exportSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = exportSections[indexPath.section].items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.detail
        cell.imageView?.image = UIImage(systemName: item.icon)
        cell.imageView?.tintColor = Constants.Colors.primaryColor
        
        // 设置选中状态
        if indexPath.section == 0 {
            // 数据范围部分
            if let selectedRange = UserDefaults.standard.string(forKey: "SelectedDataRange") {
                cell.accessoryType = (selectedRange == item.title) ? .checkmark : .none
            } else {
                cell.accessoryType = .none
            }
        } else if indexPath.section == 1 {
            // 数据类型部分（多选）
            let key = "DataType_\(indexPath.row)"
            cell.accessoryType = UserDefaults.standard.bool(forKey: key) ? .checkmark : .none
        } else if indexPath.section == 2 {
            // 导出格式部分
            if let selectedFormat = UserDefaults.standard.string(forKey: "SelectedExportFormat") {
                cell.accessoryType = (selectedFormat == item.title) ? .checkmark : .none
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return exportSections[section].title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            return "可以選擇多種數據類型同時導出"
        }
        return nil
    }
}

// MARK: - UITableViewDelegate
extension DataExportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = exportSections[indexPath.section].items[indexPath.row]
        
        if indexPath.section == 0 {
            // 数据范围部分（单选）
            if indexPath.row == 0 {
                // "所有数据"选项
                UserDefaults.standard.set(item.title, forKey: "SelectedDataRange")
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            } else if indexPath.row == 1 {
                // "特定时间范围"选项
                showDateRangePicker()
            }
        } else if indexPath.section == 1 {
            // 数据类型部分（多选）
            let key = "DataType_\(indexPath.row)"
            let isSelected = !UserDefaults.standard.bool(forKey: key)
            UserDefaults.standard.set(isSelected, forKey: key)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else if indexPath.section == 2 {
            // 导出格式部分（单选）
            UserDefaults.standard.set(item.title, forKey: "SelectedExportFormat")
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
    }
    
    private func showDateRangePicker() {
        let alertController = UIAlertController(
            title: "選擇時間範圍",
            message: "請選擇要導出數據的時間範圍",
            preferredStyle: .actionSheet
        )
        
        alertController.addAction(UIAlertAction(title: "過去一週", style: .default) { _ in
            self.setDateRange(title: "過去一週")
        })
        
        alertController.addAction(UIAlertAction(title: "過去一個月", style: .default) { _ in
            self.setDateRange(title: "過去一個月")
        })
        
        alertController.addAction(UIAlertAction(title: "過去三個月", style: .default) { _ in
            self.setDateRange(title: "過去三個月")
        })
        
        alertController.addAction(UIAlertAction(title: "自定義", style: .default) { _ in
            self.showCustomDateRangePicker()
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    private func setDateRange(title: String) {
        UserDefaults.standard.set(title, forKey: "SelectedDataRange")
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    private func showCustomDateRangePicker() {
        // 实际应用中应该使用日期选择器
        // 这里简化为提示框
        let alertController = UIAlertController(
            title: "自定義時間範圍",
            message: "在實際應用中，這裡會顯示日期選擇器",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "確定", style: .default) { _ in
            self.setDateRange(title: "自定義範圍")
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alertController, animated: true)
    }
} 