// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [
            "Alamofire": .framework,
            "RxSwift": .framework,
            "RxCocoa": .framework,
            "RxRelay": .framework,
            "SnapKit": .framework
        ]
    )
#endif

let package = Package(
    name: "Madabank",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.9.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.7.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.7.0")
    ]
)
