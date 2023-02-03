//
//  UIButton.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit

extension UIButton {
    func configImage(image: UIImage) {
        self.setImage(image, for: .normal)
        self.setImage(image, for: .highlighted)
    }
    
    func configColor(tintColor: UIColor, textColor: UIColor) {
        self.tintColor = tintColor
        self.setTitleColor(textColor, for: .selected)
        self.setTitleColor(textColor, for: .normal)
    }
}

