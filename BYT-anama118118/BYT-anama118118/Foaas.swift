//
//  Foaas.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 11/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation
import UIKit

enum FoaasModelParseError: Error {
    case validJson
}

class Foaas: JSONConvertible, CustomStringConvertible{
    var message: String
    var subtitle: String
    
    public var description: String {
        get{
            return "\(message) \(subtitle)"
        }
    }
    
    required init?(json: [String : AnyObject]){
        if let message = json["message"] as? String,
            let subtitle = json["subtitle"] as? String {
            self.message = message
            self.subtitle = subtitle
        } else {
            return nil
        }
    }
    
    func toJson() -> [String : AnyObject]{
        return [ "message": self.message as AnyObject,
                 "subtitle": self.subtitle as AnyObject ]
    }
}

// Enpoint: /awesome/:from
// GET http://www.foaas.com/awesome/louis
//{
//    "message": "This is Fucking Awesome.",
//    "subtitle": "- louis"
//}
