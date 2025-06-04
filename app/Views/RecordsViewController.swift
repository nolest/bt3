import UIKit

class RecordsViewController: UIViewController {
    
    private let dataManager = DataManager.shared
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "記錄列表"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recordCountLabel: UILabel = {
        let label = UILabel()
        label.text = "載入中..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.secondaryLabel
        label.textAlignment = .center
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
        title = "記錄"
        
        view.addSubview(titleLabel)
        view.addSubview(recordCountLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            recordCountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            recordCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recordCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func loadData() {
        let recentRecords = dataManager.getRecentRecords(limit: 100)
        recordCountLabel.text = "總共有 \(recentRecords.count) 條記錄"
    }
} 