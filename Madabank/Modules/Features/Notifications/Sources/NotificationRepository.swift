import Foundation
import RxSwift
import Domain
import Networking

public class NotificationRepository: NotificationRepositoryProtocol {
    
    // Feature disabled
    
    public init(networkManager: APIClientProtocol) {
        // no-op
    }
    
    public func getNotifications() async throws -> [Domain.Notification] {
        []
    }
    
    public func markAsRead(id: String) async throws {
        // no-op
    }
    
    public func markAllAsRead() async throws {
        // no-op
    }
}
