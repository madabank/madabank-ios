import ProjectDescription

let project = Project(
    name: "Notifications",
    targets: [
        .target(
            name: "Notifications",
            destinations: [.iPhone],
            product: .framework,
            bundleId: "online.darisadam.notifications",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../../Shared/Domain"),
                .project(target: "Data", path: "../../Shared/Data"),
                .project(target: "CommonUI", path: "../../Shared/CommonUI"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa")
            ]
        ),
        .target(
            name: "NotificationsTests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "online.darisadam.notifications.tests",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: "Notifications")]
        )
    ]
)
