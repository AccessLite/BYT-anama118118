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
    
    //Use flat map over for in loops
    
    func save(operations: [FoaasOperation]) {
//        let defaultDict = operations.flatMap {$0.toJson()}
        var defaultArray = [[String:AnyObject]]()
        for operation in operations {
            defaultArray.append(operation.toJson())
        }
        print(defaultArray)
        dump(defaultArray)
//        print(defaultDict)
        FoaasDataManager.defaults.set(defaultArray,forKey: FoaasDataManager.operationsKey)
//        print(FoaasDataManager.defaults.dictionary(forKey: FoaasDataManager.operationsKey))
//        var defaultDict = [String: AnyObject]()
    }
    func load() -> Bool {
        return FoaasDataManager.defaults.dictionary(forKey: "FoaasOperationsKey") != nil
    }
    func deleteStoredOperations() {
        FoaasDataManager.defaults.set(nil, forKey: FoaasDataManager.operationsKey)
    }
}
