import ProjectDescription

/// Module types for the Madabank app
public enum ModuleType {
    case shared
    case feature
}

/// All modules in the Madabank app
public enum Module: String, CaseIterable {
    // Shared modules
    case core = "Core"
    case networking = "Networking"
    case domain = "Domain"
    case data = "Data"
    case commonUI = "CommonUI"
    
    // Feature modules
    case auth = "Auth"
    case home = "Home"
    case accounts = "Accounts"
    case cards = "Cards"
    case transactions = "Transactions"
    case profile = "Profile"
    
    public var name: String {
        return rawValue
    }
    
    public var type: ModuleType {
        switch self {
        case .core, .networking, .domain, .data, .commonUI:
            return .shared
        case .auth, .home, .accounts, .cards, .transactions, .profile:
            return .feature
        }
    }
    
    public var path: String {
        switch type {
        case .shared:
            return "Modules/Shared/\(rawValue)"
        case .feature:
            return "Modules/Features/\(rawValue)"
        }
    }
    
    public var targetName: String {
        return rawValue
    }
    
    public var bundleIdSuffix: String {
        return rawValue.lowercased()
    }
    
    /// Dependencies for each module
    public var dependencies: [Module] {
        switch self {
        // Shared modules
        case .core:
            return []
        case .networking:
            return [.core]
        case .domain:
            return [.core]
        case .data:
            return [.domain, .networking]
        case .commonUI:
            return [.core]
            
        // Feature modules
        case .auth:
            return [.domain, .data, .commonUI]
        case .home:
            return [.domain, .data, .commonUI]
        case .accounts:
            return [.domain, .data, .commonUI]
        case .cards:
            return [.domain, .data, .commonUI]
        case .transactions:
            return [.domain, .data, .commonUI]
        case .profile:
            return [.domain, .data, .commonUI]
        }
    }
    
    /// External package dependencies
    public var externalDependencies: [String] {
        switch self {
        case .core:
            return []
        case .networking:
            return ["Alamofire"]
        case .domain:
            return []
        case .data:
            return []
        case .commonUI:
            return ["SnapKit", "RxSwift", "RxCocoa"]
        case .auth, .home, .accounts, .cards, .transactions, .profile:
            return ["RxSwift", "RxCocoa"]
        }
    }
    
    public static var sharedModules: [Module] {
        return allCases.filter { $0.type == .shared }
    }
    
    public static var featureModules: [Module] {
        return allCases.filter { $0.type == .feature }
    }
}
