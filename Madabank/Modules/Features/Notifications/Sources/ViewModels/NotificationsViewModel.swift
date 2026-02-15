import Foundation
import RxSwift
import RxCocoa
import Domain

public struct NotificationsViewModelActions {
    public init() {}
}

public class NotificationsViewModel {
    
    // Inputs
    public let viewDidLoad = PublishRelay<Void>()
    public let refresh = PublishRelay<Void>()
    
    // Outputs
    public let items: Driver<[Domain.Notification]>
    public let isLoading: Driver<Bool>
    public let error: Driver<String>
    
    // Dependencies
    private let getNotificationsUseCase: GetNotificationsUseCaseProtocol
    private let markReadUseCase: MarkNotificationReadUseCaseProtocol
    private let actions: NotificationsViewModelActions
    
    private let itemsRelay = BehaviorRelay<[Domain.Notification]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorRelay = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()
    
    public init(getNotificationsUseCase: GetNotificationsUseCaseProtocol,
                markReadUseCase: MarkNotificationReadUseCaseProtocol,
                actions: NotificationsViewModelActions) {
        self.getNotificationsUseCase = getNotificationsUseCase
        self.markReadUseCase = markReadUseCase
        self.actions = actions
        
        self.items = itemsRelay.asDriver()
        self.isLoading = isLoadingRelay.asDriver()
        self.error = errorRelay.asDriver(onErrorJustReturn: "Unknown Error")
        
        setupBindings()
    }
    
    private func setupBindings() {
        viewDidLoad
            .subscribe(onNext: { [weak self] in self?.fetchNotifications() })
            .disposed(by: disposeBag)
            
        refresh
            .subscribe(onNext: { [weak self] in self?.fetchNotifications() })
            .disposed(by: disposeBag)
    }
    
    private func fetchNotifications() {
        isLoadingRelay.accept(true)
        Task {
            do {
                let notifications = try await getNotificationsUseCase.execute()
                await MainActor.run {
                    self.itemsRelay.accept(notifications)
                    self.isLoadingRelay.accept(false)
                }
            } catch {
                await MainActor.run {
                    self.isLoadingRelay.accept(false)
                    self.errorRelay.accept(error.localizedDescription)
                }
            }
        }
    }
}
