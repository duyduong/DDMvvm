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
        .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/Action", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/Alamofire/Alamofire", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/Alamofire/AlamofireImage", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/PureLayout/PureLayout", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/ra1028/DifferenceKit", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(name: "DDMvvm", dependencies: [
            "RxSwift",
            .product(name: "RxCocoa", package: "RxSwift"),
            "Action",
            "Alamofire",
            "AlamofireImage",
            "PureLayout",
            "DifferenceKit"
        ])
    ],
    swiftLanguageVersions: [.v5]
)
