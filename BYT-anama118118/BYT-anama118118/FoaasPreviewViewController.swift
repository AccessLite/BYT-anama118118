//
//  DetailFoaasOperationsViewController.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 11/26/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class FoaasPreviewViewController: UIViewController, UITextFieldDelegate {
    
    //    - name: "Awesome"
    //    - url: "/awesome/:from"
    //    ▿ fields: 1 element
    //    ▿ From from #1
    //    - name: "From"
    //    - field: "from"
    
    var foaasOperationSelected: FoaasOperation!
    var foaas: Foaas!
    
    @IBOutlet weak var operationNameLabel: UILabel!
    @IBOutlet weak var fullOperationPrevieTextView: UITextView!
    
    @IBOutlet weak var field1Label: UILabel!
    @IBOutlet weak var field1TextField: UITextField!
    @IBOutlet weak var field2Label: UILabel!
    @IBOutlet weak var field2TextField: UITextField!
    @IBOutlet weak var field3Label: UILabel!
    @IBOutlet weak var field3TextField: UITextField!
    
    var urlString:String = "http://www.foaas.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.field1TextField.delegate = self
        self.field2TextField.delegate = self
        self.field3TextField.delegate = self
        
        self.operationNameLabel.text = foaasOperationSelected.name
        fieldLabelAndTextFieldSetUP()
    }
    
    func fieldLabelAndTextFieldSetUP() {
        //if time permits, will refactor into swtich statement
        if foaasOperationSelected.fields.count == 1 {
            field1Label.isHidden = false
            field2Label.isHidden = true
            field3Label.isHidden = true
            field1TextField.isHidden = false
            field2TextField.isHidden = true
            field3TextField.isHidden = true
            
            field1Label.text = foaasOperationSelected.fields[0].name
            field1TextField.placeholder = "Enter text here"
        } else if foaasOperationSelected.fields.count == 2 {
            field1Label.isHidden = false
            field2Label.isHidden = false
            field3Label.isHidden = true
            field1TextField.isHidden = false
            field2TextField.isHidden = false
            field3TextField.isHidden = true
            
            field1Label.text = foaasOperationSelected.fields[0].name
            field2Label.text = foaasOperationSelected.fields[1].name
            field1TextField.placeholder = "Enter text here"
            field2TextField.placeholder = "Enter text here"
        } else {
            field1Label.isHidden = false
            field2Label.isHidden = false
            field3Label.isHidden = false
            field2TextField.isHidden = false
            field1TextField.isHidden = false
            field3TextField.isHidden = false
            
            field1Label.text = foaasOperationSelected.fields[0].name
            field2Label.text = foaasOperationSelected.fields[1].name
            field3Label.text = foaasOperationSelected.fields[2].name
            field1TextField.placeholder = "Enter text here"
            field2TextField.placeholder = "Enter text here"
            field3TextField.placeholder = "Enter text here"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.urlString = "http://www.foaas.com\(self.foaasOperationSelected.url)"
        switch self.foaasOperationSelected.fields.count{
        case 1:
            if field1TextField.text != "" {
                self.urlString = self.urlString.replacingOccurrences(of: ":\(self.foaasOperationSelected.fields[0].field)", with: field1TextField.text!)
                callApi()
            }
        case 2:
            if field1TextField.text != "" && field2TextField.text != "" {
            self.urlString = self.urlString.replacingOccurrences(of: ":\(self.foaasOperationSelected.fields[0].field)", with: field1TextField.text!)
            self.urlString = self.urlString.replacingOccurrences(of: ":\(self.foaasOperationSelected.fields[1].field)", with: field2TextField.text!)
                callApi()
            }
        case 3:
            if field1TextField.text != "" && field2TextField.text != "" && field3TextField.text != ""{
                self.urlString = self.urlString.replacingOccurrences(of: ":\(self.foaasOperationSelected.fields[0].field)", with: field1TextField.text!)
                self.urlString = self.urlString.replacingOccurrences(of: ":\(self.foaasOperationSelected.fields[1].field)", with: field2TextField.text!)
                self.urlString = self.urlString.replacingOccurrences(of: ":\(self.foaasOperationSelected.fields[2].field)", with: field3TextField.text!)
                callApi()
            }
        default:
            break
        }
        print(self.urlString)
        return true
    }
    
    func callApi() {
        guard let url = URL(string: self.urlString) else { return }
        FoaasAPIManager.getFoaas(url: url) { (foaas: Foaas?) in
            guard let validFoaas = foaas else { return }
            self.foaas = validFoaas
            DispatchQueue.main.async {
                self.fullOperationPrevieTextView.text = "\(self.foaas.message)\n\(self.foaas.subtitle)"
                print(self.fullOperationPrevieTextView.text)
                self.fullOperationPrevieTextView.reloadInputViews()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
