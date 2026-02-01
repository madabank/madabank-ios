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
    
    private var pollingTimer: Timer?
    
    private let errorContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground // Covers everything
        view.isHidden = true
        return view
    }()
    
    // UI Components moved to container where appropriate or keep separate
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopPolling()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(loadingIndicator)
        
        // Full screen error container
        view.addSubview(errorContainerView)
        errorContainerView.addSubview(errorLabel)
        errorContainerView.addSubview(retryButton)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        errorContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
        }
    }
    
    private func setupActions() {
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
    }
    
    @objc private func didTapRetry() {
        stopPolling()
        resetUI()
        checkStatus()
    }
    
    private func resetUI() {
        errorContainerView.isHidden = true
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
        
        switch status {
        case .healthy:
            stopPolling()
            loadingIndicator.stopAnimating()
            onSuccess?()
        case .maintenance:
            loadingIndicator.stopAnimating()
            showError("System Under Maintenance\nPlease try again later.")
            startPolling()
        case .noInternet:
            loadingIndicator.stopAnimating()
            showError("No Internet Connection\nPlease check your network.")
            startPolling()
        case .unknown:
            loadingIndicator.stopAnimating()
            showError("Unknown Error Occurred")
            startPolling()
        }
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorContainerView.isHidden = false
    }
    
    private func startPolling() {
        guard pollingTimer == nil else { return }
        pollingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.checkStatus()
        }
    }
    
    private func stopPolling() {
        pollingTimer?.invalidate()
        pollingTimer = nil
    }
}
