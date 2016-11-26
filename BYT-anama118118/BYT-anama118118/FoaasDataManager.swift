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
    
    // Notes:
    // Limit the number of commented/unused code you have
    // Limit the number of print statements you have -- it just ends up being more confusing than helpful
    
    func save(operations: [FoaasOperation]) {

        var defaultArray = [[String:AnyObject]]()
        for operation in operations {
            defaultArray.append(operation.toJson())
        }
        
        FoaasDataManager.defaults.set(defaultArray,forKey: FoaasDataManager.operationsKey)
        
        // your code works, but the point was to store the [FoaasOperation] as Data, not as a dictionary.
        // you need to convert using toData() first 
        
        // https://github.com/AccessLite/BoardingPass/blob/master/Week%201%20-%20MVP/Week1MVP_TechLeadInstructions.md#protocols
        // as stated in the spec: 
        //          This protocol's intention is to allow you to convert a model into Data to be stored in UserDefaults
        //           This protocol relies on JSONConvertible working to convert models into Swift-types (Array, Dict, String, etc.).
    }
    func load() -> Bool {
        // 1. the idea here is that you're loading your data into the FoaasDataManager and returning true/false
        //    depending on its success, so this is missing a key step of saving your now loaded data
        
        // 2. As your code is currently written, this would load the data properly.
        //    But this is just the example, you must re-implement saving/loading using toData()
        guard let operations = FoaasDataManager.defaults.object(forKey: FoaasDataManager.operationsKey) as? [[String : AnyObject]] else {
            return false
        }

        // look at the documentation for dictionary(forKey:), it returns [String : Any]. But our object is [[String : AnyObject]], so this check below will always fail
        //  return FoaasDataManager.defaults.dictionary(forKey: "FoaasOperationsKey") != nil
        return true
    }
    func deleteStoredOperations() {
        FoaasDataManager.defaults.set(nil, forKey: FoaasDataManager.operationsKey)
    }
}
