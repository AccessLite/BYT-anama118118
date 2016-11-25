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
    let shared: FoaasDataManager = FoaasDataManager()
    
    private static let operationsKey: String = "FoaasOperationsKey"
    private static let defaults = UserDefaults.standard
    internal private(set) var operations: [FoaasOperation]?
    
    //Use flat map over for in loops
    
    func save(operations: [FoaasOperation]) {
        var defaultDict = [String: [String: AnyObject]]()
        for operation in operations {
            defaultDict["\(operation.name)"] = FoaasOperation.toJson(operation)
        }
        
        print(defaultDict)
        FoaasDataManager.defaults.set(defaultDict,forKey: FoaasDataManager.operationsKey)
        
    }
    func load() -> Bool {
        return true
    }
    func deleteStoredOperations() {
        FoaasDataManager.defaults.set(nil, forKey: FoaasDataManager.operationsKey)
    }
}
