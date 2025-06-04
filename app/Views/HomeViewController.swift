import UIKit

class HomeViewController: UIViewController {
    
    private let dataManager = DataManager.shared
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.label
        label.text = "今日概覽"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let babyInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.secondaryLabel
        label.text = "載入中..."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.label
        label.text = "今日統計：\n餵奶：0次\n換尿布：0次\n睡眠：0小時"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addRecordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("添加記錄", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        title = "今日"
        
        view.addSubview(welcomeLabel)
        view.addSubview(babyInfoLabel)
        view.addSubview(statsLabel)
        view.addSubview(addRecordButton)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            babyInfoLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30),
            babyInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            babyInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            statsLabel.topAnchor.constraint(equalTo: babyInfoLabel.bottomAnchor, constant: 30),
            statsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addRecordButton.topAnchor.constraint(equalTo: statsLabel.bottomAnchor, constant: 40),
            addRecordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addRecordButton.widthAnchor.constraint(equalToConstant: 200),
            addRecordButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        addRecordButton.addTarget(self, action: #selector(addRecordTapped), for: .touchUpInside)
    }
    
    private func loadData() {
        // 加载宝宝信息
        if let babyProfile = dataManager.babyProfile {
            babyInfoLabel.text = "寶寶：\(babyProfile.name)\n年齡：\(babyProfile.ageDescription)"
        } else {
            babyInfoLabel.text = "尚未設置寶寶資料"
        }
        
        // 加载今日统计
        let today = Date()
        let dailyStats = dataManager.getDailyStats(for: today)
        
        let sleepHours = Int(dailyStats.sleepDuration) / 3600
        let sleepMinutes = Int(dailyStats.sleepDuration) % 3600 / 60
        
        statsLabel.text = """
        今日統計：
        餵奶：\(dailyStats.feedingCount)次
        換尿布：\(dailyStats.diaperCount)次
        睡眠：\(sleepHours)小時\(sleepMinutes)分鐘
        """
    }
    
    @objc private func addRecordTapped() {
        let alert = UIAlertController(title: "添加記錄", message: "選擇要添加的記錄類型", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "餵奶記錄", style: .default) { _ in
            self.addFeedingRecord()
        })
        
        alert.addAction(UIAlertAction(title: "換尿布記錄", style: .default) { _ in
            self.addDiaperRecord()
        })
        
        alert.addAction(UIAlertAction(title: "睡眠記錄", style: .default) { _ in
            self.addSleepRecord()
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func addFeedingRecord() {
        let record = FeedingRecord(feedingType: .breast, duration: 600, side: .left, notes: "快速記錄")
        dataManager.addRecord(record)
        loadData()
        
        let alert = UIAlertController(title: "成功", message: "餵奶記錄已添加", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
    }
    
    private func addDiaperRecord() {
        let record = DiaperRecord(diaperType: .wet, wetness: .medium, hasBowelMovement: false, notes: "快速記錄")
        dataManager.addRecord(record)
        loadData()
        
        let alert = UIAlertController(title: "成功", message: "換尿布記錄已添加", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
    }
    
    private func addSleepRecord() {
        let startTime = Date().addingTimeInterval(-3600) // 1小时前开始
        let endTime = Date()
        let record = SleepRecord(startTime: startTime, endTime: endTime, quality: .good, location: .crib, notes: "快速記錄")
        dataManager.addRecord(record)
        loadData()
        
        let alert = UIAlertController(title: "成功", message: "睡眠記錄已添加", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
    }
} 