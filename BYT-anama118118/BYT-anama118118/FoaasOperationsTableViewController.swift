//
//  FoaasOperationsTableViewController.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 11/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class FoaasOperationsTableViewController: UITableViewController {
    
    var foaasSettingMenuDelegate : FoaasSettingMenuDelegate!
    
    static var endPoint = URL(string:"http://www.foaas.com/operations")!
    var endpointForFoaas = URL(string: "http://www.foaas.com/awesome/louis")!
    
    var foaasOperationsArray: [FoaasOperation]? = FoaasDataManager.shared.operations
    var foass: Foaas?
    
    var detailFoaasOperationsViewSegue = "detailFoaasOperationsViewSegue"
    
    var floatingButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.floatingButton = UIButton(type: .custom)
        self.floatingButton.addTarget(self, action: #selector(floatingButtonClicked), for: UIControlEvents.touchUpInside)
        self.view.addSubview(floatingButton)
    }
    
    override func viewWillLayoutSubviews() {
        floatingButton.clipsToBounds = true
        floatingButton.setImage(#imageLiteral(resourceName: "Close Button"), for: .normal)
        
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        let _ = [
            floatingButton.trailingAnchor.constraint(equalTo: (tableView.superview?.trailingAnchor)!, constant: -32.0),
            floatingButton.bottomAnchor.constraint(equalTo: (tableView.superview?.bottomAnchor)!, constant: -48.0),
            floatingButton.widthAnchor.constraint(equalToConstant: 50.0),
            floatingButton.heightAnchor.constraint(equalToConstant: 54.0)
            ].map { $0.isActive = true }
    }
    
    func floatingButtonClicked() {
        if let navVC = navigationController {
            navVC.popToRootViewController(animated: true)
        }
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
        if self.foaasSettingMenuDelegate.filterIsOn {
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
                    foaasPreviewViewController.foaasSettingMenuDelegate = self.foaasSettingMenuDelegate
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
