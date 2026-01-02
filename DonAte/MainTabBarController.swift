import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
        setupTabs()
        setupTabBarAppearance()
    }
    
    private func setupNavigationBarAppearance() {
        // Configure navigation bar for green header consistency
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: "b4e7b4")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Remove shadow/border
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        // Set tint color for back button and bar button items
        UINavigationBar.appearance().tintColor = .white
        
        // Apply appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    private func setupTabs() {
        // Dashboard Tab
        let dashboardVC = DashboardViewController()
        let dashboardNav = UINavigationController(rootViewController: dashboardVC)
        dashboardNav.tabBarItem = UITabBarItem(
            title: "Dashboard",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        // Pick ups Tab
        let pickupsVC = PickupsViewController()
        let pickupsNav = UINavigationController(rootViewController: pickupsVC)
        pickupsNav.tabBarItem = UITabBarItem(
            title: "Pick ups",
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar")
        )
        
        // Messages Tab
        let messagesVC = MessagesViewController()
        let messagesNav = UINavigationController(rootViewController: messagesVC)
        messagesNav.tabBarItem = UITabBarItem(
            title: "Messages",
            image: UIImage(systemName: "message"),
            selectedImage: UIImage(systemName: "message.fill")
        )
        
        // Notifications Tab
        let notificationsVC = NotificationsViewController()
        let notificationsNav = UINavigationController(rootViewController: notificationsVC)
        notificationsNav.tabBarItem = UITabBarItem(
            title: "Notifications",
            image: UIImage(systemName: "bell"),
            selectedImage: UIImage(systemName: "bell.fill")
        )
        
        // Set view controllers
        viewControllers = [dashboardNav, pickupsNav, messagesNav, notificationsNav]
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        // Selected tab color (green)
        appearance.stackedLayoutAppearance.selected.iconColor = .donateGreen
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.donateGreen,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        // Unselected tab color (gray)
        appearance.stackedLayoutAppearance.normal.iconColor = .systemGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 10, weight: .regular)
        ]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.layer.borderWidth = 0.3
        tabBar.layer.borderColor = UIColor.systemGray4.cgColor
        tabBar.clipsToBounds = true
    }
}
