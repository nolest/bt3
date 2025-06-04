import UIKit

class SettingsViewController: UIViewController {
    
    private let dataManager = DataManager.shared
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "設置"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let babyInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("設置寶寶資料", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let clearDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("清除所有數據", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemRed
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "版本 1.0.0"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        title = "設置"
        
        view.addSubview(titleLabel)
        view.addSubview(babyInfoButton)
        view.addSubview(clearDataButton)
        view.addSubview(versionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            babyInfoButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            babyInfoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            babyInfoButton.widthAnchor.constraint(equalToConstant: 200),
            babyInfoButton.heightAnchor.constraint(equalToConstant: 50),
            
            clearDataButton.topAnchor.constraint(equalTo: babyInfoButton.bottomAnchor, constant: 20),
            clearDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearDataButton.widthAnchor.constraint(equalToConstant: 200),
            clearDataButton.heightAnchor.constraint(equalToConstant: 50),
            
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        babyInfoButton.addTarget(self, action: #selector(babyInfoTapped), for: .touchUpInside)
        clearDataButton.addTarget(self, action: #selector(clearDataTapped), for: .touchUpInside)
    }
    
    @objc private func babyInfoTapped() {
        let alert = UIAlertController(title: "設置寶寶資料", message: "請輸入寶寶信息", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "寶寶姓名"
            textField.text = self.dataManager.babyProfile?.name
        }
        
        alert.addAction(UIAlertAction(title: "保存", style: .default) { _ in
            if let nameField = alert.textFields?.first,
               let name = nameField.text, !name.isEmpty {
                
                let birthDate = Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date()
                let profile = BabyProfile(name: name, birthDate: birthDate, gender: .female)
                self.dataManager.babyProfile = profile
                
                let successAlert = UIAlertController(title: "成功", message: "寶寶資料已保存", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "確定", style: .default))
                self.present(successAlert, animated: true)
            }
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func clearDataTapped() {
        let alert = UIAlertController(title: "確認清除", message: "這將刪除所有記錄和寶寶資料，此操作無法撤銷", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "確認清除", style: .destructive) { _ in
            // 清除所有數據
            UserDefaults.standard.removeObject(forKey: "feedingRecords")
            UserDefaults.standard.removeObject(forKey: "diaperRecords")
            UserDefaults.standard.removeObject(forKey: "sleepRecords")
            UserDefaults.standard.removeObject(forKey: "growthRecords")
            UserDefaults.standard.removeObject(forKey: "milestoneRecords")
            UserDefaults.standard.removeObject(forKey: "medicationRecords")
            UserDefaults.standard.removeObject(forKey: "babyProfile")
            
            let successAlert = UIAlertController(title: "成功", message: "所有數據已清除", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "確定", style: .default))
            self.present(successAlert, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }
} 