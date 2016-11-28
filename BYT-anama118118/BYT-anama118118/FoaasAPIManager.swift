//
//  APIRequestManager.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 11/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation
import UIKit

class FoaasAPIManager {
    internal static let manager: FoaasAPIManager = FoaasAPIManager()
    private init () {}
    private static let defaultSession = URLSession(configuration: .default)
    private static let operationsURL = URL(string: "https://www.foaas.com/operations")!
    static let foaasURL = URL(string: "http://www.foaas.com/awesome/louis")
    
    internal class func getFoaas(url: URL, completion: @escaping (Foaas?)->Void) {
        //http://www.foaas.com/awesome/louis
        //Need to use a GET request
        //Header key:Accept, value: application/json
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) { (data:Data?, request: URLResponse?, error: Error?) in
            if error != nil {
                print(error!)
            }
            guard let validData = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: [])
                guard let validJson = json as? [String: AnyObject] else {
                    throw FoaasModelParseError.validJson
                }
                completion(Foaas(json: validJson))
            }
            catch FoaasModelParseError.validJson {
                print("error in parsing valid json")
            }
            catch {
                print(error)
            }
        }.resume()
    }
    
    internal class func getOperations(completion: @escaping ([FoaasOperation]?)->Void) {
        defaultSession.dataTask(with: operationsURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!)
            }
            var foaasOperations: [FoaasOperation] = []
            guard let validData = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: [])
                guard let arrayOfDict = json as? [[String: AnyObject]] else { return }
                try arrayOfDict.forEach({ (item) in
                    let itemData = try JSONSerialization.data(withJSONObject: item, options: [])
                    guard let validFoaasOperation = FoaasOperation(data: itemData) else { return }
                    foaasOperations.append(validFoaasOperation)
                })
            }
            catch {
                print(error)
            }
            completion(foaasOperations)
            }.resume()
    }
    
    static func getData(endpoint: String, complete: @escaping (Data?) -> Void){
        guard let url = URL(string: endpoint) else { return }
        defaultSession.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!)
            }
            if data != nil {
                complete(data)
            }
            }.resume()
    }
}
