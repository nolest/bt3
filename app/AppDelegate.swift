import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("🚀 智能寶寶生活記錄启动")
        
        // 创建主窗口
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // 检查登录状态
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if isLoggedIn {
            print("✅ 用户已登录，跳转到主界面")
            // 创建主界面（临时）
            let mainVC = UIViewController()
            mainVC.view.backgroundColor = .systemGreen
            
            let welcomeLabel = UILabel()
            welcomeLabel.text = "🎉 欢迎回来！\n智能寶寶生活記錄"
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
            
            window?.rootViewController = mainVC
        } else {
            print("📝 用户未登录，显示登录界面")
            // 创建登录界面
            let loginVC = LoginViewController()
            window?.rootViewController = loginVC
        }
        
        window?.makeKeyAndVisible()
        
        print("✅ 应用初始化完成")
        
        return true
    }
} 