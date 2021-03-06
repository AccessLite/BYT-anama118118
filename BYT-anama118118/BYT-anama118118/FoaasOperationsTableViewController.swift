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
    
    @IBOutlet weak var foulLanguageFilterSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        var text = foaasOperationsArray?[indexPath.row].name
        if self.foulLanguageFilterSwitch.isOn {
            text = FoulLanguageFilter.filterFoulLanguage(text: (foaasOperationsArray?[indexPath.row].name)!)
        }
        cell.textLabel?.text = text
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailFoaasOperationsViewSegue {
            let foaasPreviewViewController = segue.destination as! FoaasPreviewViewController
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    let foaasOperationSelected = foaasOperationsArray?[indexPath.row]
                    foaasPreviewViewController.foaasOperationSelected = foaasOperationSelected
                    foaasPreviewViewController.filterIsOn = foulLanguageFilterSwitch.isOn
                    dump(foaasOperationSelected)
                }
            }
        }
    }
    
    @IBAction func backOctoCuteTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func foulLanguageFilterSwitch(_ sender: UISwitch) {
        self.tableView.reloadData()
    }

    
}
