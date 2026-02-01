import UIKit
import Domain
import Data
import Networking
import Auth
import Home
import Accounts
import Cards
import Transactions
import Profile

final class AppDIContainer: AuthFactory, HomeFactory, AccountsFactory, CardsFactory, TransactionsFactory, ProfileFactory {
    
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
    func makeLoginUseCase() -> LoginUseCaseProtocol { return LoginUseCase(repository: authRepository) }
    func makeRegisterUseCase() -> RegisterUseCaseProtocol { return RegisterUseCase(repository: authRepository) }
    func makeForgotPasswordUseCase() -> ForgotPasswordUseCaseProtocol { return ForgotPasswordUseCase(repository: authRepository) }
    func makeGetAccountsUseCase() -> GetAccountsUseCaseProtocol { return GetAccountsUseCase(repository: accountRepository) }
    func makeGetProfileUseCase() -> GetProfileUseCaseProtocol { return GetProfileUseCase(repository: userRepository) }
    func makeTransferMoneyUseCase() -> TransferMoneyUseCaseProtocol { return TransferMoneyUseCase(repository: transactionRepository) }
    
    // Dashboard Use Cases
    func makeGetUserProfileUseCase() -> GetUserProfileUseCaseProtocol { return GetUserProfileUseCase(userRepository: userRepository) }
    func makeCreateAccountUseCase() -> CreateAccountUseCaseProtocol { return CreateAccountUseCase(repository: accountRepository) }
    func makeGetAccountDetailsUseCase() -> GetAccountDetailsUseCaseProtocol { return GetAccountDetailsUseCase(repository: accountRepository) }
    func makeGetAccountBalanceUseCase() -> GetAccountBalanceUseCaseProtocol { return GetAccountBalanceUseCase(accountRepository: accountRepository) }
    func makeGetRecentTransactionsUseCase() -> GetRecentTransactionsUseCaseProtocol { 
        return GetRecentTransactionsUseCase(
            transactionRepository: transactionRepository,
            accountRepository: accountRepository
        ) 
    }
    
    // Cards Use Cases
    func makeGetCardsUseCase() -> GetCardsUseCaseProtocol { return GetCardsUseCase(repository: cardRepository) }
    func makeManageCardUseCase() -> ManageCardUseCaseProtocol { return ManageCardUseCase(repository: cardRepository) }
    
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
        return AccountsViewController(viewModel: AccountsViewModel(getAccountsUseCase: makeGetAccountsUseCase(), actions: actions))
    }
    
    func makeAccountDetailViewController(accountId: String) -> UIViewController {
        let vm = AccountDetailViewModel(
            accountId: accountId,
            getAccountDetailsUseCase: makeGetAccountDetailsUseCase(),
            getRecentTransactionsUseCase: makeGetRecentTransactionsUseCase()
        )
        return AccountDetailViewController(viewModel: vm)
    }
    
    func makeCreateAccountViewController(actions: CreateAccountViewModelActions) -> UIViewController {
        let vm = CreateAccountViewModel(createAccountUseCase: makeCreateAccountUseCase(), actions: actions)
        return CreateAccountViewController(viewModel: vm)
    }
    
    // MARK: - TransactionsFactory
    func makeTransactionsViewController() -> UIViewController {
        return TransactionsViewController(viewModel: TransactionsViewModel(transferMoneyUseCase: makeTransferMoneyUseCase()))
    }
    
    // MARK: - ProfileFactory
    func makeProfileViewController() -> UIViewController {
        return ProfileViewController(viewModel: ProfileViewModel(getProfileUseCase: makeGetProfileUseCase()))
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
    
    func makeCardDetailViewController(card: Domain.Card) -> UIViewController {
        let vm = CardDetailViewModel(card: card, manageCardUseCase: makeManageCardUseCase())
        return CardDetailViewController(viewModel: vm)
    }
}
