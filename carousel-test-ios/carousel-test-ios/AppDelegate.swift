//
//  AppDelegate.swift
//  carousel-test-ios
//
//  Created by Devin Abbott on 11/19/18.
//  Copyright © 2018 BitDisco, Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let viewController = ViewController.init(nibName: nil, bundle: nil)
    let navigationController = UINavigationController(rootViewController: viewController)

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.rootViewController = navigationController
    window.makeKeyAndVisible()

    self.window = window

    return true
  }

}

