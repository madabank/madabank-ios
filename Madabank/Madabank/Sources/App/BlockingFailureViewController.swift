import UIKit
import SnapKit
import CommonUI
import Domain

class BlockingFailureViewController: UIViewController {
    
    var onRetry: (() -> Void)?
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemRed // or .label
        return iv
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = Typography.body
        label.textColor = ColorSystem.textPrimary
        return label
    }()
    
    private let retryButton = MBButton(title: "Retry")
    
    private let status: SystemStatus
    
    init(status: SystemStatus) {
        self.status = status
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSystem.background // Full opacity to block interaction
        setupUI()
        configureContent()
    }
    
    private func setupUI() {
        view.addSubview(iconView)
        view.addSubview(messageLabel)
        view.addSubview(retryButton)
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-60)
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(140)
        }
        
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
    }
    
    private func configureContent() {
        switch status {
        case .maintenance:
            iconView.image = UIImage(systemName: "wrench.and.screwdriver.fill")
            messageLabel.text = "System Under Maintenance\n\nWe are currently performing scheduled maintenance. Please try again later."
        case .noInternet:
            iconView.image = UIImage(systemName: "wifi.slash")
            messageLabel.text = "No Internet Connection\n\nPlease check your network settings and try again."
        default:
            iconView.image = UIImage(systemName: "exclamationmark.triangle.fill")
            messageLabel.text = "An unknown error occurred."
        }
    }
    
    @objc private func retryTapped() {
        onRetry?()
    }
}
