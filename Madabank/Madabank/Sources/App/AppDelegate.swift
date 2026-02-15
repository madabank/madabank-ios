import UIKit
import netfox
import IQKeyboardManagerSwift
import Core

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if CommandLine.arguments.contains("--uitesting") {
            if CommandLine.arguments.contains("-reset") {
                TokenManager.shared.clearSession()
            }
            IQKeyboardManager.shared.enable = false
        } else {
            // Enable IQKeyboardManager
            IQKeyboardManager.shared.enable = true
            IQKeyboardManager.shared.shouldResignOnTouchOutside = true
            SecurityManager.shared.performSecurityChecks()
        }
        
        #if DEBUG
        NFX.sharedInstance().start()
        #endif
        
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
}
