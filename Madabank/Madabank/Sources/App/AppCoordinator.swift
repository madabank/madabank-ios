import UIKit
import Core
import Auth
import Home
import Accounts

class AppCoordinator: AuthCoordinatorDelegate, HomeCoordinatorDelegate {
    
    var window: UIWindow
    var navigationController: UINavigationController
    
    private var homeCoordinator: HomeCoordinator?
    private var accountsCoordinator: AccountsCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        // Note: With TabBar, root is likely the TabBarController, not a global NavController.
        // But for simplicity, we can have NavController > TabBar or just TabBar as root.
        // Let's make TabBar the root for Main flow.
    }
    
    public func start() {
        if TokenManager.shared.isLoggedIn {
            showMain()
        } else {
            showAuth()
        }
    }
    
    private func showAuth() {
        // Reset root to NavigationController for Auth flow
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        
        let authCoord = AuthCoordinator(
            navigationController: navigationController,
            factory: AppDIContainer.shared
        )
        authCoord.delegate = self
        authCoord.start()
    }
    
    private func showMain() {
        let tabBarController = UITabBarController()
        
        // Home Tab
        let homeNav = UINavigationController()
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        let homeCoord = HomeCoordinator(navigationController: homeNav, factory: AppDIContainer.shared)
        homeCoord.delegate = self
        homeCoord.start()
        self.homeCoordinator = homeCoord
        
        // Accounts Tab
        let accountsNav = UINavigationController()
        accountsNav.tabBarItem = UITabBarItem(title: "Accounts", image: UIImage(systemName: "wallet.pass"), tag: 1)
        let accountsCoord = AccountsCoordinator(navigationController: accountsNav, factory: AppDIContainer.shared)
        accountsCoord.start()
        self.accountsCoordinator = accountsCoord
        
        tabBarController.viewControllers = [homeNav, accountsNav]
        tabBarController.tabBar.tintColor = ColorSystem.primary
        
        window.rootViewController = tabBarController
        
        // Simple transition animation
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    // MARK: - AuthDelegate
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator) {
        showMain()
    }
    
    // MARK: - HomeDelegate
    func homeCoordinatorDidRequestAccounts(_ coordinator: HomeCoordinator) {
        if let tabBar = window.rootViewController as? UITabBarController {
            tabBar.selectedIndex = 1 // Switch to Accounts tab
        }
    }
    
    func homeCoordinatorDidRequestCards(_ coordinator: HomeCoordinator) {
        print("Requested Cards")
    }
    
    func homeCoordinatorDidRequestTransfer(_ coordinator: HomeCoordinator) {
        print("Requested Transfer")
    }
}
