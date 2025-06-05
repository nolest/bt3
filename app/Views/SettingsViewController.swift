import UIKit

class SettingsViewController: UIViewController {
    
    private let dataManager = DataManager.shared
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "設置"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - 用户信息区域
    private let userInfoCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = UIColor.systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "載入中..."
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userEmailLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let appleSignInLabel: UILabel = {
        let label = UILabel()
        label.text = "已使用 Apple ID 登入"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.systemBlue
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
    
    private let signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("退出登入", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemOrange
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
        loadUserInfo()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        title = "設置"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 添加用户信息卡片
        contentView.addSubview(userInfoCardView)
        userInfoCardView.addSubview(userAvatarImageView)
        userInfoCardView.addSubview(userNameLabel)
        userInfoCardView.addSubview(userEmailLabel)
        userInfoCardView.addSubview(appleSignInLabel)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(babyInfoButton)
        contentView.addSubview(clearDataButton)
        contentView.addSubview(signOutButton)
        contentView.addSubview(versionLabel)
        
        NSLayoutConstraint.activate([
            // 滚动视图约束
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 内容视图约束
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 用户信息卡片约束
            userInfoCardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            userInfoCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            userInfoCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            userInfoCardView.heightAnchor.constraint(equalToConstant: 100),
            
            // 用户头像约束
            userAvatarImageView.leadingAnchor.constraint(equalTo: userInfoCardView.leadingAnchor, constant: 16),
            userAvatarImageView.centerYAnchor.constraint(equalTo: userInfoCardView.centerYAnchor),
            userAvatarImageView.widthAnchor.constraint(equalToConstant: 50),
            userAvatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // 用户姓名约束
            userNameLabel.topAnchor.constraint(equalTo: userInfoCardView.topAnchor, constant: 16),
            userNameLabel.leadingAnchor.constraint(equalTo: userAvatarImageView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: userInfoCardView.trailingAnchor, constant: -16),
            
            // 用户邮箱约束
            userEmailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
            userEmailLabel.leadingAnchor.constraint(equalTo: userAvatarImageView.trailingAnchor, constant: 16),
            userEmailLabel.trailingAnchor.constraint(equalTo: userInfoCardView.trailingAnchor, constant: -16),
            
            // Apple登录标签约束
            appleSignInLabel.topAnchor.constraint(equalTo: userEmailLabel.bottomAnchor, constant: 4),
            appleSignInLabel.leadingAnchor.constraint(equalTo: userAvatarImageView.trailingAnchor, constant: 16),
            appleSignInLabel.trailingAnchor.constraint(equalTo: userInfoCardView.trailingAnchor, constant: -16),
            
            babyInfoButton.topAnchor.constraint(equalTo: userInfoCardView.bottomAnchor, constant: 40),
            babyInfoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            babyInfoButton.widthAnchor.constraint(equalToConstant: 200),
            babyInfoButton.heightAnchor.constraint(equalToConstant: 50),
            
            clearDataButton.topAnchor.constraint(equalTo: babyInfoButton.bottomAnchor, constant: 20),
            clearDataButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            clearDataButton.widthAnchor.constraint(equalToConstant: 200),
            clearDataButton.heightAnchor.constraint(equalToConstant: 50),
            
            signOutButton.topAnchor.constraint(equalTo: clearDataButton.bottomAnchor, constant: 20),
            signOutButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signOutButton.widthAnchor.constraint(equalToConstant: 200),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            
            versionLabel.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 40),
            versionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        babyInfoButton.addTarget(self, action: #selector(babyInfoTapped), for: .touchUpInside)
        clearDataButton.addTarget(self, action: #selector(clearDataTapped), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
    }
    
    private func loadUserInfo() {
        // 从UserDefaults加载用户信息
        let displayName = UserDefaults.standard.string(forKey: "userDisplayName")
        let email = UserDefaults.standard.string(forKey: "userEmail")
        
        if let name = displayName, !name.isEmpty {
            userNameLabel.text = name
        } else {
            userNameLabel.text = "Apple用戶"
        }
        
        if let userEmail = email, !userEmail.isEmpty {
            userEmailLabel.text = userEmail
        } else {
            userEmailLabel.text = "使用隱私郵箱"
        }
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
            // 清除所有數據（但保留登录状态）
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
    
    @objc private func signOutTapped() {
        let alert = UIAlertController(title: "確認退出", message: "您確定要退出登入嗎？", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "退出登入", style: .destructive) { _ in
            self.performSignOut()
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }
    
    private func performSignOut() {
        // 清除登录状态和用户信息
        UserDefaults.standard.removeObject(forKey: "isUserLoggedIn")
        UserDefaults.standard.removeObject(forKey: "appleUserID")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userDisplayName")
        
        // 跳转到登录页面
        DispatchQueue.main.async {
            let loginViewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginViewController)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        }
    }
} 