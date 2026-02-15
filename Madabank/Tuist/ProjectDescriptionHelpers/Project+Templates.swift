import ProjectDescription

// MARK: - Project Templates

public extension Project {
    
    /// Creates the main Madabank app project
    static func app(
        name: String,
        destinations: Destinations = [.iPhone],
        deploymentTargets: DeploymentTargets = .iOS("15.0"),
        dependencies: [TargetDependency]
    ) -> Project {
        return Project(
            name: name,
            options: .options(
                automaticSchemesOptions: .disabled,
                textSettings: .textSettings(usesTabs: false, indentWidth: 4, tabWidth: 4)
            ),
            settings: .settings(base: [
                "SWIFT_STRICT_CONCURRENCY": "complete",
                "CURRENT_PROJECT_VERSION": "1",
                "MARKETING_VERSION": "1.0",
                "VERSIONING_SYSTEM": "apple-generic",
                "DEVELOPMENT_TEAM": "Q99UJS4WY6"
            ]),
            targets: [
                .target(
                    name: name,
                    destinations: destinations,
                    product: .app,
                    bundleId: "online.darisadam.\(name.lowercased())",
                    deploymentTargets: deploymentTargets,
                    infoPlist: .extendingDefault(with: [
                        "UILaunchScreen": [
                            "UIColorName": "LaunchBackground",
                            "UIImageName": "LaunchLogo",
                        ],
                        "UIApplicationSceneManifest": [
                            "UIApplicationSupportsMultipleScenes": false,
                            "UISceneConfigurations": [
                                "UIWindowSceneSessionRoleApplication": [[
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ]]
                            ]
                        ],
                        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
                        "CFBundleDisplayName": "Madabank",
                        "NSAppTransportSecurity": [
                            "NSAllowsArbitraryLoads": true
                        ],
                        "NSCameraUsageDescription": "Madabank needs camera access to scan QR codes for payments.",
                        "NSFaceIDUsageDescription": "Madabank uses FaceID to securely log you in.",
                        "ITSAppUsesNonExemptEncryption": false
                    ]),
                    sources: ["Madabank/Sources/**"],
                    resources: ["Madabank/Resources/**"],
                    scripts: [
                        .pre(
                            script: """
                                if which swiftlint >/dev/null; then
                                  swiftlint
                                else
                                  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
                                fi
                                """,
                            name: "SwiftLint",
                            basedOnDependencyAnalysis: false
                        )
                    ],
                    dependencies: dependencies
                ),
                .target(
                    name: "\(name)Tests",
                    destinations: destinations,
                    product: .unitTests,
                    bundleId: "online.darisadam.\(name.lowercased()).tests",
                    deploymentTargets: deploymentTargets,
                    infoPlist: .default,
                    sources: ["Madabank/Tests/**"],
                    dependencies: [.target(name: name)]
                ),
                .target(
                    name: "\(name)UITests",
                    destinations: destinations,
                    product: .uiTests,
                    bundleId: "online.darisadam.\(name.lowercased()).uitests",
                    deploymentTargets: deploymentTargets,
                    infoPlist: .default,
                    sources: ["Madabank/UITests/**"],
                    dependencies: [.target(name: name)]
                )
            ],
            schemes: [
                // Prod Scheme (Release)
                .scheme(
                    name: "\(name) (Prod)",
                    shared: true,
                    buildAction: .buildAction(targets: [.target(name)]),
                    runAction: .runAction(configuration: .release, executable: .target(name))
                ),
                .scheme(
                    name: name,
                    shared: true,
                    buildAction: .buildAction(targets: [.target(name)]),
                    testAction: .targets([
                        .testableTarget(target: .target("\(name)Tests")),
                        .testableTarget(target: .target("\(name)UITests"))
                    ]),
                    runAction: .runAction(configuration: .debug, executable: .target(name))
                )
            ]
        )
    }
    
    /// Creates a framework module project
    static func framework(
        module: Module,
        destinations: Destinations = [.iPhone],
        deploymentTargets: DeploymentTargets = .iOS("15.0")
    ) -> Project {
        let moduleDependencies: [TargetDependency] = module.dependencies.map { .project(target: $0.targetName, path: .relativeToRoot($0.path)) }
        let externalDependencies: [TargetDependency] = module.externalDependencies.map { .external(name: $0) }
        
        return Project(
            name: module.targetName,
            options: .options(
                automaticSchemesOptions: .disabled,
                textSettings: .textSettings(usesTabs: false, indentWidth: 4, tabWidth: 4)
            ),
            settings: .settings(base: ["SWIFT_STRICT_CONCURRENCY": "complete"]),
            targets: [
                .target(
                    name: module.targetName,
                    destinations: destinations,
                    product: .framework,
                    bundleId: "online.darisadam.\(module.bundleIdSuffix)",
                    deploymentTargets: deploymentTargets,
                    infoPlist: .default,
                    sources: ["\(module.path)/Sources/**"],
                    resources: ["\(module.path)/Resources/**"],
                    dependencies: moduleDependencies + externalDependencies
                ),
                .target(
                    name: "\(module.targetName)Tests",
                    destinations: destinations,
                    product: .unitTests,
                    bundleId: "online.darisadam.\(module.bundleIdSuffix).tests",
                    deploymentTargets: deploymentTargets,
                    infoPlist: .default,
                    sources: ["\(module.path)/Tests/**"],
                    dependencies: [.target(name: module.targetName)]
                )
            ],
            schemes: [
                .scheme(
                    name: module.targetName,
                    shared: true,
                    buildAction: .buildAction(targets: [.target(module.targetName)]),
                    testAction: .targets([.testableTarget(target: .target("\(module.targetName)Tests"))])
                )
            ]
        )
    }
}

// MARK: - Target Dependency Extensions

public extension TargetDependency {
    static func module(_ module: Module) -> TargetDependency {
        return .project(target: module.targetName, path: .relativeToRoot(module.path))
    }
}
