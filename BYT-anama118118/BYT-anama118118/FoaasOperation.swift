//
//  FoaasOperation.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 11/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation
import UIKit

class FoaasOperation: JSONConvertible/*, DataConvertible*/{
    var name: String = ""
    var url: String = ""
    var fields: [FoaasField] = []
    
    required init?(json: [String : AnyObject]){
        guard let name = json["name"] as? String,
            let url = json["url"] as? String,
            let fields = json["fields"] as? [[String:AnyObject]] else {
                return
        }
        var arrayOfFields = [FoaasField]()
        fields.forEach({ (field) in
            if let eachfield = FoaasField.init(json: field){
                arrayOfFields.append(eachfield)
            }
        })
        self.name = name
        self.url = url
        self.fields = arrayOfFields
    }
    
    func toJson() -> [String : AnyObject]{
        var fieldJson = [[String:AnyObject]]()
        self.fields.forEach { (field) in
            let foaasFieldJson = FoaasField.toJson(field)
            fieldJson.append(foaasFieldJson())
        }
        
        return ["name": self.name as AnyObject,
                "url": self.url as AnyObject,
                "fields": fieldJson as AnyObject
                ]
    }
    
    required init?(data: Data) {
    //next to do
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        
    }
    //    func toData() throws -> Data{
    //        return
    //    }
}

//Endpoint: /operations
//GET http://www.foaas.com/operations
//[
//{
//"name": "Awesome",
//"url": "/awesome/:from",
//"fields": [
//{
//"name": "From",
//"field": "from"
//}
//]
//},
//{ ... another operation ... },
//{ ... another operation ... }
//]
