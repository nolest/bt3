import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("SceneDelegate: scene willConnectTo called")
        
        guard let windowScene = (scene as? UIWindowScene) else { 
            print("SceneDelegate: ERROR - Could not cast scene to UIWindowScene")
            return 
        }
        
        print("SceneDelegate: Creating window with windowScene")
        window = UIWindow(windowScene: windowScene)
        
        // 检查用户登录状态
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if isUserLoggedIn {
            print("SceneDelegate: User is logged in, showing main interface")
            // 用户已登录，显示主界面
            let mainTabBarController = MainTabBarController()
            window?.rootViewController = mainTabBarController
        } else {
            print("SceneDelegate: User not logged in, showing login interface")
            // 用户未登录，显示登录界面
            let loginViewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginViewController)
            window?.rootViewController = navigationController
        }
        
        window?.makeKeyAndVisible()
        print("SceneDelegate: Window setup completed")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("SceneDelegate: sceneDidDisconnect called")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("SceneDelegate: sceneDidBecomeActive called")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("SceneDelegate: sceneWillResignActive called")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("SceneDelegate: sceneWillEnterForeground called")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("SceneDelegate: sceneDidEnterBackground called")
    }
}

// 现代测试视图控制器
class ModernTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ModernTestViewController: viewDidLoad called")
        
        view.backgroundColor = UIColor.systemGreen
        title = "現代Scene系統"
        
        let label = UILabel()
        label.text = "使用現代Scene系統成功！\niOS 13+ 專用"
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
        
        print("ModernTestViewController: UI setup completed")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ModernTestViewController: viewDidAppear called")
    }
} 