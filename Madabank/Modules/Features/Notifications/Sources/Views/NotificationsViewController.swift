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
    private lazy var emptyStateView: MBEmptyStateView = {
        let view = MBEmptyStateView(
            image: UIImage(systemName: "bell.slash"),
            title: "Notifications Disabled",
            message: "This feature is currently unavailable.",
            buttonTitle: nil
        )
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
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "Notifications"
        view.backgroundColor = ColorSystem.background
        
        view.addSubview(emptyStateView)
        
        emptyStateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
}

// MARK: - NotificationCell Stub
final class NotificationCell: UITableViewCell {
    func configure(with notification: Domain.Notification) {}
}
