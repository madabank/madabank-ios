import UIKit
import Auth
import Home

class AppCoordinator: AuthCoordinatorDelegate {
    
    var window: UIWindow
    var navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        // Check if logged in (could check Token storage)
        // For now, assume Not Logged In -> Show Auth
        showAuth()
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
        // Switch to Tab Bar or just Home for now
        let homeNav = UINavigationController()
        let homeCoord = HomeCoordinator(
            navigationController: homeNav,
            factory: AppDIContainer.shared
        )
        homeCoord.start()
        
        // Replacing root
        window.rootViewController = homeNav
        // Or if using TabBar, setup TabBarController here
    }
    
    // MARK: - AuthDelegate
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator) {
        // User logged in
        showMain()
    }
}
