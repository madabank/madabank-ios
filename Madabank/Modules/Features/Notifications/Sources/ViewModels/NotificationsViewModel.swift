import Foundation
import RxSwift
import RxCocoa
import Domain

public struct NotificationsViewModelActions {}

public class NotificationsViewModel {
    
    // Inputs
    public let viewDidLoad = PublishSubject<Void>()
    public let refresh = PublishSubject<Void>()
    
    // Outputs
    public let items: Driver<[Notification]>
    public let isLoading: Driver<Bool>
    public let error: Driver<String>
    
    // Dependencies
    private let getNotificationsUseCase: GetNotificationsUseCaseProtocol
    private let markReadUseCase: MarkNotificationReadUseCaseProtocol
    private let actions: NotificationsViewModelActions
    
    private let disposeBag = DisposeBag()
    
    public init(getNotificationsUseCase: GetNotificationsUseCaseProtocol,
                markReadUseCase: MarkNotificationReadUseCaseProtocol,
                actions: NotificationsViewModelActions) {
        self.getNotificationsUseCase = getNotificationsUseCase
        self.markReadUseCase = markReadUseCase
        self.actions = actions
        
        let loadingIndicator = ActivityIndicator()
        self.isLoading = loadingIndicator.asDriver()
        
        let errorTracker = ErrorTracker()
        self.error = errorTracker.asDriver()
        
        let reload = Observable.merge(viewDidLoad, refresh)
        
        self.items = reload
            .flatMapLatest { _ in
                return getNotificationsUseCase.execute()
                    .trackActivity(loadingIndicator)
                    .trackError(errorTracker)
                    .asDriver(onErrorJustReturn: [])
            }
            .asDriver(onErrorJustReturn: [])
    }
}
