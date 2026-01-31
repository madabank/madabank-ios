// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "Madabank",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: .branch("master")),
        .package(url: "https://github.com/ReactiveX/RxSwift", from: .branch("main")),
        .package(url: "https://github.com/SnapKit/SnapKit", from: .branch("develop"))
    ]
)
