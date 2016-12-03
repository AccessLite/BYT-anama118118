//
//  FoaasOperation.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 11/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation
import UIKit

enum FoaasOperationModelParseError: Error {
    // your naming here needs adjustment
    // if it's an error, i would name it something more like:
    // invalidJson
    // invalidFoaasOperation
    case validJson
    case validFoaasOperation
}

class FoaasOperation: JSONConvertible, DataConvertible{
    var name: String = ""
    var url: String = ""
    var fields: [FoaasField] = []
    
    static var cellIdentifier = "FoaasOperationCellIdentifier"
    
    required init?(json: [String : AnyObject]){
        guard let name = json["name"] as? String,
            let url = json["url"] as? String,
            let fields = json["fields"] as? [[String : AnyObject]]
            else {
                return nil
        }
        
        var arrayOfFields: [FoaasField] = []
        fields.forEach({ (field) in
            if let eachfield = FoaasField(json: field){
                arrayOfFields.append(eachfield)
            }
        })
        
        self.name = name
        self.url = url
        self.fields = arrayOfFields
    }
    
    func toJson() -> [String : AnyObject]{
        return [  "name": self.name as AnyObject,
                  "url": self.url as AnyObject,
                  "fields": self.fields.map{ $0.toJson() }as AnyObject ]
    }
    
    required init? (data: Data){
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dict = json as? [String : AnyObject] else {
                throw FoaasOperationModelParseError.validJson
            }
            
            guard let validFoaasOperation = FoaasOperation(json: dict) else {
                throw FoaasOperationModelParseError.validFoaasOperation
            }
            
            self.fields = validFoaasOperation.fields
            self.name = validFoaasOperation.name
            self.url = validFoaasOperation.url
        }catch FoaasOperationModelParseError.validJson {
            print("Pring error in parsing validJson")
        } catch {
            print(error)
        }
    }
    
    func toData() throws -> Data{
        return try JSONSerialization.data(withJSONObject: self.toJson(), options: [])
    }
}
