import UIKit
import SnapKit

/// Home/Dashboard view controller
final class HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "Welcome back,"
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.text = "Daris Adam"
        return label
    }()
    
    private let balanceCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let balanceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        label.text = "Total Balance"
        return label
    }()
    
    private let balanceAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.text = "$12,450.00"
        return label
    }()
    
    private let accountNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.7)
        label.text = "•••• •••• •••• 4532"
        return label
    }()
    
    private let quickActionsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.text = "Quick Actions"
        return label
    }()
    
    private let quickActionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    private let recentTransactionsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.text = "Recent Transactions"
        return label
    }()
    
    private let seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return button
    }()
    
    private let transactionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupQuickActions()
        setupRecentTransactions()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(greetingLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(balanceCardView)
        
        balanceCardView.addSubview(balanceTitleLabel)
        balanceCardView.addSubview(balanceAmountLabel)
        balanceCardView.addSubview(accountNumberLabel)
        
        contentView.addSubview(quickActionsLabel)
        contentView.addSubview(quickActionsStackView)
        contentView.addSubview(recentTransactionsLabel)
        contentView.addSubview(seeAllButton)
        contentView.addSubview(transactionsStackView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        greetingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        balanceCardView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(160)
        }
        
        balanceTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        balanceAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(balanceTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
        }
        
        accountNumberLabel.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(20)
        }
        
        quickActionsLabel.snp.makeConstraints { make in
            make.top.equalTo(balanceCardView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        quickActionsStackView.snp.makeConstraints { make in
            make.top.equalTo(quickActionsLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        recentTransactionsLabel.snp.makeConstraints { make in
            make.top.equalTo(quickActionsStackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(20)
        }
        
        seeAllButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentTransactionsLabel)
            make.trailing.equalToSuperview().inset(20)
        }
        
        transactionsStackView.snp.makeConstraints { make in
            make.top.equalTo(recentTransactionsLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupQuickActions() {
        let actions = [
            ("Transfer", "arrow.up.right", UIColor.systemBlue),
            ("Deposit", "arrow.down.left", UIColor.systemGreen),
            ("Pay Bills", "doc.text", UIColor.systemOrange),
            ("More", "ellipsis", UIColor.systemGray)
        ]
        
        for (title, icon, color) in actions {
            let actionView = createQuickActionView(title: title, iconName: icon, color: color)
            quickActionsStackView.addArrangedSubview(actionView)
        }
    }
    
    private func createQuickActionView(title: String, iconName: String, color: UIColor) -> UIView {
        let container = UIView()
        
        let iconContainer = UIView()
        iconContainer.backgroundColor = color.withAlphaComponent(0.15)
        iconContainer.layer.cornerRadius = 20
        container.addSubview(iconContainer)
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = color
        iconImageView.contentMode = .scaleAspectFit
        iconContainer.addSubview(iconImageView)
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        container.addSubview(label)
        
        iconContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(iconContainer.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        return container
    }
    
    private func setupRecentTransactions() {
        let transactions = [
            ("Netflix Subscription", "Entertainment", "-$15.99", UIColor.systemRed),
            ("Salary Deposit", "Income", "+$3,500.00", UIColor.systemGreen),
            ("Grocery Store", "Shopping", "-$85.50", UIColor.systemRed),
            ("Transfer to John", "Transfer", "-$200.00", UIColor.systemRed)
        ]
        
        for (title, subtitle, amount, color) in transactions {
            let transactionView = createTransactionView(title: title, subtitle: subtitle, amount: amount, amountColor: color)
            transactionsStackView.addArrangedSubview(transactionView)
        }
    }
    
    private func createTransactionView(title: String, subtitle: String, amount: String, amountColor: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 12
        
        let iconContainer = UIView()
        iconContainer.backgroundColor = .systemGray5
        iconContainer.layer.cornerRadius = 20
        container.addSubview(iconContainer)
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "arrow.left.arrow.right")
        iconImageView.tintColor = .label
        iconImageView.contentMode = .scaleAspectFit
        iconContainer.addSubview(iconImageView)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        container.addSubview(titleLabel)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        container.addSubview(subtitleLabel)
        
        let amountLabel = UILabel()
        amountLabel.text = amount
        amountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        amountLabel.textColor = amountColor
        container.addSubview(amountLabel)
        
        container.snp.makeConstraints { make in
            make.height.equalTo(72)
        }
        
        iconContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconContainer.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        return container
    }
}
