//
//  IPTColorManager.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit
import RxRelay
import RxSwift
import ObjectMapper

class IPTColorManager: BaseManager {
    static let getInstance = IPTColorManager()
    
    var colors = BehaviorRelay<[IPTColorModel]>(value: [])
    
    public func fetchColors() {
        let url: String = IPTURLConstant.getInstance.colors
        let params: [String: Any] = [:]
        self.get(url: url,
                 params: params) { response in
            if response.status == 200 {
                let items = response.data as! [[String: Any]]
                var colors: [IPTColorModel] = []
                
                items.forEach { item in
                    let color = Mapper<IPTColorModel>().map(JSON: item)
                    colors.append(color!)
                }
                
                self.colors.accept(colors)
            }
        }
    }
    
    public func getIdByName(name: String) -> Int {
        return self.colors.value.first { color in
            color.name == name
        }?.id ?? 0
    }
}
