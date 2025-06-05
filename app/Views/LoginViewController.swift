import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        // 使用系统图标作为临时logo
        imageView.image = UIImage(systemName: "heart.circle.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "智能寶寶生活記錄"
        label.font = .boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "記錄寶寶每個珍貴時刻\n用AI智慧分析成長軌跡"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let featuresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let signInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "我們重視您的隱私\n使用Apple登入安全便捷"
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .tertiaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 添加滚动视图
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 添加所有UI元素到contentView
        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(featuresStackView)
        contentView.addSubview(signInButton)
        contentView.addSubview(privacyLabel)
        
        // 创建功能特色列表
        createFeatureItems()
    }
    
    private func createFeatureItems() {
        let features = [
            ("camera.fill", "智慧影像分析", "AI識別寶寶情緒與發展狀況"),
            ("chart.line.uptrend.xyaxis", "成長追蹤", "記錄身高體重等重要指標"),
            ("heart.text.square.fill", "健康提醒", "疫苗接種與健康檢查提醒"),
            ("photo.on.rectangle.angled", "珍貴回憶", "自動整理寶寶照片與視頻")
        ]
        
        for (iconName, title, description) in features {
            let featureView = createFeatureView(icon: iconName, title: title, description: description)
            featuresStackView.addArrangedSubview(featureView)
        }
    }
    
    private func createFeatureView(icon: String, title: String, description: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView(image: UIImage(systemName: icon))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemBlue
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Logo constraints
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title constraints
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Subtitle constraints
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Features constraints
            featuresStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            featuresStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            featuresStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Sign in button constraints
            signInButton.topAnchor.constraint(equalTo: featuresStackView.bottomAnchor, constant: 40),
            signInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            signInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Privacy label constraints
            privacyLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 16),
            privacyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            privacyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            privacyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupActions() {
        signInButton.addTarget(self, action: #selector(handleSignInWithApple), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func handleSignInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // 获取用户信息
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("✅ Apple登录成功")
            print("User ID: \(userIdentifier)")
            print("Full Name: \(fullName?.formatted() ?? "N/A")")
            print("Email: \(email ?? "N/A")")
            
            // 保存用户信息
            UserDefaults.standard.set(userIdentifier, forKey: "appleUserID")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            // 切换到主界面
            DispatchQueue.main.async {
                self.navigateToMainApp()
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Apple登录失败: \(error.localizedDescription)")
        
        // 显示错误提示
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "登录失败", message: "请重试或检查网络连接", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    private func navigateToMainApp() {
        print("🏠 切换到主界面")
        
        // 创建主界面（临时使用简单界面）
        let mainVC = UIViewController()
        mainVC.view.backgroundColor = .systemGreen
        
        let welcomeLabel = UILabel()
        welcomeLabel.text = "🎉 登录成功！\n欢迎使用智能寶寶生活記錄"
        welcomeLabel.textColor = .white
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 0
        welcomeLabel.font = .boldSystemFont(ofSize: 24)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mainVC.view.addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: mainVC.view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: mainVC.view.centerYAnchor)
        ])
        
        // 切换根视图控制器
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = mainVC
            window.makeKeyAndVisible()
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
} 