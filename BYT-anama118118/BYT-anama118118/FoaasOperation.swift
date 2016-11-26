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
    case validJson
    case validFoaasOperation
}

class FoaasOperation: JSONConvertible, DataConvertible{
    var name: String = ""
    var url: String = ""
    var fields: [FoaasField] = []
    var FoassOperations: [FoaasOperation] = []
    static var endPoint = URL(string:"http://www.foaas.com/operations")!
    
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
        
        var fieldJson = [[String:String]]()
        self.fields.forEach { (field) in
            let foaasFieldJson = field.toJson()
            fieldJson.append(foaasFieldJson as! [String : String])
        }
        print(fieldJson)
        
        let json = ["name": self.name as AnyObject,
                    "url": self.url as AnyObject,
                    "fields": fieldJson as AnyObject]
        print(json)
        return json
    }
    
    required init? (data: Data){
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dict = json as? [[String: AnyObject]] else {
                throw FoaasOperationModelParseError.validJson
            }
            try dict.forEach({ (item) in
                guard let validFoaasOperation = FoaasOperation(json: item) else {
                    throw FoaasOperationModelParseError.validFoaasOperation
                }
                self.FoassOperations.append(validFoaasOperation)
            })
        }catch FoaasOperationModelParseError.validJson {
            print("Pring error in parsing validJson")
        } catch {
            print(error)
        }
    }
    
    func toData() throws -> Data{
        var fieldsBody = [[String: AnyObject]]()
        for field in self.fields {
            fieldsBody.append(field.toJson())
        }
        
        let foaasOperationBody : [String: AnyObject] =  ["name": self.name as AnyObject, "url": self.url as AnyObject, "fields": fieldsBody as AnyObject]
        var foaasOperationData: Data = Data()
        do {
            foaasOperationData = try JSONSerialization.data(withJSONObject: foaasOperationBody, options: [])
        }
        catch {
            print(error)
        }
        dump(foaasOperationData)
        return foaasOperationData
    }
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
