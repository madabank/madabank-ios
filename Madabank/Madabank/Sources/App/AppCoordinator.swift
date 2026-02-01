import UIKit
import Core
import Auth
import Home

class AppCoordinator: AuthCoordinatorDelegate, HomeCoordinatorDelegate {
    
    var window: UIWindow
    var navigationController: UINavigationController
    
    private var homeCoordinator: HomeCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        // Check if user is already logged in
        if TokenManager.shared.isLoggedIn {
            showMain()
        } else {
            showAuth()
        }
    }
    
    private func showAuth() {
        let authCoord = AuthCoordinator(
            navigationController: navigationController,
            factory: AppDIContainer.shared
        )
        authCoord.delegate = self
        authCoord.start()
    }
    
    private func showMain() {
        let homeNav = UINavigationController()
        let homeCoord = HomeCoordinator(
            navigationController: homeNav,
            factory: AppDIContainer.shared
        )
        homeCoord.delegate = self
        homeCoord.start()
        
        self.homeCoordinator = homeCoord
        window.rootViewController = homeNav
    }
    
    // MARK: - AuthDelegate
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator) {
        // User logged in
        showMain()
    }
    
    // MARK: - HomeDelegate
    func homeCoordinatorDidRequestAccounts(_ coordinator: HomeCoordinator) {
        print("Requested Accounts/Transactions")
    }
    
    func homeCoordinatorDidRequestCards(_ coordinator: HomeCoordinator) {
        print("Requested Cards")
    }
    
    func homeCoordinatorDidRequestTransfer(_ coordinator: HomeCoordinator) {
        print("Requested Transfer")
    }
}
