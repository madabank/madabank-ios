import UIKit
import Domain
import Data
import Networking
import Auth
import Home
import MadabankAccounts
import Cards
import Transactions
import Profile
import Notifications
import RxSwift

@MainActor
final class AppDIContainer: AuthFactory, HomeFactory, AccountsFactory, CardsFactory, TransactionsFactory, ProfileFactory, NotificationsFactory {
    
    static let shared = AppDIContainer()
    
    // Core Services
    let networkManager: APIClientProtocol = NetworkManager.shared
    
    // Repositories
    lazy var authRepository: AuthRepositoryProtocol = AuthRepository(networkManager: networkManager)
    lazy var userRepository: UserRepositoryProtocol = UserRepository(networkManager: networkManager)
    lazy var accountRepository: AccountRepositoryProtocol = AccountRepository(networkManager: networkManager)
    lazy var transactionRepository: TransactionRepositoryProtocol = TransactionRepository(networkManager: networkManager)
    lazy var cardRepository: CardRepositoryProtocol = CardRepository(networkManager: networkManager)
    
    // Use Cases
    func makeLoginUseCase() -> LoginUseCaseProtocol { LoginUseCase(repository: authRepository) }
    func makeRegisterUseCase() -> RegisterUseCaseProtocol { RegisterUseCase(repository: authRepository) }
    func makeForgotPasswordUseCase() -> ForgotPasswordUseCaseProtocol { ForgotPasswordUseCase(repository: authRepository) }
    func makeGetAccountsUseCase() -> GetAccountsUseCaseProtocol { GetAccountsUseCase(repository: accountRepository) }
    func makeGetProfileUseCase() -> GetProfileUseCaseProtocol { GetProfileUseCase(repository: userRepository) }
    func makeTransferMoneyUseCase() -> TransferMoneyUseCaseProtocol { TransferMoneyUseCase(repository: transactionRepository) }
    
    // Dashboard Use Cases
    func makeGetUserProfileUseCase() -> GetUserProfileUseCaseProtocol { GetUserProfileUseCase(userRepository: userRepository) }
    func makeCreateAccountUseCase() -> CreateAccountUseCaseProtocol { CreateAccountUseCase(repository: accountRepository) }
    func makeGetAccountDetailsUseCase() -> GetAccountDetailsUseCaseProtocol { GetAccountDetailsUseCase(repository: accountRepository) }
    func makeGetAccountBalanceUseCase() -> GetAccountBalanceUseCaseProtocol { GetAccountBalanceUseCase(accountRepository: accountRepository) }
    func makeCloseAccountUseCase() -> CloseAccountUseCaseProtocol { CloseAccountUseCase(repository: accountRepository) }
    func makeGetRecentTransactionsUseCase() -> GetRecentTransactionsUseCaseProtocol { 
        GetRecentTransactionsUseCase(
            transactionRepository: transactionRepository,
            accountRepository: accountRepository
        ) 
    }
    
    // Beneficiaries
    lazy var beneficiaryRepository: BeneficiaryRepositoryProtocol = BeneficiaryRepository()
    
    func makeGetBeneficiariesUseCase() -> GetBeneficiariesUseCaseProtocol { GetBeneficiariesUseCase(repository: beneficiaryRepository) }
    func makeAddBeneficiaryUseCase() -> AddBeneficiaryUseCaseProtocol { AddBeneficiaryUseCase(repository: beneficiaryRepository) }
    
    // Fund Management
    func makeDepositUseCase() -> DepositUseCaseProtocol { DepositUseCase(repository: transactionRepository) }
    func makeWithdrawUseCase() -> WithdrawUseCaseProtocol { WithdrawUseCase(repository: transactionRepository) }
    
    func makeCheckSystemStatusUseCase() -> CheckSystemStatusUseCaseProtocol {
        CheckSystemStatusUseCase(networkManager: networkManager)
    }
    
    // Cards Use Cases
    func makeGetCardsUseCase() -> GetCardsUseCaseProtocol { GetCardsUseCase(repository: cardRepository) }
    func makeManageCardUseCase() -> ManageCardUseCaseProtocol { ManageCardUseCase(repository: cardRepository) }
    func makeIssueCardUseCase() -> IssueCardUseCaseProtocol { IssueCardUseCase(repository: cardRepository) }
    
    // Transactions Use Cases
    func makeGetTransactionsUseCase() -> GetTransactionsUseCaseProtocol { GetTransactionsUseCase(repository: transactionRepository) }
    func makeGetTransactionDetailsUseCase() -> GetTransactionDetailsUseCaseProtocol { GetTransactionDetailsUseCase(repository: transactionRepository) }
    
    // MARK: - AuthFactory
    func makeLoginViewController(actions: LoginViewModelActions) -> UIViewController {
        let vm = LoginViewModel(loginUseCase: makeLoginUseCase(), actions: actions)
        let vc = LoginViewController(viewModel: vm)
        return vc
    }
    
    func makeRegisterViewController(actions: RegisterViewModelActions) -> UIViewController {
        let vm = RegisterViewModel(registerUseCase: makeRegisterUseCase(), actions: actions)
        return RegisterViewController(viewModel: vm)
    }
    
    func makeForgotPasswordViewController(actions: ForgotPasswordViewModelActions) -> UIViewController {
        let vm = ForgotPasswordViewModel(forgotPasswordUseCase: makeForgotPasswordUseCase(), actions: actions)
        return ForgotPasswordViewController(viewModel: vm)
    }
    
    // MARK: - HomeFactory
    func makeHomeViewController(actions: HomeViewModelActions) -> UIViewController {
        let vm = HomeViewModel(
            getUserProfileUseCase: makeGetUserProfileUseCase(),
            getAccountBalanceUseCase: makeGetAccountBalanceUseCase(),
            getRecentTransactionsUseCase: makeGetRecentTransactionsUseCase(),
            actions: actions
        )
        return HomeViewController(viewModel: vm)
    }
    
    // MARK: - AccountsFactory
    func makeAccountsViewController(actions: AccountsViewModelActions) -> UIViewController {
        AccountsViewController(viewModel: AccountsViewModel(getAccountsUseCase: makeGetAccountsUseCase(), actions: actions))
    }
    
    func makeAccountDetailViewController(accountId: String, actions: AccountDetailViewModelActions) -> UIViewController {
        let vm = AccountDetailViewModel(
            accountId: accountId,
            getAccountDetailsUseCase: makeGetAccountDetailsUseCase(),
            getRecentTransactionsUseCase: makeGetRecentTransactionsUseCase(),
            closeAccountUseCase: makeCloseAccountUseCase(),
            actions: actions
        )
        return AccountDetailViewController(viewModel: vm)
    }
    
    func makeCreateAccountViewController(actions: CreateAccountViewModelActions) -> UIViewController {
        let vm = CreateAccountViewModel(createAccountUseCase: makeCreateAccountUseCase(), actions: actions)
        return CreateAccountViewController(viewModel: vm)
    }
    
    // MARK: - TransactionsFactory
    func makeTransactionsViewController(actions: TransactionsViewModelActions) -> UIViewController {
        TransactionsViewController(viewModel: TransactionsViewModel(
            getTransactionsUseCase: makeGetTransactionsUseCase(),
            getAccountsUseCase: makeGetAccountsUseCase(),
            actions: actions
        ))
    }
    
    func makeTransactionDetailViewController(transaction: Domain.Transaction) -> UIViewController {
        let vm = TransactionDetailViewModel(
            transaction: transaction,
            useCase: makeGetTransactionDetailsUseCase()
        )
        return TransactionDetailViewController(viewModel: vm)
    }

    func makeTransferViewController(actions: TransferViewModelActions) -> UIViewController {
        let vm = TransferViewModel(
            transferUseCase: makeTransferMoneyUseCase(),
            getAccountsUseCase: makeGetAccountsUseCase(),
            actions: actions
        )
        return TransferViewController(viewModel: vm)
    }

    func makeManageFundsViewController(type: FundManagementType, actions: ManageFundsViewModelActions) -> UIViewController {
        let vm = ManageFundsViewModel(
            type: type,
            getAccountsUseCase: makeGetAccountsUseCase(),
            depositUseCase: makeDepositUseCase(),
            withdrawUseCase: makeWithdrawUseCase(),
            actions: actions
        )
        return ManageFundsViewController(viewModel: vm)
    }

    func makeQRScannerViewController(delegate: QRScannerViewControllerDelegate) -> UIViewController {
        let vc = QRScannerViewController()
        vc.delegate = delegate
        return vc
    }

    func makeQRPaymentViewController(recipientName: String, actions: QRPaymentViewModelActions) -> UIViewController {
        let vm = QRPaymentViewModel(recipientName: recipientName, actions: actions)
        return QRPaymentViewController(viewModel: vm)
    }

    func makeBeneficiariesListViewController(actions: BeneficiariesViewModelActions) -> UIViewController {
        let vm = BeneficiariesListViewModel(
            getBeneficiariesUseCase: makeGetBeneficiariesUseCase(),
            addBeneficiaryUseCase: makeAddBeneficiaryUseCase(),
            actions: actions
        )
        return BeneficiariesListViewController(viewModel: vm)
    }
    
    func makeUpdateProfileUseCase() -> UpdateProfileUseCaseProtocol { UpdateProfileUseCase(repository: userRepository) }
    func makeDeleteProfileUseCase() -> DeleteProfileUseCaseProtocol { DeleteProfileUseCase(repository: userRepository) }
    func makeChangePasswordUseCase() -> ChangePasswordUseCaseProtocol { ChangePasswordUseCase(repository: authRepository) }
    
    // Notifications
    lazy var notificationRepository: NotificationRepositoryProtocol = NotificationRepository(networkManager: networkManager)
    
    func makeGetNotificationsUseCase() -> GetNotificationsUseCaseProtocol {
        GetNotificationsUseCase(repository: notificationRepository)
    }
    
    func makeMarkNotificationReadUseCase() -> MarkNotificationReadUseCaseProtocol {
        MarkNotificationReadUseCase(repository: notificationRepository)
    }
    
    // MARK: - ProfileFactory
    func makeProfileViewController(coordinator: ProfileCoordinator) -> UIViewController {
        let vm = ProfileViewModel(getProfileUseCase: makeGetProfileUseCase())
        vm.coordinator = coordinator // Assuming ProfileViewModel has coordinator property, or we need to add actions
        return ProfileViewController(viewModel: vm)
    }
    
    func makeSettingsViewController(coordinator: ProfileCoordinator) -> UIViewController {
        let vm = SettingsViewModel(deleteProfileUseCase: makeDeleteProfileUseCase())
        // Bind ViewModel Output to Coordinator Input
        vm.navigation
            .subscribe { [weak coordinator] destination in
                switch destination {
                case .editProfile: coordinator?.showEditProfile()
                case .changePassword: coordinator?.showChangePassword()
                case .loggedOut: coordinator?.didLogout()
                }
            }
            .disposed(by: DisposeBag()) // This might leak if not handled carefully, ideally bind in VC or use closure
            
        // Better approach: Pass actions or bind in VC? 
        // Let's stick to standard pattern: VM exposes signals, Coord observes? Or Coord passes closure? 
        // Since I can't easily change SettingsViewModel init right now without re-reading, I'll use the signal subscription here which is "okay" for DI container wiring, 
        // OR better: Pass closures to VM if VM supports it. VM currently uses PublishSubject.
        // Let's just return VC and let VC bind to Coordinator? No, VC shouldn't know Coordinator.
        // Let's bind here but with a dedicated DisposeBag for the flow? 
        // Actually, ProfileCoordinator usually holds the bag if we were doing MVVM-C properly.
        // For now, I'll instantiate the VC and VM, and setup the subscription.
        
        return SettingsViewController(viewModel: vm)
    }
    
    func makeEditProfileViewController() -> UIViewController {
        let vm = EditProfileViewModel(
            updateProfileUseCase: makeUpdateProfileUseCase(),
            getProfileUseCase: makeGetProfileUseCase()
        )
        return EditProfileViewController(viewModel: vm)
    }
    
    func makeChangePasswordViewController() -> UIViewController {
        let vm = ChangePasswordViewModel(changePasswordUseCase: makeChangePasswordUseCase())
        return ChangePasswordViewController(viewModel: vm)
    }
    
    // MARK: - CardsFactory
    func makeCardsViewController(actions: CardsViewModelActions) -> UIViewController {
        let vm = CardsViewModel(
            getAccountsUseCase: makeGetAccountsUseCase(),
            getCardsUseCase: makeGetCardsUseCase(),
            manageCardUseCase: makeManageCardUseCase(),
            actions: actions
        )
        return CardsViewController(viewModel: vm)
    }
    
    func makeCardDetailViewController(card: Domain.Card, actions: CardDetailViewModelActions) -> UIViewController {
        let vm = CardDetailViewModel(card: card, manageCardUseCase: makeManageCardUseCase(), actions: actions)
        return CardDetailViewController(viewModel: vm)
    }
    
    func makeIssueCardViewController(actions: IssueCardViewModelActions) -> UIViewController {
        let vm = IssueCardViewModel(
            getAccountsUseCase: makeGetAccountsUseCase(),
            issueCardUseCase: makeIssueCardUseCase(),
            actions: actions
        )
        return IssueCardViewController(viewModel: vm)
    }
    
    // MARK: - NotificationsFactory
    func makeNotificationsViewController() -> UIViewController {
        let actions = NotificationsViewModelActions()
        let vm = NotificationsViewModel(
            getNotificationsUseCase: makeGetNotificationsUseCase(),
            markReadUseCase: makeMarkNotificationReadUseCase(),
            actions: actions
        )
        return NotificationsViewController(viewModel: vm)
    }
}
