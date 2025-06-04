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
        
        // 方法1: 尝试视图控制器方式
        print("AppDelegate: Trying view controller approach...")
        let viewController = SimpleRedViewController()
        window?.rootViewController = viewController
        print("AppDelegate: Root view controller set")
        
        // 方法2: 同时直接添加一个测试视图到window（作为备用）
        print("AppDelegate: Adding backup test view...")
        let backupView = UIView(frame: UIScreen.main.bounds)
        backupView.backgroundColor = UIColor.green
        backupView.tag = 999 // 用于识别
        
        let backupLabel = UILabel(frame: CGRect(x: 50, y: 100, width: 300, height: 100))
        backupLabel.text = "备用视图显示"
        backupLabel.textColor = UIColor.white
        backupLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        backupLabel.numberOfLines = 0
        backupView.addSubview(backupLabel)
        
        window?.addSubview(backupView)
        print("AppDelegate: Backup green view added")
        
        // 设置window背景色作为最后的备用
        window?.backgroundColor = UIColor.blue
        print("AppDelegate: Window background color set to blue")
        
        // 显示window
        window?.makeKeyAndVisible()
        print("AppDelegate: Window made key and visible")
        print("AppDelegate: Window isKeyWindow: \(window?.isKeyWindow ?? false)")
        print("AppDelegate: Window isHidden: \(window?.isHidden ?? true)")
        
        // 强制确保window成为key window
        if window?.isKeyWindow == false {
            print("AppDelegate: Window is not key, forcing it to become key...")
            window?.makeKey()
            
            // 再次检查
            DispatchQueue.main.async {
                print("AppDelegate: After makeKey - isKeyWindow: \(self.window?.isKeyWindow ?? false)")
                
                // 检查是否有其他windows
                let allWindows = UIApplication.shared.windows
                print("AppDelegate: Total windows count: \(allWindows.count)")
                for (index, win) in allWindows.enumerated() {
                    print("AppDelegate: Window \(index): isKey=\(win.isKeyWindow), isHidden=\(win.isHidden), frame=\(win.frame)")
                }
                
                // 如果仍然不是key window，尝试其他方法
                if self.window?.isKeyWindow == false {
                    print("AppDelegate: Still not key window, trying alternative approach...")
                    
                    // 尝试重新创建window
                    let newWindow = UIWindow(frame: UIScreen.main.bounds)
                    newWindow.backgroundColor = UIColor.red
                    newWindow.rootViewController = SimpleRedViewController()
                    newWindow.windowLevel = UIWindow.Level.normal + 1 // 提高window层级
                    newWindow.makeKeyAndVisible()
                    self.window = newWindow
                    
                    print("AppDelegate: Created new window with higher level")
                    print("AppDelegate: New window isKeyWindow: \(newWindow.isKeyWindow)")
                }
            }
        }
        
        // 延迟检查window状态
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("AppDelegate: === 1秒后状态检查 ===")
            print("AppDelegate: Window frame: \(self.window?.frame ?? CGRect.zero)")
            print("AppDelegate: Window subviews count: \(self.window?.subviews.count ?? 0)")
            print("AppDelegate: Root view controller: \(self.window?.rootViewController != nil)")
            
            if let rootVC = self.window?.rootViewController {
                print("AppDelegate: Root VC view loaded: \(rootVC.isViewLoaded)")
                print("AppDelegate: Root VC view frame: \(rootVC.view?.frame ?? CGRect.zero)")
                print("AppDelegate: Root VC view superview: \(rootVC.view?.superview != nil)")
            }
            
            // 检查备用视图
            if let backupView = self.window?.viewWithTag(999) {
                print("AppDelegate: Backup view found with frame: \(backupView.frame)")
                print("AppDelegate: Backup view backgroundColor: \(backupView.backgroundColor ?? UIColor.clear)")
            } else {
                print("AppDelegate: Backup view NOT found!")
            }
        }
        
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