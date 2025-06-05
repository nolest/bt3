import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("=== AppDelegate开始执行 ===")
        
        // 强制创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.systemRed
        
        print("Window创建完成，frame: \(UIScreen.main.bounds)")
        print("Window背景色: \(String(describing: window?.backgroundColor))")
        
        let testVC = TestViewController()
        window?.rootViewController = testVC
        
        // 强制显示window
        window?.makeKeyAndVisible()
        
        print("Window makeKeyAndVisible完成")
        print("Window isKeyWindow: \(window?.isKeyWindow ?? false)")
        print("Window isHidden: \(window?.isHidden ?? true)")
        
        // 延迟0.1秒强制刷新
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            print("=== 延迟刷新开始 ===")
            self.window?.setNeedsDisplay()
            self.window?.layoutIfNeeded()
            testVC.view.setNeedsDisplay()
            testVC.view.layoutIfNeeded()
            print("强制刷新完成")
        }
        
        print("=== AppDelegate执行完成 ===")
        
        return true
    }
}

class TestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("=== TestViewController viewDidLoad ===")
        
        // 设置明显的蓝色背景
        view.backgroundColor = UIColor.systemBlue
        print("背景色设置为蓝色: \(String(describing: view.backgroundColor))")
        
        // 使用简单的frame布局
        let screenBounds = UIScreen.main.bounds
        let labelFrame = CGRect(
            x: 20, 
            y: screenBounds.height/2 - 100, 
            width: screenBounds.width - 40, 
            height: 200
        )
        
        let label = UILabel(frame: labelFrame)
        label.text = "🎉 测试成功！\n蓝色背景 + 白色文字\n如果看到这个说明一切正常"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)  // 半透明黑色背景
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        view.addSubview(label)
        
        print("Label添加完成，frame: \(labelFrame)")
        print("Label父视图: \(String(describing: label.superview))")
        print("View子视图数量: \(view.subviews.count)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("=== TestViewController viewDidAppear ===")
        print("View bounds: \(view.bounds)")
        print("View frame: \(view.frame)")
        print("View背景色: \(String(describing: view.backgroundColor))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("=== TestViewController viewWillAppear ===")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("=== TestViewController viewDidLayoutSubviews ===")
        print("View bounds after layout: \(view.bounds)")
    }
} 