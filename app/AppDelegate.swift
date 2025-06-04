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
        
        // 生成示例数据（如果需要）
        SampleDataGenerator.shared.generateSampleDataIfNeeded()
        
        // 创建启动视图控制器
        let splashViewController = SplashViewController()
        let navigationController = UINavigationController(rootViewController: splashViewController)
        window?.rootViewController = navigationController
        
        // 显示window
        window?.makeKeyAndVisible()
        
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