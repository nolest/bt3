import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("AppDelegate: didFinishLaunchingWithOptions called")
        
        // 生成示例数据（如果需要） - 暂时禁用以测试
        // print("AppDelegate: About to generate sample data")
        // SampleDataGenerator.shared.generateSampleDataIfNeeded()
        // print("AppDelegate: Sample data generation completed")
        
        // 强制使用传统方式创建window（绕过Scene系统）
        print("AppDelegate: Setting up traditional window (forced)")
        setupTraditionalWindow()
        
        return true
    }
    
    private func setupTraditionalWindow() {
        print("AppDelegate: Setting up traditional window")
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // 创建一个极其简单的测试视图控制器
        let testViewController = TestViewController()
        let navigationController = UINavigationController(rootViewController: testViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        print("AppDelegate: Traditional window setup completed")
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        print("AppDelegate: configurationForConnecting called")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        print("AppDelegate: didDiscardSceneSessions called")
    }
}

// 在AppDelegate文件中定义一个简单的测试视图控制器
class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TestViewController: viewDidLoad called")
        
        view.backgroundColor = UIColor.red  // 使用红色背景便于识别
        
        let label = UILabel()
        label.text = "测试成功！"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        print("TestViewController: Setup completed")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("TestViewController: viewDidAppear called")
    }
} 