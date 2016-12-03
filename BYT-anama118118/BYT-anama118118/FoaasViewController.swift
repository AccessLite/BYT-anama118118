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
        self.registerForNotifications()
        
        // there's no reason to do a check on self.foaas since it's type Foaas!
        // you're indicating that you guarantee that FoaasViewController will always have a non-nil value for it
        
        // but there's a hidden bug here becuase self.foaas always nil on initial viewDidLoad, and your else statement will always execute.
        // So in this specific case, you app will not crash, but there's a good chance eventually it will and it will be hard to debug
        
        //I was doing a check on self.foaas because I wass user defaults. If it has values already, it won't run the API call.
        FoaasAPIManager.getFoaas(url: FoaasAPIManager.foaasURL!) { (foaas: Foaas?) in
            if let validFoaas = foaas {
                self.foaas = validFoaas
                DispatchQueue.main.async {
                    self.mainTextLabel.text = validFoaas.message
                    self.subtitleTextLabel.text = "From,\n \(validFoaas.subtitle)"
                }
            }
        }
        
    }
    
    @IBAction func octoButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "foaasOperationsTableViewControllerSegue", sender: sender)
    }
    
    internal func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
    }
    
    // You also semi-avoid the crash bug listed above by assigning self.foaas to a non-nil value here
    internal func updateFoaas(sender: Notification) {
        if let foaasInfo = sender.userInfo as? [String : [String : AnyObject]] {
            if let info = foaasInfo["info"] {
                self.foaas = Foaas(json: info)!
                guard let validFoaas = self.foaas else { return }
                self.mainTextLabel.text = validFoaas.message
                self.subtitleTextLabel.text = "From,\n \(validFoaas.subtitle)"
            }
        }
    }
}
