//
//  IPTRootWindowService.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

class IPTRootWindowService: NSObject, UIApplicationDelegate {
    static let getInstance = IPTRootWindowService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! IPTAppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.backgroundColor = UIColor.white
        self.setupKeyboard()
        self.initProgram()
        appDelegate.window?.makeKeyAndVisible()
        return true
    }
    
    private func setupKeyboard() {
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.overrideKeyboardAppearance = true
        IQKeyboardManager.shared.keyboardAppearance = .light
    }
    
    private func initProgram() {
        if NetworkReachabilityManager()!.isReachable {
            // start view
            self.initData()
        } else {
            // lost connect
            self.switchRootViewController(viewController: IPTLostConnectionViewController.init(withInitData: true), animated: true, completion: nil)
        }
    }
    
    private func initData() {
        let vc = BaseNavigationViewController(rootViewController: IPTListProductViewController())
        self.switchRootViewController(viewController: vc, animated: true, completion: nil)
    }
    
    public func switchRootViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let appDelegate = UIApplication.shared.delegate as! IPTAppDelegate
        if animated == true {
            UIView.transition(with: (appDelegate.window)!, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                appDelegate.window?.rootViewController = viewController
            }, completion: { _ in
                completion?()
            })
        } else {
            appDelegate.window?.rootViewController = viewController
        }
        appDelegate.window?.makeKeyAndVisible()
    }
}
