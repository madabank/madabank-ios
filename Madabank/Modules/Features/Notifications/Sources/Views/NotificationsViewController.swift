import UIKit
import RxSwift
import RxCocoa
import SnapKit
import CommonUI
import Domain

public final class NotificationsViewController: UIViewController {
    
    private let viewModel: NotificationsViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = ColorSystem.background
        table.separatorStyle = .singleLine
        table.separatorColor = ColorSystem.secondary
        table.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 80
        return table
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = ColorSystem.primary
        return refresh
    }()
    
    private lazy var emptyStateView: MBEmptyStateView = {
        let view = MBEmptyStateView(
            image: UIImage(systemName: "bell.slash"),
            title: "No Notifications",
            message: "You're all caught up!",
            buttonTitle: nil
        )
        view.isHidden = true
        return view
    }()
    
    // MARK: - Init
    
    public init(viewModel: NotificationsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.viewDidLoad.onNext(())
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "Notifications"
        view.backgroundColor = ColorSystem.background
        
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        view.addSubview(emptyStateView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyStateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func bindViewModel() {
        viewModel.items
            .drive(tableView.rx.items(cellIdentifier: "NotificationCell", cellType: NotificationCell.self)) { _, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
            
        viewModel.items
            .map { !$0.isEmpty }
            .drive(emptyStateView.rx.isHidden)
            .disposed(by: disposeBag)
            
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.refresh)
            .disposed(by: disposeBag)
            
        viewModel.isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}

// MARK: - NotificationCell

final class NotificationCell: UITableViewCell {
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.headline
        label.textColor = ColorSystem.textPrimary
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body
        label.textColor = ColorSystem.textSecondary
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.caption1
        label.textColor = ColorSystem.textSecondary
        return label
    }()
    
    private let unreadIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSystem.primary
        view.layer.cornerRadius = 4
        view.isHidden = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        backgroundColor = ColorSystem.surface
        selectionStyle = .none
        
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(unreadIndicator)
        
        iconContainer.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.size.equalTo(40)
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalTo(iconContainer.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(dateLabel.snp.leading).offset(-8)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        unreadIndicator.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel.snp.leading).offset(-8)
            make.size.equalTo(8)
        }
    }
    
    func configure(with notification: Domain.Notification) {
        titleLabel.text = notification.title
        messageLabel.text = notification.message
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        dateLabel.text = formatter.string(from: notification.date)
        
        unreadIndicator.isHidden = notification.isRead
        
        switch notification.type {
        case .info:
            iconContainer.backgroundColor = ColorSystem.secondary
            iconView.image = UIImage(systemName: "info.circle.fill")
        case .success:
            iconContainer.backgroundColor = ColorSystem.success
            iconView.image = UIImage(systemName: "checkmark.circle.fill")
        case .warning:
            iconContainer.backgroundColor = .systemOrange
            iconView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        case .alert:
            iconContainer.backgroundColor = ColorSystem.error
            iconView.image = UIImage(systemName: "exclamationmark.circle.fill")
        }
    }
}
