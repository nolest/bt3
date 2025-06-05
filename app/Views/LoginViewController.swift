import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        // 使用系统图标替代，实际项目中需要替换为真实的父母与孩子的图片
        imageView.image = UIImage(systemName: "figure.and.child")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Constants.Colors.primaryColor
        imageView.backgroundColor = Constants.Colors.primaryLightColor.withAlphaComponent(0.2)
        return imageView
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "歡迎使用\n智能寶寶生活記錄"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.largeTitle, weight: .bold)
        label.textColor = Constants.Colors.primaryTextColor
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "全方位的育兒助手，讓照顧寶寶變得輕鬆簡單\n\n使用Apple ID安全快速登入"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body)
        label.textColor = Constants.Colors.secondaryTextColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let appleSignInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.cornerRadius = Constants.CornerRadius.medium
        return button
    }()
    
    private let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "使用Apple登入，您的隐私受到最高级别保护\n我們不會收集或分享您的個人信息"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.caption)
        label.textColor = Constants.Colors.secondaryTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkExistingAppleIDCredential()
    }
    
    private func setupUI() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = Constants.Colors.backgroundColor
        
        // 添加滚动视图
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 添加内容
        contentView.addSubview(headerImageView)
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(appleSignInButton)
        contentView.addSubview(privacyLabel)
        contentView.addSubview(activityIndicator)
        
        // 设置约束
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
            
            // 头部图像约束
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Spacing.extraLarge),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            // 欢迎标签约束
            welcomeLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: Constants.Spacing.extraLarge),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // 描述标签约束
            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: Constants.Spacing.large),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // Apple登录按钮约束
            appleSignInButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.Spacing.extraExtraLarge),
            appleSignInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            appleSignInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 隐私标签约束
            privacyLabel.topAnchor.constraint(equalTo: appleSignInButton.bottomAnchor, constant: Constants.Spacing.large),
            privacyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            privacyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            privacyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Spacing.extraLarge),
            
            // 活动指示器约束
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        appleSignInButton.addTarget(self, action: #selector(appleSignInButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Apple Sign In
    @objc private func appleSignInButtonTapped() {
        performAppleSignIn()
    }
    
    private func performAppleSignIn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        
        // 显示加载指示器
        showLoadingIndicator()
        
        controller.performRequests()
    }
    
    private func checkExistingAppleIDCredential() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        
        // 检查现有凭据，但不显示加载指示器
        // controller.performRequests()
    }
    
    private func showLoadingIndicator() {
        activityIndicator.startAnimating()
        appleSignInButton.isEnabled = false
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        appleSignInButton.isEnabled = true
    }
    
    private func handleSuccessfulSignIn(userID: String, email: String?, fullName: PersonNameComponents?) {
        // 存储用户信息
        UserDefaults.standard.set(userID, forKey: "appleUserID")
        UserDefaults.standard.set(email, forKey: "userEmail")
        
        if let fullName = fullName {
            let displayName = PersonNameComponentsFormatter().string(from: fullName)
            UserDefaults.standard.set(displayName, forKey: "userDisplayName")
        }
        
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        
        // 跳转到主页
        DispatchQueue.main.async {
            let homeVC = MainTabBarController()
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = homeVC
                window.makeKeyAndVisible()
            }
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "登入失敗", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        hideLoadingIndicator()
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userID = appleIDCredential.user
            let email = appleIDCredential.email
            let fullName = appleIDCredential.fullName
            
            print("Apple Sign In 成功")
            print("User ID: \(userID)")
            print("Email: \(email ?? "未提供")")
            print("Full Name: \(fullName?.debugDescription ?? "未提供")")
            
            handleSuccessfulSignIn(userID: userID, email: email, fullName: fullName)
            
        default:
            showError(message: "未知的認證類型")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        hideLoadingIndicator()
        
        guard let authError = error as? ASAuthorizationError else {
            showError(message: "認證過程中發生未知錯誤")
            return
        }
        
        switch authError.code {
        case .canceled:
            print("用戶取消了Apple Sign In")
        case .failed:
            showError(message: "認證失敗，請重試")
        case .invalidResponse:
            showError(message: "認證響應無效")
        case .notHandled:
            showError(message: "認證請求未被處理")
        case .unknown:
            showError(message: "發生未知錯誤")
        @unknown default:
            showError(message: "發生未知錯誤")
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
} 