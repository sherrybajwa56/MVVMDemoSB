//
//  AppDelegate.swift
//  MVVMDemoSB
//
//  Created by Sherry Bajwa on 21/07/20.
//  Copyright © 2020 Sherry Bajwa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
     var appCoordinator: AppCoordinator?
     
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         window = UIWindow()
         appCoordinator = AppCoordinator(window: window!)
         appCoordinator?.start()
         return true
     }

}
