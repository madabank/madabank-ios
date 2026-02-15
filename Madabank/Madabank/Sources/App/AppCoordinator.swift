import UIKit
import Core
import Auth
import Home
import MadabankAccounts
import Cards
import Transactions
import Domain

@MainActor
class AppCoordinator: AuthCoordinatorDelegate, HomeCoordinatorDelegate {
    
    var window: UIWindow
    var navigationController: UINavigationController
    
    private var homeCoordinator: HomeCoordinator?
    private var accountsCoordinator: AccountsCoordinator?
    private var cardsCoordinator: CardsCoordinator?
    private var authCoordinator: AuthCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        showSplash()
    }
    
    private func showSplash() {
        let splashVC = SplashViewController()
        let checkUseCase = AppDIContainer.shared.makeCheckSystemStatusUseCase()
        
        splashVC.onCheckStatus = {
            await checkUseCase.execute()
        }
        
        splashVC.onFinish = { [weak self] status in
            guard let self = self else { return }
            
            // Navigate to main/auth regardless of status (as requested)
            self.checkAuthStateAndRedirect()
            
            // If error, show blocking overlay immediately
            // SKIP if UI Testing (to avoid blocking simulator)
            let isUITesting = ProcessInfo.processInfo.arguments.contains("--uitesting")
            if status != .healthy && !isUITesting {
                self.showBlockingError(status: status)
            }
        }
        
        window.rootViewController = splashVC
        window.makeKeyAndVisible()
    }
    
    private func showBlockingError(status: SystemStatus) {
        let errorVC = BlockingFailureViewController(status: status)
        errorVC.onRetry = { [weak self, weak errorVC] in
            // Retry logic:
            // 1. Show loading/checking state? 
            //    Ideally BlockingFailureVC has its own loading state or we dismiss and show Splash again.
            //    Showing Splash again is simplest and safest.
            errorVC?.dismiss(animated: false) {
                self?.start() // Restart flow
            }
        }
        
        // Present over current root
        // Need to wait for transition to complete? 
        // Window transition is 0.3s.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.window.rootViewController?.present(errorVC, animated: true)
        }
    }
    
    private func checkAuthStateAndRedirect() {
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
        self.authCoordinator = authCoord
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

    }
    
    func homeCoordinatorDidRequestPayment(_ coordinator: HomeCoordinator) {

    }
    
    func homeCoordinatorDidRequestTopUp(_ coordinator: HomeCoordinator) {

    }
    
    func homeCoordinatorDidRequestScan(_ coordinator: HomeCoordinator) {
        // Handle scan navigation
        // For now, assume it's like a payment flow or QR scanner
        let scanner = AppDIContainer.shared.makeQRScannerViewController(delegate: self)
        scanner.hidesBottomBarWhenPushed = true
        coordinator.navigationController.pushViewController(scanner, animated: true)
    }
}

// MARK: - QRScannerDelegate
extension AppCoordinator: QRScannerViewControllerDelegate {
    func qrScannerDidScan(code: String) {
        // Pop scanner
        if let homeCoord = homeCoordinator {
             homeCoord.navigationController.popViewController(animated: true)
             // Handle payment flow
             let paymentVC = AppDIContainer.shared.makeQRPaymentViewController(recipientName: "Unknown", actions: QRPaymentViewModelActions { [weak homeCoord] in
                 homeCoord?.navigationController.popToRootViewController(animated: true)
             })
             paymentVC.hidesBottomBarWhenPushed = true
             homeCoord.navigationController.pushViewController(paymentVC, animated: true)
        }
    }
}
