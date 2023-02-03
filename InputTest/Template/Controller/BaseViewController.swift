//
//  BaseViewController.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit
import RxSwift
import KRProgressHUD

class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    var emptyLabelView: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: Progress HUD
extension BaseViewController {
    func showLoadingView() {
        KRProgressHUD.show()
    }

    func hideLoadingView() {
        KRProgressHUD.dismiss()
    }
}

// MARK: KEYBOARD
extension BaseViewController {
    func dimissKeyboard () {
        self.view.endEditing(true)
    }
}

// MARK: TABLEVIEW
extension BaseViewController {
    func setEmpty(text: String) {
        self.emptyLabelView = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        self.emptyLabelView?.textAlignment = .center
        self.emptyLabelView?.font = UIFont.systemFont(ofSize: 13.0)
        self.emptyLabelView?.textColor = UIColor.lightGray
        self.emptyLabelView?.text = text
    }
    
    func setEmptyView(tableView: UITableView!, data: [Any], text: String) {
        if data.isEmpty {
            if self.emptyLabelView == nil {
                self.setEmpty(text: text)
                tableView.addSubview(self.emptyLabelView!)
            }
        } else {
            if self.emptyLabelView != nil {
                self.emptyLabelView?.removeFromSuperview()
                self.emptyLabelView = nil
            }
        }
    }
}

// MARK: ALERT
extension BaseViewController {
    func showAlert(message: String, completion: @escaping () -> Void) {
        let viewController = IPTAlertPopupViewController(titleText: "INPUT TEST", contentText: message, titleButton1Text: "OK") { (_) in
            completion()
        }
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
    }
}
