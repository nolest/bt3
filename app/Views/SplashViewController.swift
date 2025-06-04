import UIKit

class SplashViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // 使用系统自带的婴儿图标
        imageView.image = UIImage(systemName: "figure.and.child")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.systemBlue
        return imageView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "智能寶寶生活記錄"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor.systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor.systemBlue
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // 模拟加载过程，3秒后跳转到主界面
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigateToMainScreen()
        }
    }
    
    private func setupUI() {
        // 设置白色背景
        view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(logoImageView)
        view.addSubview(appNameLabel)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
            
            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            appNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            activityIndicator.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 24),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    private func navigateToMainScreen() {
        // 直接跳转到主界面，跳过登录
        let mainTabBarController = MainTabBarController()
        
        // 使用window来设置根视图控制器
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = mainTabBarController
            
            // 添加过渡动画
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
} 