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
        //Will use flat map over for in loops whe ready, the following flatmap has an error eror not handled
//        do {
//            let defaultDataArray: [Data] = operations.flatMap{ $0.toData() }
//        } catch {
//            print(error)
//        }
        
        FoaasDataManager.defaults.set(defaultDataArray,forKey: FoaasDataManager.operationsKey)
        print("Saved \(FoaasDataManager.defaults.dictionary(forKey: FoaasDataManager.operationsKey))")
    }
    
    func load() -> Bool {
        guard let operationsData: [Data] = FoaasDataManager.defaults.value(forKey: FoaasDataManager.operationsKey) as? [Data] else {
            return false
        }
        
        self.operations = operationsData.flatMap{ FoaasOperation(data: $0) }
        
        print(operations)
        return true
    }
    
    func deleteStoredOperations() {
        FoaasDataManager.defaults.set(nil, forKey: FoaasDataManager.operationsKey)
    }
}
