//
//  FoaasOperationsTableViewController.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 11/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class FoaasOperationsTableViewController: UITableViewController {
    static var endPoint = URL(string:"http://www.foaas.com/operations")!
    var endpointForFoaas = URL(string: "http://www.foaas.com/awesome/louis")!
    
    var foaasOperationsArray: [FoaasOperation]? = FoaasDataManager.shared.operations
    var foass: Foaas?
    
    var detailFoaasOperationsViewSegue = "detailFoaasOperationsViewSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        FoaasAPIManager.getOperations { (arrayOfFoaasOperation: [FoaasOperation]?) in
//
//            guard let validArrayOfFoaasOperation = arrayOfFoaasOperation else { return }
//            self.foaasOperationsArray = validArrayOfFoaasOperation

//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                FoaasDataManager.shared.save(operations: self.foaasOperationsArray)
//                FoaasDataManager.shared.deleteStoredOperations()
//            }
//        }
//
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foaasOperationsArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoaasOperationCellIdentifier", for: indexPath)
        cell.textLabel?.text = foaasOperationsArray?[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailFoaasOperationsViewSegue {
            let FoaasPreviewViewController = segue.destination as! FoaasPreviewViewController
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    let foaasOperationSelected = foaasOperationsArray?[indexPath.row]
                    FoaasPreviewViewController.foaasOperationSelected = foaasOperationSelected
                    dump(foaasOperationSelected)
                }
            }
        }
    }
    
    @IBAction func backOctoCuteTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
//        performSegue(withIdentifier: "octoCuteTappedToFoaasViewControllerSegue", sender: sender)
    }

}
