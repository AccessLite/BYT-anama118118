//
//  DetailFoaasOperationsViewController.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 11/26/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class FoaasPreviewViewController: UIViewController, UITextFieldDelegate {
    
    var foaasOperationSelected: FoaasOperation!
    var foaas: Foaas!
    lazy var yValue: CGFloat = {
        return self.view.frame.origin.y
    }()
    
    @IBOutlet weak var fullOperationPrevieTextView: UITextView!
    
    @IBOutlet weak var field1Label: UILabel!
    @IBOutlet weak var field1TextField: UITextField!
    @IBOutlet weak var field2Label: UILabel!
    @IBOutlet weak var field2TextField: UITextField!
    @IBOutlet weak var field3Label: UILabel!
    @IBOutlet weak var field3TextField: UITextField!
    
    @IBOutlet weak var selectButton: UIBarButtonItem!
    
    var urlString: String = "http://www.foaas.com"
    var editingTextField: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.field1TextField.delegate = self
        self.field2TextField.delegate = self
        self.field3TextField.delegate = self

        self.urlString = "http://www.foaas.com\(self.foaasOperationSelected.url)"
        
        callApi()
        fieldLabelAndTextFieldSetUP()
        self.navigationItem.hidesBackButton = true
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
            
            field1Label.text = "<\(foaasOperationSelected.fields[0].name)>"
            field1TextField.placeholder = foaasOperationSelected.fields[0].name
        } else if foaasOperationSelected.fields.count == 2 {
            field1Label.isHidden = false
            field2Label.isHidden = false
            field3Label.isHidden = true
            field1TextField.isHidden = false
            field2TextField.isHidden = false
            field3TextField.isHidden = true
            
            field1Label.text = "<\(foaasOperationSelected.fields[0].name)>"
            field2Label.text = "<\(foaasOperationSelected.fields[1].name)>"
            field1TextField.placeholder = foaasOperationSelected.fields[0].name
            field2TextField.placeholder = foaasOperationSelected.fields[1].name
        } else {
            field1Label.isHidden = false
            field2Label.isHidden = false
            field3Label.isHidden = false
            field2TextField.isHidden = false
            field1TextField.isHidden = false
            field3TextField.isHidden = false
            
            field1Label.text = "<\(foaasOperationSelected.fields[0].name)>"
            field2Label.text = "<\(foaasOperationSelected.fields[1].name)>"
            field3Label.text = "<\(foaasOperationSelected.fields[2].name)>"
            field1TextField.placeholder = foaasOperationSelected.fields[0].name
            field2TextField.placeholder = foaasOperationSelected.fields[1].name
            field3TextField.placeholder = foaasOperationSelected.fields[2].name
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.urlString = "http://www.foaas.com\(self.foaasOperationSelected.url)"
        switch self.foaasOperationSelected.fields.count{
        case 1:
            if field1TextField.text != "" {
//                let searchField: String = self.field1TextField.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//                print(searchField)
                let validSearchField1 = field1TextField.text!.replacingOccurrences(of: " ", with: "%20")
                print(validSearchField1)
                self.urlString = self.urlString.replacingOccurrences(of: ":\(self.foaasOperationSelected.fields[0].field)", with: validSearchField1)
                callApi()
                self.selectButton.isEnabled = true
            }
        case 2:
            if field1TextField.text != "" && field2TextField.text != "" {
                let validSearchField1 = field1TextField.text!.replacingOccurrences(of: " ", with: "%20")
                let validSearchField2 = field2TextField.text!.replacingOccurrences(of: " ", with: "%20")
                self.urlString = self.urlString.replacingOccurrences(of: ":\(self.foaasOperationSelected.fields[0].field)", with: validSearchField1)
                self.urlString = self.urlString.replacingOccurrences(of: ":\(self.foaasOperationSelected.fields[1].field)", with: validSearchField2)
                callApi()
                self.selectButton.isEnabled = true
            }
        case 3:
            if field1TextField.text != "" && field2TextField.text != "" && field3TextField.text != ""{
                let validSearchField1 = field1TextField.text!.replacingOccurrences(of: " ", with: "%20")
                let validSearchField2 = field2TextField.text!.replacingOccurrences(of: " ", with: "%20")
                let validSearchField3 = field3TextField.text!.replacingOccurrences(of: " ", with: "%20")
                self.urlString = self.urlString.replacingOccurrences(of: ":\(self.foaasOperationSelected.fields[0].field)", with: validSearchField1)
                self.urlString = self.urlString.replacingOccurrences(of: ":\(self.foaasOperationSelected.fields[1].field)", with: validSearchField2)
                self.urlString = self.urlString.replacingOccurrences(of: ":\(self.foaasOperationSelected.fields[2].field)", with: validSearchField3)
                callApi()
                self.selectButton.isEnabled = true
            }
        default:
            break
        }
        print(self.urlString)
        keyboardHide()
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardShow()
    }
    
    func keyboardShow() {
        print("keyboardShow")
        self.field3TextField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -300).isActive = true
//        view.frame = CGRect(x: view.frame.origin.x, y: yValue  - 150, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func keyboardHide() {
        print("keyboardHide")
        self.field3TextField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 20).isActive = true
//        view.frame = CGRect(x: view.frame.origin.x, y: yValue, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func callApi() {
        guard let url = URL(string: self.urlString) else { return }
        FoaasAPIManager.getFoaas(url: url) { (foaas: Foaas?) in
            guard let validFoaas = foaas else { return }
            self.foaas = validFoaas
            DispatchQueue.main.async {
                let attributedString = NSMutableAttributedString(string: self.foaas.message, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 30, weight: UIFontWeightMedium)])
                let fromAttribute = NSMutableAttributedString(string: "\n\n" + self.foaas.subtitle, attributes: [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont.systemFont(ofSize: 24, weight: UIFontWeightThin)])
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .right
                
                let textLength = fromAttribute.string.characters.count
                let range = NSRange(location: 0, length: textLength)
                
                fromAttribute.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
                attributedString.append(fromAttribute)
                self.fullOperationPrevieTextView.attributedText = attributedString
                //                self.fullOperationPrevieTextView.text = "\(self.foaas.message)\n\(self.foaas.subtitle)"
                print(self.fullOperationPrevieTextView.text)
                self.fullOperationPrevieTextView.reloadInputViews()
            }
        }
    }
    
    //http://stackoverflow.com/questions/29435620/xcode-storyboard-cant-drag-bar-button-to-toolbar-at-top
    @IBAction func selectBarBottonTapped(_ sender: UIBarButtonItem) {
        let foaasInfo: [String : AnyObject] = self.foaas.toJson()
        //... add whatever info you'd like to pass along here
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: [ "info" : foaasInfo ])
        //http://stackoverflow.com/questions/24668818/how-to-dismiss-viewcontroller-in-swift
        dismiss(animated: true, completion: nil)
        //        let foaasViewController: FoaasViewController = FoaasViewController()
        //        foaasViewController.foaas = self.foaas
        //        dump(foaasViewController.foaas)
        
        //        performSegue(withIdentifier: "returnToFoaasViewControllerSegue", sender: sender)
        //        let notificationArtist = Notification.Name(rawValue: "searchForArtist")
        //        NotificationCenter.default.addObserver(forName: notificationArtist, object: nil, queue: nil) { (notification) in
        //            self.makeSearch()
        //        }
    }
}


//    - name: "Awesome"
//    - url: "/awesome/:from"
//    ▿ fields: 1 element
//    ▿ From from #1
//    - name: "From"
//    - field: "from"
