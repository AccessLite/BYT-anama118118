//
//  FoaasField.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 11/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation
import UIKit

enum FoaasFieldModelParseError: Error {
    case validJson
}

class FoaasField: JSONConvertible, CustomStringConvertible {
    var name: String
    var field: String
    
    public var description: String {
        get{
            return "\(name) \(field)"
        }
    }
    
    required init?(json: [String : AnyObject]){
        if let name = json["name"] as? String,
            let field = json["field"] as? String {
            self.name = name
            self.field = field
        } else {
            return nil
        }
    }
    
    func toJson() -> [String : AnyObject]{
        return [ "name": self.name as AnyObject,
                 "field": self.field as AnyObject ]
    }
    
}

//"fields": [
//{
//"name": "From",
//"field": "from"
//}
//]
