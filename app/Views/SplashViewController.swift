import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SplashViewController: viewDidLoad called")
        
        // 设置简单的背景色
        view.backgroundColor = UIColor.white
        
        // 创建一个简单的标签
        let label = UILabel()
        label.text = "智能寶寶生活記錄"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        print("SplashViewController: UI setup completed")
        
        // 2秒后跳转
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("SplashViewController: About to navigate to main screen")
            self.navigateToMainScreen()
        }
    }
    
    private func navigateToMainScreen() {
        print("SplashViewController: navigateToMainScreen called")
        
        // 创建一个简单的主视图控制器
        let mainViewController = SimpleMainViewController()
        
        // 使用navigationController进行跳转
        if let navController = navigationController {
            print("SplashViewController: Navigation controller found, setting view controllers")
            navController.setViewControllers([mainViewController], animated: true)
        } else {
            print("SplashViewController: ERROR - Navigation controller not found!")
        }
    }
}

// 创建一个超级简单的主视图控制器用于测试
class SimpleMainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SimpleMainViewController: viewDidLoad called")
        
        view.backgroundColor = UIColor.systemBackground
        title = "主頁面"
        
        let label = UILabel()
        label.text = "應用程序已成功啟動！"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        print("SimpleMainViewController: Setup completed")
    }
} 