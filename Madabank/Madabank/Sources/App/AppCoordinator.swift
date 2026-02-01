import UIKit
import Core
import Auth
import Home
import Accounts
import Cards
import Transactions

class AppCoordinator: AuthCoordinatorDelegate, HomeCoordinatorDelegate {
    
    var window: UIWindow
    var navigationController: UINavigationController
    
    private var homeCoordinator: HomeCoordinator?
    private var accountsCoordinator: AccountsCoordinator?
    private var cardsCoordinator: CardsCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    public func start() {
        if TokenManager.shared.isLoggedIn {
            showMain()
        } else {
            showAuth()
        }
    }
    
    private func showAuth() {
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
        
        // 1. Home Tab
        let homeNav = UINavigationController()
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        let homeCoord = HomeCoordinator(navigationController: homeNav, factory: AppDIContainer.shared)
        homeCoord.delegate = self
        homeCoord.start()
        self.homeCoordinator = homeCoord
        
        // 2. Cards Tab
        let cardsNav = UINavigationController()
        cardsNav.tabBarItem = UITabBarItem(title: "Cards", image: UIImage(systemName: "creditcard"), tag: 1)
        let cardsCoord = CardsCoordinator(navigationController: cardsNav, factory: AppDIContainer.shared)
        cardsCoord.start()
        self.cardsCoordinator = cardsCoord
        
        // 3. Accounts Tab
        let accountsNav = UINavigationController()
        accountsNav.tabBarItem = UITabBarItem(title: "Accounts", image: UIImage(systemName: "wallet.pass"), tag: 2)
        let accountsCoord = AccountsCoordinator(navigationController: accountsNav, factory: AppDIContainer.shared)
        accountsCoord.start()
        self.accountsCoordinator = accountsCoord
        
        // 4. Transactions Tab
        let transactionsNav = UINavigationController()
        transactionsNav.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "list.bullet.rectangle"), tag: 3)
        let transactionsCoord = TransactionsCoordinator(navigationController: transactionsNav, factory: AppDIContainer.shared)
        transactionsCoord.start()
        
        tabBarController.viewControllers = [homeNav, cardsNav, accountsNav, transactionsNav]
        tabBarController.tabBar.tintColor = ColorSystem.primary
        
        window.rootViewController = tabBarController
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    // MARK: - AuthDelegate
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator) {
        showMain()
    }
    
    // MARK: - HomeDelegate
    func homeCoordinatorDidRequestAccounts(_ coordinator: HomeCoordinator) {
        if let tabBar = window.rootViewController as? UITabBarController {
            tabBar.selectedIndex = 2 // Switch to Accounts tab
        }
    }
    
    func homeCoordinatorDidRequestCards(_ coordinator: HomeCoordinator) {
        if let tabBar = window.rootViewController as? UITabBarController {
            tabBar.selectedIndex = 1 // Switch to Cards tab
        }
    }
    
    func homeCoordinatorDidRequestTransfer(_ coordinator: HomeCoordinator) {
        print("Requested Transfer")
    }
}
