//
//  IPTAlertPopupViewController.swift
//  InputTest
//
//  Created by Minh Quan on 07/01/2023.
//

import UIKit

class IPTAlertPopupViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var title1Button: UIButton!
    @IBOutlet weak var title2Button: UIButton!

    var completed: ((Int) -> Void)!
    var titleText: String!
    var contentText: String!
    var titleButton1Text: String!
    var titleButton2Text: String?

    convenience init(titleText: String,
                     contentText: String,
                     titleButton1Text: String,
                     titleButton2Text: String? = nil,
                     completed: @escaping ((Int) -> Void)) {
        self.init()
        self.completed = completed
        self.titleText = titleText
        self.contentText = contentText
        self.titleButton1Text = titleButton1Text
        self.titleButton2Text = titleButton2Text
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initData()
    }

    func initUI() {
        self.titleLabel.text = self.titleText
        self.contentLabel.text = self.contentText

        self.actionView.isHidden = self.titleButton2Text == nil

        self.titleButton.setTitle(titleButton1Text, for: .normal)
        self.titleButton.setTitle(titleButton1Text, for: .highlighted)

        self.title1Button.setTitle(titleButton1Text, for: .normal)
        self.title1Button.setTitle(titleButton1Text, for: .highlighted)

        self.title2Button.setTitle(titleButton2Text, for: .normal)
        self.title2Button.setTitle(titleButton2Text, for: .highlighted)
    }

    func initData() {

    }

    @IBAction func selectAction(sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.completed(sender.tag)
        })
    }
}
