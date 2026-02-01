import UIKit
import CommonUI
import SnapKit
import Domain

public class SplashViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MadaBank"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = ColorSystem.primary
        label.textAlignment = .center
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = ColorSystem.primary
        return indicator
    }()
    private let retryButton: MBButton = {
        let button = MBButton(title: "Retry")
        button.isHidden = true
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    var onCheckStatus: (() async -> SystemStatus)?
    var onSuccess: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkStatus()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(loadingIndicator)
        view.addSubview(errorLabel)
        view.addSubview(retryButton)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(loadingIndicator.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
        }
    }
    
    private func setupActions() {
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
    }
    
    @objc private func didTapRetry() {
        resetUI()
        checkStatus()
    }
    
    private func resetUI() {
        errorLabel.isHidden = true
        retryButton.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    private func checkStatus() {
        guard let check = onCheckStatus else { return }
        
        Task {
            let status = await check()
            await MainActor.run {
                handleStatus(status)
            }
        }
    }
    
    private func handleStatus(_ status: SystemStatus) {
        loadingIndicator.stopAnimating()
        
        switch status {
        case .healthy:
            onSuccess?()
        case .maintenance:
            showError("System Under Maintenance\nPlease try again later.")
        case .noInternet:
            showError("No Internet Connection\nPlease check your network.")
        case .unknown:
            showError("Unknown Error Occurred")
        }
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        retryButton.isHidden = false
    }
}
