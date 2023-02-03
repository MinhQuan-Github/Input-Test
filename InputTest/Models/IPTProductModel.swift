//
//  IPTProductModel.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit
import ObjectMapper

class IPTProductModel: Mappable {
    var id: Int                  = 0
    var errorDescription: String = ""
    var name: String             = ""
    var sku: String              = ""
    var image: String            = ""
    var color: Int               = 0
    
    init() {
        
    }
    
    init(id: Int, errorDescription: String, name: String, sku: String, image: String, color: Int) {
        self.id = id
        self.errorDescription = errorDescription
        self.name = name
        self.sku = sku
        self.image = image
        self.color = color
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                       <- map["id"]
        errorDescription         <- map["errorDescription"]
        name                     <- map["name"]
        sku                      <- map["sku"]
        image                    <- map["image"]
        color                    <- map["color"]
    }
    
    func colorString() -> String {
        if let colorString = IPTColorManager.getInstance.colors.value.first(where: { $0.id == self.color }) {
            return "\(colorString.name)"
        } else {
            return "None"
        }
    }
    
    func getColorString() -> String {
        if let colorString = IPTColorManager.getInstance.colors.value.first(where: { $0.id == self.color }) {
            return "Color: \(colorString.name)"
        } else {
            return "Color: None"
        }
    }
    
    func getErrorAttribute() -> NSMutableAttributedString {
        let boldText = "Error: "
        let normalText  = self.errorDescription

        let attributedString = NSMutableAttributedString(string: normalText)
        let boldString = NSMutableAttributedString(string: boldText, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])

        boldString.append(attributedString)
        return boldString
    }
    
    func getSkuString() -> String {
        return "Sku  : " + self.errorDescription
    }
    
    func getErrorString() -> String {
        return "Error: " + self.sku
    }
    
    func getIdAttribute() -> NSMutableAttributedString {
        let boldText = "ID   : "
        let normalText  = self.id.description

        let attributedString = NSMutableAttributedString(string: normalText)
        let boldString = NSMutableAttributedString(string: boldText, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])

        boldString.append(attributedString)
        return boldString
    }
}
