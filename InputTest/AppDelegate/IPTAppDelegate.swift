//
//  AppDelegate.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit

@UIApplicationMain
class IPTAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var services: [AnyObject] = [IPTRootWindowService.getInstance]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.services.forEach { service in
            _ = service.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        return true
    }
}

