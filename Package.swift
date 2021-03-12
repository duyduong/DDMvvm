// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DDMvvm",
    defaultLocalization: "en",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "DDMvvm", targets: ["DDMvvm"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", .exact("5.1.1")),
        .package(url: "https://github.com/Alamofire/Alamofire", .exact("5.2.0")),
        .package(url: "https://github.com/Alamofire/AlamofireImage", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/PureLayout/PureLayout", .exact("3.1.7")),
        .package(url: "https://github.com/ra1028/DifferenceKit", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(name: "DDMvvm", dependencies: [
            "RxSwift",
            .product(name: "RxCocoa", package: "RxSwift"),
            "Alamofire",
            "AlamofireImage",
            "PureLayout",
            "DifferenceKit"
        ])
    ],
    swiftLanguageVersions: [.v5]
)
