import UIKit
import SnapKit

/// Protocol defining coordinator behavior
public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

/// Root coordinator for the Madabank app
final class AppCoordinator: Coordinator {
    
    let window: UIWindow
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Dependencies
    
    private lazy var diContainer = AppDIContainer()
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Start
    
    func start() {
        showSplash()
    }
    
    // MARK: - Navigation
    
    private func showSplash() {
        let splashVC = SplashViewController()
        splashVC.onSplashComplete = { [weak self] in
            self?.showMainApp()
        }
        
        window.rootViewController = splashVC
        window.makeKeyAndVisible()
        
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
    
    private func showMainApp() {
        // TODO: Check if user is authenticated
        // For now, go directly to main tab bar
        let tabBarController = MainTabBarController()
        
        UIView.transition(
            with: window,
            duration: 0.4,
            options: .transitionCrossDissolve
        ) {
            self.window.rootViewController = tabBarController
        }
    }
    
    private func showAuth() {
        // TODO: Initialize AuthCoordinator from Auth module
        // let authCoordinator = AuthCoordinator(...)
        // childCoordinators.append(authCoordinator)
        // authCoordinator.start()
    }
}
