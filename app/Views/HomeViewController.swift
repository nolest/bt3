import UIKit

class HomeViewController: UIViewController {
    
    private let dataManager = DataManager.shared
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = Constants.Colors.backgroundColor
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Constants.Colors.primaryTextColor
        label.text = "今日概覽"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let babyInfoCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let babyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let babyAgeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Constants.Colors.secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let quickActionsLabel: UILabel = {
        let label = UILabel()
        label.text = "快速記錄"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quickActionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let recentRecordsLabel: UILabel = {
        let label = UILabel()
        label.text = "最近記錄"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recentRecordsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.systemBackground
        tableView.layer.cornerRadius = 12
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var recentRecords: [any BabyRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupNotifications()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.Colors.backgroundColor
        title = "今日"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(babyInfoCard)
        contentView.addSubview(statsStackView)
        contentView.addSubview(quickActionsLabel)
        contentView.addSubview(quickActionsStackView)
        contentView.addSubview(recentRecordsLabel)
        contentView.addSubview(recentRecordsTableView)
        
        setupBabyInfoCard()
        setupStatsCards()
        setupQuickActions()
        setupConstraints()
    }
    
    private func setupBabyInfoCard() {
        babyInfoCard.addSubview(babyNameLabel)
        babyInfoCard.addSubview(babyAgeLabel)
        
        NSLayoutConstraint.activate([
            babyNameLabel.topAnchor.constraint(equalTo: babyInfoCard.topAnchor, constant: 16),
            babyNameLabel.leadingAnchor.constraint(equalTo: babyInfoCard.leadingAnchor, constant: 16),
            babyNameLabel.trailingAnchor.constraint(equalTo: babyInfoCard.trailingAnchor, constant: -16),
            
            babyAgeLabel.topAnchor.constraint(equalTo: babyNameLabel.bottomAnchor, constant: 4),
            babyAgeLabel.leadingAnchor.constraint(equalTo: babyInfoCard.leadingAnchor, constant: 16),
            babyAgeLabel.trailingAnchor.constraint(equalTo: babyInfoCard.trailingAnchor, constant: -16),
            babyAgeLabel.bottomAnchor.constraint(equalTo: babyInfoCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupStatsCards() {
        let feedingCard = createStatCard(title: "餵奶", value: "0次", subtitle: "今日", icon: "drop.fill")
        let diaperCard = createStatCard(title: "換尿布", value: "0次", subtitle: "今日", icon: "tshirt.fill")
        let sleepCard = createStatCard(title: "睡眠", value: "0小時", subtitle: "今日", icon: "moon.fill")
        
        statsStackView.addArrangedSubview(feedingCard)
        statsStackView.addArrangedSubview(diaperCard)
        statsStackView.addArrangedSubview(sleepCard)
    }
    
    private func setupQuickActions() {
        let feedingButton = createQuickActionButton(title: "餵奶", icon: "drop.fill", action: #selector(quickFeedingTapped))
        let diaperButton = createQuickActionButton(title: "換尿布", icon: "tshirt.fill", action: #selector(quickDiaperTapped))
        let sleepButton = createQuickActionButton(title: "睡眠", icon: "moon.fill", action: #selector(quickSleepTapped))
        let growthButton = createQuickActionButton(title: "成長", icon: "ruler.fill", action: #selector(quickGrowthTapped))
        
        quickActionsStackView.addArrangedSubview(feedingButton)
        quickActionsStackView.addArrangedSubview(diaperButton)
        quickActionsStackView.addArrangedSubview(sleepButton)
        quickActionsStackView.addArrangedSubview(growthButton)
    }
    
    private func setupTableView() {
        recentRecordsTableView.delegate = self
        recentRecordsTableView.dataSource = self
        recentRecordsTableView.register(RecordTableViewCell.self, forCellReuseIdentifier: "RecordCell")
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(recordsDidUpdate),
            name: DataManager.recordsDidUpdateNotification,
            object: nil
        )
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            babyInfoCard.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
            babyInfoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            babyInfoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            statsStackView.topAnchor.constraint(equalTo: babyInfoCard.bottomAnchor, constant: 20),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statsStackView.heightAnchor.constraint(equalToConstant: 100),
            
            quickActionsLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 24),
            quickActionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            quickActionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            quickActionsStackView.topAnchor.constraint(equalTo: quickActionsLabel.bottomAnchor, constant: 12),
            quickActionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            quickActionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            quickActionsStackView.heightAnchor.constraint(equalToConstant: 80),
            
            recentRecordsLabel.topAnchor.constraint(equalTo: quickActionsStackView.bottomAnchor, constant: 24),
            recentRecordsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recentRecordsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            recentRecordsTableView.topAnchor.constraint(equalTo: recentRecordsLabel.bottomAnchor, constant: 12),
            recentRecordsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recentRecordsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            recentRecordsTableView.heightAnchor.constraint(equalToConstant: 300),
            recentRecordsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func createStatCard(title: String, value: String, subtitle: String, icon: String) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.systemBackground
        card.layer.cornerRadius = 12
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 4
        card.layer.shadowOpacity = 0.1
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = Constants.Colors.primaryColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = Constants.Colors.secondaryTextColor
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.boldSystemFont(ofSize: 18)
        valueLabel.textColor = Constants.Colors.primaryTextColor
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 10)
        subtitleLabel.textColor = Constants.Colors.secondaryTextColor
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(iconImageView)
        card.addSubview(titleLabel)
        card.addSubview(valueLabel)
        card.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
            iconImageView.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -4),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            valueLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 4),
            valueLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -4),
            
            subtitleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -4),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -8)
        ])
        
        // 存储标签以便后续更新
        card.tag = title.hashValue
        valueLabel.tag = 100 // 用于识别value标签
        
        return card
    }
    
    private func createQuickActionButton(title: String, icon: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = Constants.Colors.primaryColor
        button.layer.cornerRadius = 12
        button.tintColor = .white
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(iconImageView)
        button.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 12),
            iconImageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -8)
        ])
        
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return button
    }
    
    private func loadData() {
        updateBabyInfo()
        updateStats()
        updateRecentRecords()
    }
    
    private func updateBabyInfo() {
        if let baby = dataManager.babyProfile {
            babyNameLabel.text = baby.name
            babyAgeLabel.text = baby.ageDescription
        } else {
            babyNameLabel.text = "請設置寶寶資料"
            babyAgeLabel.text = "點擊設置頁面添加寶寶信息"
        }
    }
    
    private func updateStats() {
        let stats = dataManager.getTodayStats()
        
        // 更新统计卡片
        updateStatCard(title: "餵奶", value: "\(stats.feedingCount)次")
        updateStatCard(title: "換尿布", value: "\(stats.diaperCount)次")
        updateStatCard(title: "睡眠", value: stats.sleepDurationFormatted)
    }
    
    private func updateStatCard(title: String, value: String) {
        let tag = title.hashValue
        if let card = statsStackView.viewWithTag(tag),
           let valueLabel = card.viewWithTag(100) as? UILabel {
            valueLabel.text = value
        }
    }
    
    private func updateRecentRecords() {
        recentRecords = dataManager.getRecentRecords(limit: 5)
        recentRecordsTableView.reloadData()
        
        // 更新表格高度
        let height = min(CGFloat(recentRecords.count * 60), 300)
        recentRecordsTableView.constraints.first { $0.firstAttribute == .height }?.constant = height
    }
    
    @objc private func recordsDidUpdate() {
        DispatchQueue.main.async {
            self.loadData()
        }
    }
    
    // MARK: - Quick Actions
    @objc private func quickFeedingTapped() {
        showFeedingRecordDialog()
    }
    
    @objc private func quickDiaperTapped() {
        showDiaperRecordDialog()
    }
    
    @objc private func quickSleepTapped() {
        showSleepRecordDialog()
    }
    
    @objc private func quickGrowthTapped() {
        showGrowthRecordDialog()
    }
    
    private func showFeedingRecordDialog() {
        let alertController = UIAlertController(title: "餵奶記錄", message: "選擇餵奶類型", preferredStyle: .actionSheet)
        
        for feedingType in FeedingRecord.FeedingType.allCases {
            alertController.addAction(UIAlertAction(title: feedingType.displayName, style: .default) { _ in
                let record = FeedingRecord(feedingType: feedingType)
                self.dataManager.addRecord(record)
                self.showSuccessMessage("餵奶記錄已添加")
            })
        }
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func showDiaperRecordDialog() {
        let alertController = UIAlertController(title: "換尿布記錄", message: "選擇尿布類型", preferredStyle: .actionSheet)
        
        for diaperType in DiaperRecord.DiaperType.allCases {
            alertController.addAction(UIAlertAction(title: diaperType.displayName, style: .default) { _ in
                let record = DiaperRecord(diaperType: diaperType, wetness: .medium, hasBowelMovement: diaperType == .dirty || diaperType == .both)
                self.dataManager.addRecord(record)
                self.showSuccessMessage("換尿布記錄已添加")
            })
        }
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func showSleepRecordDialog() {
        let alertController = UIAlertController(title: "睡眠記錄", message: "寶寶開始睡覺了嗎？", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "開始睡眠", style: .default) { _ in
            let record = SleepRecord(startTime: Date(), quality: .good, location: .crib)
            self.dataManager.addRecord(record)
            self.showSuccessMessage("睡眠記錄已添加")
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func showGrowthRecordDialog() {
        let alertController = UIAlertController(title: "成長記錄", message: "添加體重記錄", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "體重（公斤）"
            textField.keyboardType = .decimalPad
        }
        
        alertController.addAction(UIAlertAction(title: "添加", style: .default) { _ in
            if let textField = alertController.textFields?.first,
               let weightText = textField.text,
               let weight = Double(weightText) {
                let record = GrowthRecord(weight: weight)
                self.dataManager.addRecord(record)
                self.showSuccessMessage("成長記錄已添加")
            }
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func showSuccessMessage(_ message: String) {
        let alertController = UIAlertController(title: "成功", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        present(alertController, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordTableViewCell
        let record = recentRecords[indexPath.row]
        cell.configure(with: record)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - RecordTableViewCell
class RecordTableViewCell: UITableViewCell {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.Colors.primaryColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Constants.Colors.secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Constants.Colors.secondaryTextColor
        label.textAlignment = .right
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
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -8),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            subtitleLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -8),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func configure(with record: any BabyRecord) {
        iconImageView.image = UIImage(systemName: record.type.iconName)
        titleLabel.text = record.type.displayName
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timeLabel.text = formatter.string(from: record.timestamp)
        
        // 根据记录类型设置副标题
        switch record {
        case let feeding as FeedingRecord:
            subtitleLabel.text = feeding.feedingType.displayName
        case let diaper as DiaperRecord:
            subtitleLabel.text = diaper.diaperType.displayName
        case let sleep as SleepRecord:
            if let duration = sleep.duration {
                let hours = Int(duration) / 3600
                let minutes = Int(duration) % 3600 / 60
                subtitleLabel.text = "\(hours)小時\(minutes)分鐘"
            } else {
                subtitleLabel.text = "進行中"
            }
        case let growth as GrowthRecord:
            if let weight = growth.weight {
                subtitleLabel.text = "\(weight)公斤"
            } else {
                subtitleLabel.text = "成長記錄"
            }
        case let milestone as MilestoneRecord:
            subtitleLabel.text = milestone.description
        case let medication as MedicationRecord:
            subtitleLabel.text = medication.medicationName
        default:
            subtitleLabel.text = ""
        }
    }
} 