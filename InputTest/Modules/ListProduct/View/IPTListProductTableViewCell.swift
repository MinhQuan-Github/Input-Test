//
//  IPTListProductTableViewCell.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit
import SDWebImage

class IPTListProductTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var productImageVỉew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    static let identifier = "IPTListProductTableViewCell"
    var productModel: IPTProductModel!
    var showEdit: Bool = true
    
    func config(productModel: IPTProductModel, showEdit: Bool = true) {
        self.productModel = productModel
        self.showEdit = showEdit
        self.configData()
        self.configUI()
    }
    
    func configData(){
        if self.productModel.image == "" {
            self.productImageVỉew.image = Image.imageDefault
        } else {
            self.productImageVỉew.sd_setImage(with: URL(string: self.productModel.image))
        }
        self.nameLabel.text = self.productModel.name
        self.errorDescriptionLabel.text = self.productModel.getErrorString()
        self.skuLabel.text = self.productModel.getSkuString()
        self.colorLabel.text = self.productModel.getColorString()
    }
    
    func configUI() {
        self.mainView.roundCorners(corners: [.bottomLeft, .bottomRight, .topLeft, .topRight], amount: 8)
        self.mainView.setBlurShadow()
        if showEdit {
            self.editButton.isHidden = false
            self.editButton.isUserInteractionEnabled = true
            self.editButton.setTitle("", for: .normal)
            self.editButton.setTitle("", for: .selected)
        } else {
            self.editButton.isHidden = true
            self.editButton.isUserInteractionEnabled = false
        }
        self.productImageVỉew.roundCorners(corners: [.bottomLeft, .bottomRight, .topLeft, .topRight], amount: 5)
    }
}
