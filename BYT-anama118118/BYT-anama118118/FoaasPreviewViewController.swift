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
    var foaasPath: FoaasPathBuilder?
    
    @IBOutlet weak var fullOperationPrevieTextView: UITextView!
    
    @IBOutlet weak var field1Label: UILabel!
    @IBOutlet weak var field1TextField: UITextField!
    @IBOutlet weak var field2Label: UILabel!
    @IBOutlet weak var field2TextField: UITextField!
    @IBOutlet weak var field3Label: UILabel!
    @IBOutlet weak var field3TextField: UITextField!
    
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBOutlet weak var bottomToKeyboardLayout: NSLayoutConstraint!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    var editingTextField: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foaasPath = FoaasPathBuilder(operation: self.foaasOperationSelected)
        
        self.field1TextField.delegate = self
        self.field2TextField.delegate = self
        self.field3TextField.delegate = self
        
        self.hidesBottomBarWhenPushed = true
        
        callApi()
        fieldLabelAndTextFieldSetUP()
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(self.UIKeyboardWillShowNotification), name: Notification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(self.UIKeyboardWillHideNotification), name: Notification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)

        //http://stackoverflow.com/questions/32281651/how-to-dismiss-keyboard-when-touching-anywhere-outside-uitextfield-in-swift
        view.addGestureRecognizer(self.tapGestureRecognizer)
    }

    func fieldLabelAndTextFieldSetUP() {
        guard let validFoaasPath = foaasPath else { return }
        let keys = validFoaasPath.allKeys()
        self.field1Label.text = "<\(keys[0])>"
        field1TextField.placeholder = keys[0]
        
        switch validFoaasPath.operationFields.count {
        case 1:
            field2Label.isHidden = true
            field3Label.isHidden = true
            field2TextField.isHidden = true
            field3TextField.isHidden = true
        case 2:
            field2Label.isHidden = false
            field3Label.isHidden = true
            field2TextField.isHidden = false
            field3TextField.isHidden = true
            
            field2Label.text = "<\(keys[1])>"
            field2TextField.placeholder = keys[1]
        case 3:
            field2Label.isHidden = false
            field3Label.isHidden = false
            field1TextField.isHidden = false
            field3TextField.isHidden = false
            
            field2Label.text = "<\(keys[1])>"
            field3Label.text = "<\(keys[2])>"
            field2TextField.placeholder = keys[1]
            field3TextField.placeholder = keys[2]
        default:
            break
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
        guard let validFoaasPath = self.foaasPath else { return }
        guard let validText = textField.text else { return }
        let keys = validFoaasPath.allKeys()
        
        switch textField {
        case field1TextField:
            validFoaasPath.update(key: keys[0], value: validText)
            dump(validFoaasPath.operationFields)
        case field2TextField:
            validFoaasPath.update(key: keys[1], value: validText)
            dump(validFoaasPath.operationFields!)
        case field3TextField:
            validFoaasPath.update(key: keys[2], value: validText)
            dump(validFoaasPath.operationFields!)
        default:
            break
        }
        
        callApi()
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
    }

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
    
    @IBAction func tapGestureDismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func callApi() {
        guard let validFoaasPath = self.foaasPath else { return }
        let validUrlString = validFoaasPath.build()
        let urlBase = "http://www.foaas.com"
        
        guard let url = URL(string: urlBase + validUrlString) else { return }
        FoaasDataManager.shared.requestFoaas(url: url) { (foaas: Foaas?) in
            guard let validFoaas = foaas else { return }
            self.foaas = validFoaas
            DispatchQueue.main.async {
                // interesting choice to use NSAttributedString. What made you decide to go this route? Because the text is able to be in the same textView, and the self.foaas.subtitle is 80% of the self.foaas.message in size
                let attributedString = NSMutableAttributedString(string: self.foaas.message, attributes: [ NSFontAttributeName : UIFont.systemFont(ofSize: 30, weight: UIFontWeightMedium) ])
                let fromAttribute = NSMutableAttributedString(string: "\n\n" + self.foaas.subtitle, attributes: [ NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName : UIFont.systemFont(ofSize: 24, weight: UIFontWeightThin) ])
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .right
                
                let textLength = fromAttribute.string.characters.count
                let range = NSRange(location: 0, length: textLength)
                
                fromAttribute.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
                attributedString.append(fromAttribute)
                self.fullOperationPrevieTextView.attributedText = attributedString
                print(self.fullOperationPrevieTextView.text)
            }
        }
    }
    
    //http://stackoverflow.com/questions/29435620/xcode-storyboard-cant-drag-bar-button-to-toolbar-at-top
    @IBAction func selectBarBottonTapped(_ sender: UIBarButtonItem) {
        let foaasInfo: [String : AnyObject] = self.foaas.toJson()
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: [ "info" : foaasInfo ])
        //http://stackoverflow.com/questions/24668818/how-to-dismiss-viewcontroller-in-swift
        dismiss(animated: true, completion: nil)
    }
}
