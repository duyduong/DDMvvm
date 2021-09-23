# DDMvvm

[![CI Status](https://img.shields.io/travis/duyduong/DDMvvm.svg?style=flat)](https://travis-ci.org/duyduong/DDMvvm)
[![Version](https://img.shields.io/cocoapods/v/DDMvvm.svg?style=flat)](https://cocoapods.org/pods/DDMvvm)
[![License](https://img.shields.io/cocoapods/l/DDMvvm.svg?style=flat)](https://cocoapods.org/pods/DDMvvm)
[![Platform](https://img.shields.io/cocoapods/p/DDMvvm.svg?style=flat)](https://cocoapods.org/pods/DDMvvm)

DDMvvm is a library for who wants to start writing iOS application using MVVM (Model-View-ViewModel), written in Swift.

- [Features](#features)
- [Requirements](#requirements)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [Example](#example)
- [Usage](#usage)

## Features

- [x] Base classes for UIViewController, UIView, UITableViewCell and UICollectionCell
- [x] Base classes for ViewModel, ListViewModel and CellViewModel
- [x] Dependency injection using `Resolver`
- [x] Custom transitioning for UINavigationController and UIViewController

## Requirements
- iOS 11.0+
- Xcode 12.5+
- Swift 5.0+

## Dependencies
The library heavily depends on [RxSwift](https://github.com/ReactiveX/RxSwift) for data-binding and events. For who does not familiar with Reactive Programming, I suggest to start reading about it first. Beside that, here are the list of dependencies:
- [RxSwift](https://github.com/ReactiveX/RxSwift)
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [AlamofireImage](https://github.com/Alamofire/AlamofireImage)
- [SnapKit](https://github.com/SnapKit/SnapKit)

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'DDMvvm', '~> 3.0'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but Alamofire does support its use on supported platforms.

Once you have your Swift package set up, adding Alamofire as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/duyduong/DDMvvm.git", .upToNextMajor(from: "3.0.0"))
]
```

## Example

To run the example project, clone the repo, and run `DDMvvm.xcworkspace`

## Usage

### At the glance
The library is mainly written using Generic, so please familiar yourself with Swift Generic, and very important point, we can’t use Generic UIViewController to associate with UIViewController on InterfaceBuilder or Storyboard. So programmatically is prefer, but we can still use XIBs to instantiate our view

Please check examples for details usages of these base classes.

##### Injections
Using [Resolver](https://github.com/hmlongco/Resolver) for dependency injections

##### Page Transitions
The library also supports for page transitions, including pages inside a navigation page and pages that presents modally. See examples for how to implement page transitions

## License

DDMvvm is available under the MIT license. See the LICENSE file for more info.
