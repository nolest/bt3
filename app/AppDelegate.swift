import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("AppDelegate: didFinishLaunchingWithOptions called")
        
        // 检查iOS版本
        if #available(iOS 13.0, *) {
            print("AppDelegate: Using modern Scene system for iOS 13+")
            // iOS 13+ 使用 Scene delegate
            return true
        } else {
            print("AppDelegate: Using legacy AppDelegate system for iOS 12-")
            // iOS 12 及以下使用传统 AppDelegate
            setupLegacyWindow()
            return true
        }
    }
    
    private func setupLegacyWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // 创建简单的测试视图控制器
        let testViewController = LegacyTestViewController()
        window?.rootViewController = testViewController
        window?.makeKeyAndVisible()
        
        print("AppDelegate: Legacy window setup completed")
    }

    // MARK: UISceneSession Lifecycle (iOS 13+)
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("AppDelegate: configurationForConnecting called")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("AppDelegate: didDiscardSceneSessions called")
    }
}

// 传统测试视图控制器
class LegacyTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LegacyTestViewController: viewDidLoad called")
        
        view.backgroundColor = UIColor.systemBlue
        
        let label = UILabel()
        label.text = "传统AppDelegate测试\n如果您看到这个蓝色页面\n说明传统系统工作正常"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
        
        print("LegacyTestViewController: UI setup completed")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("LegacyTestViewController: viewDidAppear called")
    }
} 