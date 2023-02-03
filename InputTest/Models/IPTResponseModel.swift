//
//  IPTResponseModel.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit
import ObjectMapper

class IPTResponseModel: Mappable {
    var data: Any!
    var message: String! = ""
    var status: Int! = 0
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data     <- map["data"]
        message  <- map["error"]
        status   <- map["status"]
    }
    
    static func errorURL() -> IPTResponseModel {
        let response = IPTResponseModel()
        response.status = 0
        response.message = "URL inncorrect"
        response.data = NSNull()
        return response
    }

    static func errorData(text: String = "") -> IPTResponseModel {
        let response = IPTResponseModel()
        response.status = 0
        response.message = "Sorry we are having issue. Please try again later."
        response.data = NSNull()
        return response
    }
}
