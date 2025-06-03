import UIKit

class RecordsViewController: UIViewController {
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["餵奶", "換尿布", "睡眠", "成長", "里程碑", "自訂"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RecordCell.self, forCellReuseIdentifier: "RecordCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = Constants.Colors.primaryColor
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 模拟数据
    private var feedingRecords: [(time: String, title: String, subtitle: String, icon: String)] = [
        ("10:30", "母乳餵食", "左側 · 15分鐘", "drop.fill"),
        ("07:15", "母乳餵食", "右側 · 20分鐘", "drop.fill"),
        ("04:00", "奶瓶餵食", "配方奶 · 120ml", "drop.fill"),
        ("01:30", "母乳餵食", "左側 · 10分鐘", "drop.fill")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.backgroundColor
        
        setupViews()
        setupNavigationBar()
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(calendarButtonTapped))
        
        if #available(iOS 15.0, *) {
            navigationItem.rightBarButtonItem?.tintColor = Constants.Colors.primaryColor
        }
    }
    
    private func setupViews() {
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Spacing.medium),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Spacing.large),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Spacing.large),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Constants.Spacing.medium),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Spacing.large),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Spacing.large),
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        // 根据选中的分段控制器索引切换显示的记录类型
        print("选中的记录类型: \(sender.selectedSegmentIndex)")
        tableView.reloadData()
    }
    
    @objc private func addButtonTapped() {
        // 根据当前选中的分段控制器索引添加对应类型的记录
        let selectedType = segmentedControl.selectedSegmentIndex
        let typeNames = ["餵奶", "換尿布", "睡眠", "成長", "里程碑", "自訂"]
        let typeName = typeNames[selectedType]
        
        let alertController = UIAlertController(title: "添加\(typeName)記錄", message: "請填寫以下信息", preferredStyle: .alert)
        
        // 根据不同类型添加不同的输入字段
        switch selectedType {
        case 0: // 餵奶
            alertController.addTextField { textField in
                textField.placeholder = "餵奶方式（母乳/奶瓶）"
            }
            alertController.addTextField { textField in
                textField.placeholder = "持續時間（分鐘）或奶量（ml）"
                textField.keyboardType = .numberPad
            }
        case 1: // 換尿布
            alertController.addTextField { textField in
                textField.placeholder = "尿布類型（尿/便/混合）"
            }
        case 2: // 睡眠
            alertController.addTextField { textField in
                textField.placeholder = "開始時間（HH:MM）"
            }
            alertController.addTextField { textField in
                textField.placeholder = "結束時間（HH:MM）"
            }
        case 3: // 成長
            alertController.addTextField { textField in
                textField.placeholder = "身高（cm）"
                textField.keyboardType = .decimalPad
            }
            alertController.addTextField { textField in
                textField.placeholder = "體重（kg）"
                textField.keyboardType = .decimalPad
            }
            alertController.addTextField { textField in
                textField.placeholder = "頭圍（cm）"
                textField.keyboardType = .decimalPad
            }
        case 4: // 里程碑
            alertController.addTextField { textField in
                textField.placeholder = "里程碑名稱"
            }
            alertController.addTextField { textField in
                textField.placeholder = "描述"
            }
        case 5: // 自訂
            alertController.addTextField { textField in
                textField.placeholder = "活動名稱"
            }
            alertController.addTextField { textField in
                textField.placeholder = "描述"
            }
        default:
            break
        }
        
        // 添加按钮
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        let saveAction = UIAlertAction(title: "保存", style: .default) { [weak self] _ in
            // 在这里处理保存逻辑
            // 示例：如果是餵奶记录，可以添加到feedingRecords数组中
            if selectedType == 0, let self = self,
               let type = alertController.textFields?[0].text,
               let durationText = alertController.textFields?[1].text {
                
                let now = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let timeString = formatter.string(from: now)
                
                let newRecord: (time: String, title: String, subtitle: String, icon: String)
                
                if type.contains("母乳") {
                    newRecord = (timeString, "母乳餵食", "左側 · \(durationText)分鐘", "drop.fill")
                } else {
                    newRecord = (timeString, "奶瓶餵食", "配方奶 · \(durationText)ml", "drop.fill")
                }
                
                self.feedingRecords.insert(newRecord, at: 0)
                self.tableView.reloadData()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true)
    }
    
    @objc private func calendarButtonTapped() {
        // 处理日历按钮点击，可以跳转到日历视图
        print("日历按钮点击")
    }
}

// MARK: - UITableViewDataSource
extension RecordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 根据当前选中的分段控制器索引返回对应类型的记录数量
        switch segmentedControl.selectedSegmentIndex {
        case 0: // 餵奶
            return feedingRecords.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordCell
        
        // 根据当前选中的分段控制器索引配置对应类型的记录单元格
        switch segmentedControl.selectedSegmentIndex {
        case 0: // 餵奶
            let record = feedingRecords[indexPath.row]
            cell.configure(time: record.time, title: record.title, subtitle: record.subtitle, iconName: record.icon)
        default:
            break
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RecordsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 处理单元格点击，可以跳转到记录详情页面
        print("点击了记录: \(indexPath.row)")
    }
}

// MARK: - RecordCell
class RecordCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.cardBackgroundColor
        view.layer.cornerRadius = Constants.CornerRadius.medium
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.title, weight: .bold)
        label.textColor = Constants.Colors.primaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.Colors.primaryColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body, weight: .medium)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.caption)
        label.textColor = Constants.Colors.secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(timeLabel)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Spacing.small),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Spacing.small),
            
            timeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.medium),
            timeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            iconImageView.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: Constants.Spacing.large),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Constants.Spacing.medium),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.Spacing.large),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.medium),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Spacing.small),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.medium),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -Constants.Spacing.large)
        ])
    }
    
    func configure(time: String, title: String, subtitle: String, iconName: String) {
        timeLabel.text = time
        titleLabel.text = title
        subtitleLabel.text = subtitle
        iconImageView.image = UIImage(systemName: iconName)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        iconImageView.image = nil
    }
} 