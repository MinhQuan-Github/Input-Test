//
//  BaseManager.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit
import Alamofire
import ObjectMapper

class BaseManager: NSObject {
    
    func header() -> HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "charset": "utf-8"
        ]
    }
    
    func get(url: String,
             params: [String: Any]? = nil,
             completion: @escaping (IPTResponseModel) -> Void) {
        print(url)
        if url.isEmpty {
            completion(IPTResponseModel.errorURL())
        } else {
            let requestURL = IPTURLConstant.getInstance.domain + url
            print(requestURL)
            Alamofire.request(requestURL, method: .get, parameters: params, headers: self.header()).responseJSON(completionHandler: { (response) in
                let responseValue = response.result.value
                self.parseData(responseValue: responseValue, statusCode: response.response?.statusCode ?? 200, completion: completion)
            })
        }
    }
    
    func parseData(responseValue: Any?,
                   statusCode: Int,
                   completion: @escaping (IPTResponseModel) -> Void) {
        if statusCode == 200 {
            if responseValue != nil {
                if responseValue is [String: Any] {
                    let data = Mapper<IPTResponseModel>().map(JSON: responseValue as! [String: Any])
                    completion(data!)
                } else if responseValue is [Any] {
                    let response = IPTResponseModel()
                    response.status = 200
                    response.data = responseValue
                    completion(response)
                } else {
                    completion(IPTResponseModel.errorData())
                }
            } else {
                completion(IPTResponseModel.errorData())
            }
        }
    }
}
