import ProjectDescription

let project = Project(
    name: "Madabank",
    targets: [
        .target(
            name: "Madabank",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.Madabank",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "Madabank/Sources",
                "Madabank/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "MadabankTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.MadabankTests",
            infoPlist: .default,
            buildableFolders: [
                "Madabank/Tests"
            ],
            dependencies: [.target(name: "Madabank")]
        ),
    ]
)
