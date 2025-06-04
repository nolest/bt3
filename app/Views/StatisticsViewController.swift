import UIKit

class StatisticsViewController: UIViewController {
    
    private let dataManager = DataManager.shared
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "統計分析"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsLabel: UILabel = {
        let label = UILabel()
        label.text = "載入中..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        title = "統計"
        
        view.addSubview(titleLabel)
        view.addSubview(statsLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            statsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            statsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func loadData() {
        let today = Date()
        let dailyStats = dataManager.getDailyStats(for: today)
        
        let sleepHours = Int(dailyStats.sleepDuration) / 3600
        let sleepMinutes = Int(dailyStats.sleepDuration) % 3600 / 60
        
        statsLabel.text = """
        今日統計：
        
        餵奶次數：\(dailyStats.feedingCount)次
        換尿布次數：\(dailyStats.diaperCount)次
        睡眠時間：\(sleepHours)小時\(sleepMinutes)分鐘
        
        本週統計：
        總記錄數：\(dataManager.getRecentRecords(limit: 1000).count)條
        """
    }
}