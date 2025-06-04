import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("SceneDelegate: scene willConnectTo called")
        guard let windowScene = (scene as? UIWindowScene) else { 
            print("SceneDelegate: ERROR - Could not cast scene to UIWindowScene")
            return 
        }
        
        print("SceneDelegate: Creating window and root view controller")
        let window = UIWindow(windowScene: windowScene)
        let rootViewController = SplashViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window.rootViewController = navigationController
        self.window = window
        print("SceneDelegate: Making window key and visible")
        window.makeKeyAndVisible()
        print("SceneDelegate: Window setup completed")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // 场景断开连接时调用
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // 场景变为活跃状态时调用
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // 场景即将变为非活跃状态时调用
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // 场景即将进入前台时调用
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // 场景进入后台时调用
    }
} 