//
//  FoaasViewController.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 11/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class FoaasViewController: UIViewController {
    
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var subtitleTextLabel: UILabel!
    @IBOutlet weak var octoButton: UIButton!
    
    var foaas: Foaas!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.registerForNotifications()
            self.view.reloadInputViews()
        }
        guard let validFoaas =  self.foaas else {
            FoaasAPIManager.getFoaas(url: FoaasAPIManager.foaasURL!) { (foaas: Foaas?) in
                if let validFoaas = foaas {
                    DispatchQueue.main.async {
                        self.mainTextLabel.text = foaas?.message
                        self.subtitleTextLabel.text = "From,\n \(validFoaas.subtitle)"
                    }
                }
            }
            return
        }
        self.mainTextLabel.text = validFoaas.message
        self.subtitleTextLabel.text = "From,\n \(validFoaas.subtitle)"
    }
    
    @IBAction func octoButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "foaasOperationsTableViewControllerSegue", sender: sender)
    }
    
    internal func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
    }
    
    internal func updateFoaas(sender: Notification) {
        if let foaasInfo = sender.userInfo as? [String : [String : AnyObject]] {
            if let info = foaasInfo["info"] {
                self.foaas = Foaas(json: info)!
                guard let validFoaas = self.foaas else { return }
                self.mainTextLabel.text = validFoaas.message
                self.subtitleTextLabel.text = "From,\n \(validFoaas.subtitle)"
                self.view.reloadInputViews()
            }
        }
    }
}
