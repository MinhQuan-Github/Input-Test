//
//  IPTURLConstant.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import Foundation

class IPTURLConstant: NSObject {
    
    static let getInstance = IPTURLConstant()
    
    let baseDomain = "https://hiring-test.stag.tekoapis.net"
    let domain     = "https://hiring-test.stag.tekoapis.net" + "/api"
    
    let products   = "/products"
    let colors     = "/colors"
}
