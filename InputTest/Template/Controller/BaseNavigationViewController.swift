//
//  BaseNavigationViewController.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = false
        self.navigationBar.titleTextAttributes = ([kCTFontAttributeName: UIFont.boldSystemFont(ofSize: 16.0),
                                        kCTForegroundColorAttributeName: UIColor.gray,
                                                   NSAttributedString.Key.foregroundColor: UIColor.gray] as! [NSAttributedString.Key: Any])
        self.navigationBar.tintColor = UIColor.gray
        self.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.backIndicatorImage = UIImage.init(named: "ic_back")
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage.init(named: "ic_back")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension UINavigationController {
    
    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}
