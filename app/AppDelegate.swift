import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("AppDelegate: didFinishLaunchingWithOptions called")
        print("AppDelegate: Application state: \(application.applicationState.rawValue)")
        print("AppDelegate: Launch options: \(launchOptions ?? [:])")
        
        // 强制禁用Scene系统（如果存在）
        if #available(iOS 13.0, *) {
            print("AppDelegate: iOS 13+ detected, forcing traditional window mode")
        }
        
        // 创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        print("AppDelegate: Window created with frame: \(UIScreen.main.bounds)")
        
        // 创建一个简单的红色视图控制器
        let viewController = SimpleRedViewController()
        window?.rootViewController = viewController
        print("AppDelegate: Root view controller set")
        
        // 设置window背景色作为备用
        window?.backgroundColor = UIColor.blue
        print("AppDelegate: Window background color set")
        
        // 显示window
        window?.makeKeyAndVisible()
        print("AppDelegate: Window made key and visible")
        print("AppDelegate: Window isKeyWindow: \(window?.isKeyWindow ?? false)")
        print("AppDelegate: Window isHidden: \(window?.isHidden ?? true)")
        
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

// 极其简单的红色视图控制器
class SimpleRedViewController: UIViewController {
    
    override func loadView() {
        print("SimpleRedViewController: loadView called")
        super.loadView()
        print("SimpleRedViewController: loadView completed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SimpleRedViewController: viewDidLoad called")
        print("SimpleRedViewController: view bounds: \(view.bounds)")
        
        view.backgroundColor = UIColor.red
        print("SimpleRedViewController: Background color set to red")
        
        // 添加一个白色标签
        let label = UILabel()
        label.text = "成功！"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 200, width: view.bounds.width, height: 100)
        view.addSubview(label)
        print("SimpleRedViewController: Label added")
        
        print("SimpleRedViewController: Setup completed")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SimpleRedViewController: viewWillAppear called")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("SimpleRedViewController: viewDidAppear called")
        print("SimpleRedViewController: Final view bounds: \(view.bounds)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("SimpleRedViewController: viewWillLayoutSubviews called")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("SimpleRedViewController: viewDidLayoutSubviews called")
        print("SimpleRedViewController: Layout view bounds: \(view.bounds)")
    }
} 