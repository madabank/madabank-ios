import UIKit
import RxSwift

public enum Notifications {
    public static let version = "1.0.0"
}

public protocol NotificationsFactory {
    func makeNotificationsViewController() -> UIViewController
}

// Re-export dependencies
@_exported import CommonUI
@_exported import Domain
@_exported import Data
