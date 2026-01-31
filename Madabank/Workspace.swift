import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(
    name: "Madabank",
    projects: [
        // Main app
        ".",
        
        // Shared modules
        "Modules/Shared/Core",
        "Modules/Shared/Network",
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
                .testableTarget(target: .project(path: ".", target: "MadabankTests"))
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
