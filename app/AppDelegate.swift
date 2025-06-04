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
        
        // 如果Scene系统失败，使用传统方式创建window
        if #available(iOS 13.0, *) {
            // iOS 13+ 使用Scene系统
            print("AppDelegate: Using Scene-based lifecycle")
        } else {
            // iOS 12及以下使用传统方式
            print("AppDelegate: Using traditional window setup")
            setupTraditionalWindow()
        }
        
        return true
    }
    
    private func setupTraditionalWindow() {
        print("AppDelegate: Setting up traditional window")
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = SplashViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
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