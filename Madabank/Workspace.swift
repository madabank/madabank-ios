import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(
    name: "Madabank",
    projects: [
        // Main app
        ".",
        
        // Shared modules
        "Modules/Shared/Core",
        "Modules/Shared/Networking",
        "Modules/Shared/Domain",
        "Modules/Shared/Data",
        "Modules/Shared/CommonUI",
        
        // Feature modules
        "Modules/Features/Auth",
        "Modules/Features/Home",
        "Modules/Features/Accounts",
        "Modules/Features/Cards",
        "Modules/Features/Transactions",
        "Modules/Features/Profile"
    ],
    schemes: [
        .scheme(
            name: "Madabank-All",
            shared: true,
            buildAction: .buildAction(targets: [
                .project(path: ".", target: "Madabank")
            ]),
            testAction: .targets([
                .testableTarget(target: .project(path: ".", target: "MadabankTests")),
                .testableTarget(target: .project(path: ".", target: "MadabankUITests")),
                // Shared Modules
                .testableTarget(target: .project(path: "Modules/Shared/Core", target: "CoreTests")),
                .testableTarget(target: .project(path: "Modules/Shared/Networking", target: "NetworkingTests")),
                .testableTarget(target: .project(path: "Modules/Shared/Domain", target: "DomainTests")),
                .testableTarget(target: .project(path: "Modules/Shared/Data", target: "DataTests")),
                .testableTarget(target: .project(path: "Modules/Shared/CommonUI", target: "CommonUITests")),
                // Feature Modules
                .testableTarget(target: .project(path: "Modules/Features/Auth", target: "AuthTests")),
                .testableTarget(target: .project(path: "Modules/Features/Home", target: "HomeTests")),
                .testableTarget(target: .project(path: "Modules/Features/Accounts", target: "AccountsTests")),
                .testableTarget(target: .project(path: "Modules/Features/Cards", target: "CardsTests")),
                .testableTarget(target: .project(path: "Modules/Features/Transactions", target: "TransactionsTests")),
                .testableTarget(target: .project(path: "Modules/Features/Profile", target: "ProfileTests")),
                .testableTarget(target: .project(path: "Modules/Features/Notifications", target: "NotificationsTests"))
            ]),
            runAction: .runAction(
                configuration: .debug,
                executable: .project(path: ".", target: "Madabank")
            )
        )
    ],
    generationOptions: .options(
        enableAutomaticXcodeSchemes: false
    )
)
