import Foundation
import RxSwift
import Domain
import Networking

public class NotificationRepository: NotificationRepositoryProtocol {
    
    private let networkManager: APIClientProtocol
    
    public init(networkManager: APIClientProtocol) {
        self.networkManager = networkManager
    }
    
    public func getNotifications() async throws -> [Domain.Notification] {
        let response: [Networking.NotificationDTO] = try await networkManager.request(APIEndpoint.getNotifications)
        return response.map { $0.toDomain() }
    }
    
    public func markAsRead(id: String) async throws {
        try await networkManager.requestVoid(APIEndpoint.markNotificationRead(id: id))
    }
    
    public func markAllAsRead() async throws {
        try await networkManager.requestVoid(APIEndpoint.markAllNotificationsRead)
    }
}

fileprivate extension Networking.NotificationDTO {
    func toDomain() -> Domain.Notification {
        let dateFormatter = ISO8601DateFormatter()
        let parsedDate = dateFormatter.date(from: date) ?? Date()
        
        let notificationType = Domain.NotificationType(rawValue: type) ?? .info
        
        return Domain.Notification(
            id: id,
            title: title,
            message: message,
            date: parsedDate,
            isRead: isRead,
            type: notificationType
        )
    }
}
