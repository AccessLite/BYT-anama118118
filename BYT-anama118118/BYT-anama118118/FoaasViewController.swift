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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FoaasAPIManager.getFoaas(url: FoaasAPIManager.foaasURL!) { (foaas: Foaas?) in
            DispatchQueue.main.async {
                self.mainTextLabel.text = foaas?.message
                self.subtitleTextLabel.text = foaas?.subtitle
            }
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func octoButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "foaasOperationsTableViewControllerSegue", sender: sender)
    }

}
