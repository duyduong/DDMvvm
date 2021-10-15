//
//  AppDelegate.swift
//  DDMvvm
//
//  Created by dduy.duong@gmail.com on 09/25/2018.
//  Copyright (c) 2018 dduy.duong@gmail.com. All rights reserved.
//

import UIKit
import DDMvvm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    DependencyManager.shared.registerDefaults()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    let page = ExampleMenuPage(viewModel: HomeMenuPageViewModel())
    let rootPage = NavigationPage(rootViewController: page)
    rootPage.navigationBar.tintColor = .systemBlue
    window?.rootViewController = rootPage
    window?.makeKeyAndVisible()
    
    return true
  }
}


