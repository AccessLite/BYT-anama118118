//
//  FoaasOperationsTableViewController.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 11/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class FoaasOperationsTableViewController: UITableViewController {
    var endpoint = "http://www.foaas.com/operations"
    var endpointForFoaas = URL(string: "http://www.foaas.com/awesome/louis")!
    
    var foaasOperationsArray = [FoaasOperation]()
    var foass: Foaas?
    
    var detailFoaasOperationsViewSegue = "detailFoaasOperationsViewSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FoaasAPIManager.getOperations { (arrayOfFoaasOperation: [FoaasOperation]?) in
            guard let validArrayOfFoaasOperation = arrayOfFoaasOperation else {return}
            self.foaasOperationsArray = validArrayOfFoaasOperation
            dump(self.foaasOperationsArray)
//            FoaasDataManager.shared.save(operations: self.foaasOperationsArray)
//            print(FoaasDataManager.shared.load())
//            dump(UserDefaults.standard.dictionaryRepresentation())
//            dump(Array(UserDefaults.standard.dictionaryRepresentation().keys))
//            FoaasDataManager.shared.deleteStoredOperations()
//            print(FoaasDataManager.shared.load())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        FoaasAPIManager.getFoaas(url: endpointForFoaas) { (foaas: Foaas?) in
            self.foass = foaas
            dump(self.foass)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return foaasOperationsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoaasOperationCellIdentifier", for: indexPath)
        cell.textLabel?.text = foaasOperationsArray[indexPath.row].name
        // Configure the cell...
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailFoaasOperationsViewSegue {
            let detailFoaasOperationsViewController = segue.destination as! DetailFoaasOperationsViewController
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    let foaasOperationSelected = foaasOperationsArray[indexPath.row]
                    detailFoaasOperationsViewController.foaasOperationSelected = foaasOperationSelected
                }
            }
        }
    }
}
