import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupAppearance()
    }
    
    private func setupViewControllers() {
        // 首页（今日概览）
        let homeVC = HomeViewController()
        let homeNav = createNavController(for: homeVC, title: "今日", image: UIImage(systemName: "house")!, selectedImage: UIImage(systemName: "house.fill")!)
        
        // 记录页面
        let recordsVC = RecordsViewController()
        let recordsNav = createNavController(for: recordsVC, title: "記錄", image: UIImage(systemName: "list.bullet")!, selectedImage: UIImage(systemName: "list.bullet")!)
        
        // 统计页面
        let statisticsVC = StatisticsViewController()
        let statisticsNav = createNavController(for: statisticsVC, title: "統計", image: UIImage(systemName: "chart.bar")!, selectedImage: UIImage(systemName: "chart.bar.fill")!)
        
        // 照片与影片页面
        let photosVC = PhotosViewController()
        let photosNav = createNavController(for: photosVC, title: "相冊", image: UIImage(systemName: "photo")!, selectedImage: UIImage(systemName: "photo.fill")!)
        
        // 設置頁面
        let settingsVC = SettingsViewController()
        let settingsNav = createNavController(for: settingsVC, title: "設置", image: UIImage(systemName: "gearshape")!, selectedImage: UIImage(systemName: "gearshape.fill")!)
        
        // 设置视图控制器（减少标签页数量以简化）
        viewControllers = [homeNav, recordsNav, statisticsNav, photosNav, settingsNav]
        selectedIndex = 0
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage, selectedImage: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        rootViewController.navigationItem.title = title
        return navController
    }
    
    private func setupAppearance() {
        // 使用系统默认颜色
        tabBar.tintColor = UIColor.systemBlue
        tabBar.unselectedItemTintColor = UIColor.systemGray
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.barTintColor = UIColor.systemBackground
        }
        
        // 设置导航栏外观
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().tintColor = UIColor.systemBlue
        } else {
            UINavigationBar.appearance().barTintColor = UIColor.systemBackground
            UINavigationBar.appearance().tintColor = UIColor.systemBlue
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.label]
        }
    }
} 