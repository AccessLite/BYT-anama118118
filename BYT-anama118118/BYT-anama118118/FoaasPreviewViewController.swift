//
//  DetailFoaasOperationsViewController.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 11/26/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

/* Notes:
 
 The preview updating only works if you press the return key on the keyboard. I'd like to see didEndEditing implemented as well to do this
 
 */
class FoaasPreviewViewController: UIViewController, UITextFieldDelegate {
    
    var foaasOperationSelected: FoaasOperation!
    var foaas: Foaas!
    
    // why lazy? Because the compiler doesn't complain
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
    
    @IBOutlet weak var bottomToKeyboardLayout: NSLayoutConstraint!
    
    var field1: String = ""
    var field2: String = ""
    var field3: String = ""
    var urlString: String {
        get {
            return "http://www.foaas.com\(self.foaasOperationSelected.url)"
        }
    }
    
    var editingTextField: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.field1TextField.delegate = self
        self.field2TextField.delegate = self
        self.field3TextField.delegate = self
        
        callApi()
        fieldLabelAndTextFieldSetUP()
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(self.UIKeyboardWillShowNotification), name: Notification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(self.UIKeyboardWillHideNotification), name: Notification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textFieldDidEndEditing(textField)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case field1TextField:
            if field1TextField.text != "" {
                self.field1 = field1TextField.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
            }
        case field2TextField:
            if field2TextField.text != "" {
                self.field2 = field2TextField.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
            }
        case field3TextField:
            if field3TextField.text != "" {
                self.field3 = field3TextField.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
            }
        default:
            break
        }
        callApi()
        
        
        self.navigationItem.hidesBackButton = false
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
    }

    // This was a decent attempt to make this work. Wasn't in week 1 spec, however.
    // This also causes the constraints to break, resulting in only sort of what you intended.
    // but breaking constraints is still considered an error
    func UIKeyboardWillShowNotification() {
        print("keyboardShow")
        self.bottomToKeyboardLayout.constant = 300
        self.view.updateConstraints()
//        self.field3TextField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -300).isActive = true
//        view.frame = CGRect(x: view.frame.origin.x, y: yValue  - 150, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func UIKeyboardWillHideNotification() {
        print("keyboardHide")
        self.bottomToKeyboardLayout.constant = 125
        self.view.updateConstraints()
//        self.field3TextField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 20).isActive = true
//        view.frame = CGRect(x: view.frame.origin.x, y: yValue, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func callApi() {
        var replacedValueUrl = self.urlString
        if self.field1 != "" {
           replacedValueUrl = replacedValueUrl.replacingOccurrences(of: ":\(self.foaasOperationSelected.fields[0].field)", with: self.field1)
        }
        if self.field2 != "" {
           replacedValueUrl = replacedValueUrl.replacingOccurrences(of: ":\(self.foaasOperationSelected.fields[1].field)", with: self.field2)
        }
        if self.field3 != "" {
            replacedValueUrl = replacedValueUrl.replacingOccurrences(of: ":\(self.foaasOperationSelected.fields[2].field)", with: self.field3)
        }
        
        guard let url = URL(string: replacedValueUrl) else { return }
        FoaasAPIManager.getFoaas(url: url) { (foaas: Foaas?) in
            guard let validFoaas = foaas else { return }
            self.foaas = validFoaas
            DispatchQueue.main.async {
                // interesting choice to use NSAttributedString. What made you decide to go this route? Because the text is able to be in the same textView
                let attributedString = NSMutableAttributedString(string: self.foaas.message, attributes: [ NSFontAttributeName : UIFont.systemFont(ofSize: 30, weight: UIFontWeightMedium) ])
                let fromAttribute = NSMutableAttributedString(string: "\n\n" + self.foaas.subtitle, attributes: [ NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName : UIFont.systemFont(ofSize: 24, weight: UIFontWeightThin) ])
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .right
                
                let textLength = fromAttribute.string.characters.count
                let range = NSRange(location: 0, length: textLength)
                
                fromAttribute.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
                attributedString.append(fromAttribute)
                self.fullOperationPrevieTextView.attributedText = attributedString
                //  self.fullOperationPrevieTextView.text = "\(self.foaas.message)\n\(self.foaas.subtitle)"
                print(self.fullOperationPrevieTextView.text)
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
    }
}
