import UIKit
import SnapKit

/// Splash screen displayed on app launch
final class SplashViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let logoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        // Using SF Symbol as placeholder
        imageView.image = UIImage(systemName: "building.columns.fill")
        return imageView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Madabank"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.text = "Your trusted banking partner"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .label
        return indicator
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "Version 1.0.0"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Properties
    
    var onSplashComplete: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLogo()
        startLoading()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoContainerView)
        logoContainerView.addSubview(logoImageView)
        logoContainerView.addSubview(appNameLabel)
        logoContainerView.addSubview(taglineLabel)
        view.addSubview(activityIndicator)
        view.addSubview(versionLabel)
    }
    
    private func setupConstraints() {
        logoContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }
        
        taglineLabel.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoContainerView.snp.bottom).offset(40)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    // MARK: - Animation
    
    private func animateLogo() {
        logoContainerView.alpha = 0
        logoContainerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0.1,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            self.logoContainerView.alpha = 1
            self.logoContainerView.transform = .identity
        }
    }
    
    private func startLoading() {
        activityIndicator.startAnimating()
        
        // Simulate loading time (check auth, fetch initial data, etc.)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.onSplashComplete?()
        }
    }
}
