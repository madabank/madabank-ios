import UIKit
import SnapKit

/// Main tab bar controller for the Madabank app
final class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    // MARK: - Setup
    
    private func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .systemBlue
    }
    
    private func setupViewControllers() {
        let homeVC = createHomeViewController()
        let accountsVC = createAccountsViewController()
        let cardsVC = createCardsViewController()
        let transferVC = createTransferViewController()
        let profileVC = createProfileViewController()
        
        viewControllers = [homeVC, accountsVC, cardsVC, transferVC, profileVC]
    }
    
    // MARK: - Tab View Controllers
    
    private func createHomeViewController() -> UINavigationController {
        let vc = HomeViewController()
        vc.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        return UINavigationController(rootViewController: vc)
    }
    
    private func createAccountsViewController() -> UINavigationController {
        let vc = PlaceholderViewController(title: "Accounts", iconName: "creditcard")
        vc.tabBarItem = UITabBarItem(
            title: "Accounts",
            image: UIImage(systemName: "banknote"),
            selectedImage: UIImage(systemName: "banknote.fill")
        )
        return UINavigationController(rootViewController: vc)
    }
    
    private func createCardsViewController() -> UINavigationController {
        let vc = PlaceholderViewController(title: "Cards", iconName: "creditcard")
        vc.tabBarItem = UITabBarItem(
            title: "Cards",
            image: UIImage(systemName: "creditcard"),
            selectedImage: UIImage(systemName: "creditcard.fill")
        )
        return UINavigationController(rootViewController: vc)
    }
    
    private func createTransferViewController() -> UINavigationController {
        let vc = PlaceholderViewController(title: "Transfer", iconName: "arrow.left.arrow.right")
        vc.tabBarItem = UITabBarItem(
            title: "Transfer",
            image: UIImage(systemName: "arrow.left.arrow.right"),
            selectedImage: UIImage(systemName: "arrow.left.arrow.right.circle.fill")
        )
        return UINavigationController(rootViewController: vc)
    }
    
    private func createProfileViewController() -> UINavigationController {
        let vc = PlaceholderViewController(title: "Profile", iconName: "person")
        vc.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        return UINavigationController(rootViewController: vc)
    }
}

// MARK: - Placeholder View Controller

final class PlaceholderViewController: UIViewController {
    
    private let titleText: String
    private let iconName: String
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .tertiaryLabel
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(title: String, iconName: String) {
        self.titleText = title
        self.iconName = iconName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        title = titleText
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        iconImageView.image = UIImage(systemName: iconName)
        messageLabel.text = "Coming soon..."
        
        view.addSubview(iconImageView)
        view.addSubview(messageLabel)
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.width.height.equalTo(60)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }
}
