//
//  IPTProductManager.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit
import RxRelay
import RxSwift
import ObjectMapper

class IPTProductManager: BaseManager {
    static let getInstance = IPTProductManager()
    
    var products = BehaviorRelay<[IPTProductModel]>(value: [])
    var productsDisplay = BehaviorRelay<[IPTProductModel]>(value: [])
    var productsOrigin: [IPTProductModel] = []
    
    public func fetchProducts() {
        let url: String = IPTURLConstant.getInstance.products
        let params: [String: Any] = [:]
        self.get(url: url,
                 params: params) { response in
            if response.status == 200 {
                let items = response.data as! [[String: Any]]
                var products: [IPTProductModel] = []
                
                items.forEach { item in
                    let product = Mapper<IPTProductModel>().map(JSON: item)
                    products.append(product!)
                }
                self.store(products: products)
            }
        }
    }
    
    func store(products: [IPTProductModel]) {
        self.productsOrigin = products
        self.products.accept(products)
    }
}
