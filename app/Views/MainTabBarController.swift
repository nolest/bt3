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
        
        // 社群页面
        let communityVC = CommunityViewController()
        let communityNav = createNavController(for: communityVC, title: "社群", image: UIImage(systemName: "person.3")!, selectedImage: UIImage(systemName: "person.3.fill")!)
        
        // 智慧助理页面
        let assistantVC = AssistantViewController()
        let assistantNav = createNavController(for: assistantVC, title: "助理", image: UIImage(systemName: "wand.and.stars")!, selectedImage: UIImage(systemName: "wand.and.stars.inverse")!)
        
        // 設置頁面
        let settingsVC = SettingsViewController()
        let settingsNav = createNavController(for: settingsVC, title: "設置", image: UIImage(systemName: "gearshape")!, selectedImage: UIImage(systemName: "gearshape.fill")!)
        
        // 设置视图控制器
        viewControllers = [homeNav, recordsNav, statisticsNav, photosNav, communityNav, assistantNav, settingsNav]
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
        // 设置标签栏外观
        tabBar.tintColor = Constants.Colors.primaryColor
        tabBar.unselectedItemTintColor = Constants.Colors.secondaryTextColor
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Constants.Colors.cardBackgroundColor
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.barTintColor = Constants.Colors.cardBackgroundColor
        }
        
        // 设置导航栏外观
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Constants.Colors.cardBackgroundColor
            appearance.titleTextAttributes = [.foregroundColor: Constants.Colors.primaryTextColor]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().tintColor = Constants.Colors.primaryColor
        } else {
            UINavigationBar.appearance().barTintColor = Constants.Colors.cardBackgroundColor
            UINavigationBar.appearance().tintColor = Constants.Colors.primaryColor
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: Constants.Colors.primaryTextColor]
        }
    }
} 