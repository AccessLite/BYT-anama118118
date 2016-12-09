//
//  FoaasDataManager.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 11/24/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation
import UIKit

class FoaasDataManager {
    
    internal static let shared: FoaasDataManager = FoaasDataManager()
    
    private static let operationsKey: String = "FoaasOperationsKey"
    private static let defaults = UserDefaults.standard
    internal private(set) var operations: [FoaasOperation]?
    
    static let foaasURL = URL(string: "http://www.foaas.com/awesome/Someone")
    
    func save(operations: [FoaasOperation]) {
        var defaultDataArray: [Data] = []
        for operation in operations {
            do {
                let validData = try operation.toData()
                defaultDataArray.append(validData)
            }
            catch {
                print(error)
            }
        }
      
        self.operations = operations
        FoaasDataManager.defaults.set(defaultDataArray,forKey: FoaasDataManager.operationsKey)
        print("Saved \(FoaasDataManager.defaults.dictionary(forKey: FoaasDataManager.operationsKey))")
    }
    
    func load() -> Bool {
        guard let operationsData: [Data] = FoaasDataManager.defaults.value(forKey: FoaasDataManager.operationsKey) as? [Data] else {
            return false
        }
        self.operations = operationsData.flatMap{ FoaasOperation(data: $0) }
        
        print("Successfully loaded operations")
        return true
    }
    
    func deleteStoredOperations() {
        FoaasDataManager.defaults.set(nil, forKey: FoaasDataManager.operationsKey)
        self.operations = nil
    }
    
    internal func requestOperations(_ operations: @escaping ([FoaasOperation]?)->Void) {
        FoaasAPIManager.getOperations { (foaas: [FoaasOperation]?) in
            operations(foaas)
        }
    }
    
    internal func requestFoaas(url: URL, _ operations: @escaping (Foaas?) -> Void) {
        FoaasAPIManager.getFoaas(url: url) { (foaas: Foaas?) in
            operations(foaas)
        }
    }
    
    internal func requestData(endpoint: String, _ operations: @escaping (Data?) -> Void) {
        FoaasAPIManager.getData(endpoint: endpoint) { (data: Data?) in
            operations(data)
        }
    }
}
