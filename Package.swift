// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "DDMvvm",
  defaultLocalization: "en",
  platforms: [.iOS(.v11)],
  products: [
    .library(name: "DDMvvm", targets: ["DDMvvm"])
  ],
  dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift", .exact("6.1.0")),
    .package(url: "https://github.com/Alamofire/Alamofire", .exact("5.2.0")),
    .package(url: "https://github.com/Alamofire/AlamofireImage", .upToNextMajor(from: "4.0.0")),
    .package(url: "https://github.com/SnapKit/SnapKit", .exact("5.0.1"))
  ],
  targets: [
    .target(name: "DDMvvm", dependencies: [
      "RxSwift",
      .product(name: "RxCocoa", package: "RxSwift"),
      "Alamofire",
      "AlamofireImage",
      "SnapKit"
    ])
  ],
  swiftLanguageVersions: [.v5]
)
