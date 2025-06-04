import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("AppDelegate: didFinishLaunchingWithOptions called")
        
        // 创建window（使用稍高的window level以确保正确显示）
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.systemBackground
        window?.windowLevel = UIWindow.Level.normal + 1
        
        // 暂时跳过示例数据生成，直接测试视图控制器
        // SampleDataGenerator.shared.generateSampleDataIfNeeded()
        print("AppDelegate: Skipping sample data generation for testing")
        
        // 创建一个内联的测试视图控制器
        print("AppDelegate: Creating inline test view controller")
        let testViewController = InlineTestViewController()
        let navigationController = UINavigationController(rootViewController: testViewController)
        window?.rootViewController = navigationController
        print("AppDelegate: Root view controller set to navigation controller")
        
        // 显示window
        window?.makeKeyAndVisible()
        print("AppDelegate: Window made key and visible")
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("AppDelegate: applicationDidBecomeActive called")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("AppDelegate: applicationWillResignActive called")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("AppDelegate: applicationDidEnterBackground called")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("AppDelegate: applicationWillEnterForeground called")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("AppDelegate: applicationWillTerminate called")
    }
}

// 内联测试视图控制器
class InlineTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("InlineTestViewController: viewDidLoad called")
        
        view.backgroundColor = UIColor.systemBlue
        title = "測試成功"
        
        let label = UILabel()
        label.text = "內聯視圖控制器測試成功！"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
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
        
        print("InlineTestViewController: UI setup completed")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("InlineTestViewController: viewDidAppear called")
    }
} 