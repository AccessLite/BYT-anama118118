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
                print(error)
            }
            guard let validData = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: [])
                guard let validJson = json as? [String: AnyObject] else {
                    throw FoaasModelParseError.validJson
                }
                completion(Foaas.init(json: validJson))
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
        defaultSession.dataTask(with: FoaasOperation.endPoint) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error)
            }
            guard let validData = data else {return}
            guard let validFoaasOperationsArray = FoaasOperation(data: validData)?.FoassOperations else {return}
            completion(validFoaasOperationsArray)
            }.resume()
    }
    
    static func getData(endpoint: String, complete: @escaping (Data?) -> Void){
        guard let url = URL(string: endpoint) else {return}
        defaultSession.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error)
            }
            if data != nil {
                complete(data)
            }
            }.resume()
    }
}
