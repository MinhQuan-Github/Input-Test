//
//  IPTLostConnectionViewController.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit
import Alamofire

class IPTLostConnectionViewController: UIViewController {
    
    @IBOutlet weak var noConnectionLabel: UILabel!
    @IBOutlet weak var retryLabel: UILabel!
    @IBOutlet weak var retryView: UIView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var retryImageView: UIImageView!
    var isInitData: Bool! = false

    convenience init(withInitData: Bool) {
        self.init()
        self.isInitData = withInitData
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.retryView.layer.borderWidth = 1.0
        self.retryView.layer.borderColor = UIColor.init(white: 104.0/255.0, alpha: 1.0).cgColor
        self.retryView.layer.cornerRadius = 5.0
        self.activityView.isHidden = true
        self.retryImageView.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.retryLabel.text = "Retry"
        self.noConnectionLabel.text = "NO NETWORK CONNECTION"
    }

    @IBAction func pressRetry(_ sender: UIButton) {
        self.activityView.isHidden = false
        self.retryImageView.isHidden = true
        self.retryLabel.text = "Connecting"

        if NetworkReachabilityManager()!.isReachable {
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(connectSuccess), userInfo: nil, repeats: false)
        } else {
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(connectFail), userInfo: nil, repeats: false)
        }
    }

    @objc func connectSuccess() {
        self.activityView.isHidden = true
        self.retryImageView.isHidden = false
        self.retryLabel.text = "Retry"
        let vc = BaseNavigationViewController(rootViewController: IPTListProductViewController())
        IPTRootWindowService.getInstance.switchRootViewController(viewController: vc, animated: true, completion: nil)
    }

    @objc func connectFail() {
        self.activityView.isHidden = true
        self.retryImageView.isHidden = false
        self.retryLabel.text = "Retry"
    }
}
