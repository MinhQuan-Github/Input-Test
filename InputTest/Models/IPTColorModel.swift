//
//  IPTColorModel.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit
import ObjectMapper

class IPTColorModel: Mappable {
    var id: Int                  = 0
    var name: String             = ""
    
    init() {
        
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                       <- map["id"]
        name                     <- map["name"]
    }
}
