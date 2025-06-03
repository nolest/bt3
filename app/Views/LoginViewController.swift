import UIKit

class LoginViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "全方位的育兒助手，讓照顧寶寶變得輕鬆簡單"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body)
        label.textColor = Constants.Colors.secondaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "電子郵件"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = Constants.Colors.cardBackgroundColor
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "密碼"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = Constants.Colors.cardBackgroundColor
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登入", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Colors.primaryColor
        button.layer.cornerRadius = Constants.CornerRadius.medium
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.FontSize.body, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("新用戶註冊", for: .normal)
        button.setTitleColor(Constants.Colors.primaryColor, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.FontSize.body)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let socialLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "或使用社交賬號登入"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.caption)
        label.textColor = Constants.Colors.secondaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let socialButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.Spacing.medium
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let facebookButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "f.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(hex: "#3b5998")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "g.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(hex: "#db4437")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let appleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "apple.logo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupKeyboardHandling()
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
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(loginButton)
        contentView.addSubview(signupButton)
        contentView.addSubview(socialLoginLabel)
        contentView.addSubview(socialButtonsStackView)
        
        // 添加社交按钮
        socialButtonsStackView.addArrangedSubview(facebookButton)
        socialButtonsStackView.addArrangedSubview(googleButton)
        socialButtonsStackView.addArrangedSubview(appleButton)
        
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
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            // 欢迎标签约束
            welcomeLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: Constants.Spacing.large),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // 描述标签约束
            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: Constants.Spacing.small),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // 邮箱输入框约束
            emailTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.Spacing.extraLarge),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 密码输入框约束
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: Constants.Spacing.medium),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 登录按钮约束
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Constants.Spacing.large),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 注册按钮约束
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: Constants.Spacing.medium),
            signupButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // 社交登录标签约束
            socialLoginLabel.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: Constants.Spacing.large),
            socialLoginLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            socialLoginLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // 社交按钮栈视图约束
            socialButtonsStackView.topAnchor.constraint(equalTo: socialLoginLabel.bottomAnchor, constant: Constants.Spacing.medium),
            socialButtonsStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            socialButtonsStackView.widthAnchor.constraint(equalToConstant: 200),
            socialButtonsStackView.heightAnchor.constraint(equalToConstant: 50),
            socialButtonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Spacing.extraLarge)
        ])
        
        // 设置社交按钮的大小
        [facebookButton, googleButton, appleButton].forEach { button in
            button.imageView?.contentMode = .scaleAspectFit
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 44),
                button.widthAnchor.constraint(equalToConstant: 44)
            ])
        }
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        facebookButton.addTarget(self, action: #selector(facebookButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        appleButton.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
        
        // 添加点击手势，用于关闭键盘
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func loginButtonTapped() {
        // 简单验证
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // 显示错误提示
            let alert = UIAlertController(title: "輸入錯誤", message: "請輸入電子郵件和密碼", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default))
            present(alert, animated: true)
            return
        }
        
        // 模拟登录成功，跳转到主页
        let homeVC = MainTabBarController()
        navigationController?.setViewControllers([homeVC], animated: true)
    }
    
    @objc private func signupButtonTapped() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @objc private func facebookButtonTapped() {
        // 模拟Facebook登录
        print("Facebook登录按钮点击")
        let homeVC = MainTabBarController()
        navigationController?.setViewControllers([homeVC], animated: true)
    }
    
    @objc private func googleButtonTapped() {
        // 模拟Google登录
        print("Google登录按钮点击")
        let homeVC = MainTabBarController()
        navigationController?.setViewControllers([homeVC], animated: true)
    }
    
    @objc private func appleButtonTapped() {
        // 模拟Apple登录
        print("Apple登录按钮点击")
        let homeVC = MainTabBarController()
        navigationController?.setViewControllers([homeVC], animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
} 