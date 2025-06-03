import UIKit

class SplashViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // 使用系统自带的婴儿图标，实际项目中需要替换为应用LOGO
        imageView.image = UIImage(systemName: "figure.and.child")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Constants.Colors.primaryColor
        return imageView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "智能寶寶生活記錄"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.largeTitle, weight: .bold)
        label.textColor = Constants.Colors.primaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = Constants.Colors.primaryColor
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // 模拟加载过程，3秒后跳转到登录页面
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigateToLoginScreen()
        }
    }
    
    private func setupUI() {
        // 设置渐变背景
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            Constants.Colors.primaryLightColor.cgColor,
            Constants.Colors.backgroundColor.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(logoImageView)
        view.addSubview(appNameLabel)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
            
            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: Constants.Spacing.medium),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Spacing.large),
            appNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Spacing.large),
            
            activityIndicator.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: Constants.Spacing.large),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    private func navigateToLoginScreen() {
        let loginVC = LoginViewController()
        navigationController?.setViewControllers([loginVC], animated: true)
    }
} 