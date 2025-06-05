import UIKit

// 最小化测试版本 - 替换现有的AppDelegate内容
@main
class MinimalApp: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = UIViewController()
        vc.view.backgroundColor = .systemRed
        
        let label = UILabel()
        label.text = "最小测试\n如果看到这个红色页面\n说明基本设置正确"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.frame = CGRect(x: 50, y: 200, width: 250, height: 200)
        vc.view.addSubview(label)
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
} 