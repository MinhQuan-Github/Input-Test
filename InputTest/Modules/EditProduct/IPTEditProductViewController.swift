//
//  IPTEditProductViewController.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit
import RxSwift
import RxRelay
import IQKeyboardManagerSwift

@available(iOS 15.0, *)
class IPTEditProductViewController: BaseViewController {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var productImageVỉew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.layer.cornerRadius =  5
            nameTextField.layer.borderColor = UIColor.black.cgColor
            nameTextField.layer.borderWidth = 1
            let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
            nameTextField.leftView = leftView
            nameTextField.leftViewMode = .always
        }
    }
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var skuTextField: UITextField! {
        didSet {
            skuTextField.layer.cornerRadius =  5
            skuTextField.layer.borderColor = UIColor.black.cgColor
            skuTextField.layer.borderWidth = 1
            let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
            skuTextField.leftView = leftView
            skuTextField.leftViewMode = .always
        }
    }
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorPopupButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    var productModel: IPTProductModel!
    var completion: ((_ model: IPTProductModel, _ hasChanged: Bool) -> Void)?
    var originName: String?
    var originSku: String?
    var originColor: String?
    
    convenience init(productModel: IPTProductModel, originModel: IPTProductModel, completion: @escaping (_ model: IPTProductModel, _ hasChanged: Bool) -> Void) {
        self.init()
        self.productModel = productModel
        self.originName = originModel.name
        self.originSku = originModel.sku
        self.originColor = originModel.colorString()
        self.completion = completion
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.initUI()
        self.setPopupButton()
    }
    
    private func initData() {
//        self.originProductModel = IPTProductManager.getInstance.products.value.first { (product) in
//            product.id == productModel.id
//        }!
        self.idLabel.attributedText = self.productModel.getIdAttribute()
        if self.productModel.image == "" {
            self.productImageVỉew.image = Image.imageDefault
        } else {
            self.productImageVỉew.sd_setImage(with: URL(string: self.productModel.image))
        }
        self.nameTextField.text = self.productModel.name
        self.errorDescriptionLabel.attributedText = self.productModel.getErrorAttribute()
        self.skuTextField.text = self.productModel.sku
        self.changeButtonColor(button: self.colorPopupButton, title: self.productModel.colorString())
    }
    
    private func initUI() {
        self.title = "Product"
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.overrideKeyboardAppearance = true
        IQKeyboardManager.shared.keyboardAppearance = .light
        self.productImageVỉew.roundCorners(corners: [.topRight, .topLeft, .bottomRight, .bottomLeft], amount: 8)
        self.updateButton.roundCorners(corners: [.topRight, .topLeft, .bottomRight, .bottomLeft], amount: 8)
        self.updateButton.layer.opacity = 0.5
        self.updateButton.isUserInteractionEnabled = false
        self.nameTextField.delegate = self
        self.skuTextField.delegate = self
    }
    
    private func setPopupButton() {
        let optionClosure = { (action: UIAction) in
            DispatchQueue.main.async {
                self.changeButtonColor(button: self.colorPopupButton, title: action.title)
            }
            self.checkHasChange(title: action.title)
        }
        var actions: [UIAction] = IPTColorManager.getInstance.colors.value.map { (color) in
            UIAction(title: color.name,
                     state: (self.productModel.color == color.id) ? .on : .off,
                     handler: optionClosure)
        }
        
        actions.append(
            UIAction(title: "None",
                     state: (self.productModel.color == 0) ? .on : .off,
                     handler: optionClosure)
        )
        self.colorPopupButton.menu = UIMenu(children: actions)
        self.colorPopupButton.showsMenuAsPrimaryAction = true
        self.colorPopupButton.changesSelectionAsPrimaryAction = true
        self.colorPopupButton.layer.borderColor = UIColor.black.cgColor
        self.colorPopupButton.layer.borderWidth = 1.0
    }
    
    private func changeButtonColor(button: UIButton, title: String) {
        switch title {
        case "White":
            button.configColor(tintColor: .white, textColor: .black)
        case "Black":
            button.configColor(tintColor: .black, textColor: .white)
        case "Red":
            button.configColor(tintColor: .red, textColor: .white)
        case "Green":
            button.configColor(tintColor: .green, textColor: .black)
        case "Blue":
            button.configColor(tintColor: .blue, textColor: .white)
        case "Yellow":
            button.configColor(tintColor: .yellow, textColor: .black)
        default:
            button.configColor(tintColor: .clear, textColor: .black)
        }
    }
    
    private func isDifferentFromOrigin() -> Bool {
        if self.originName != self.nameTextField.text || self.originSku != self.skuTextField.text || self.originColor != self.colorPopupButton.titleLabel?.text {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func updateTapped(_ sender: UIButton) {
        // check count of name
        guard
            let count = self.nameTextField.text?.count, count <= 50, count > 0
        else {
            self.showAlert(message: "Tên sản phẩm là bắt buộc, độ dài tối đa 50 ký tự.") {}
            return
        }
        
        // check sku of name
        guard
            let count = self.skuTextField.text?.count, count <= 20, count > 0
        else {
            self.showAlert(message: "SKU là bắt buộc, độ dài tối đa 20 ký tự.") {}
            return
        }
        self.productModel.name = self.nameTextField.text ?? ""
        self.productModel.sku  = self.skuTextField.text ?? ""
        self.productModel.color = IPTColorManager.getInstance.getIdByName(name: self.colorPopupButton.titleLabel?.text ?? "None")
        self.completion!(productModel, self.isDifferentFromOrigin())
        self.navigationController?.popViewController(animated: true)
    }
    
    private func checkHasChange(title: String = "") {
        let colorString = (title == "") ? self.colorPopupButton.titleLabel?.text : title
        if self.nameTextField.text == self.productModel.name && self.skuTextField.text == self.productModel.sku && colorString == self.productModel.colorString() {
            self.updateButton.layer.opacity = 0.5
            self.updateButton.isUserInteractionEnabled = false
        } else {
            self.updateButton.layer.opacity = 1.0
            self.updateButton.isUserInteractionEnabled = true
        }
    }
}

@available(iOS 15.0, *)
extension IPTEditProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.checkHasChange()
    }
}
