import ProjectDescription
import ProjectDescriptionHelpers

// Main Madabank App Project
let project = Project.app(
    name: "Madabank",
    dependencies: [
        // Feature modules
        .module(.auth),
        .module(.home),
        .module(.accounts),
        .module(.cards),
        .module(.transactions),
        .module(.profile),
        .module(.notifications),
        
        // External dependencies for the main app
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "netfox"),
        .external(name: "IQKeyboardManagerSwift")
    ]
)
