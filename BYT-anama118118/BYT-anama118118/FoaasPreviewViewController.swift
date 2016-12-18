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
    var foaasPath: FoaasPathBuilder?
    var filterIsOn: Bool = true
    
    @IBOutlet weak var fullOperationPrevieTextView: UITextView!
    
    @IBOutlet weak var field1Label: UILabel!
    @IBOutlet weak var field1TextField: UITextField!
    @IBOutlet weak var field2Label: UILabel!
    @IBOutlet weak var field2TextField: UITextField!
    @IBOutlet weak var field3Label: UILabel!
    @IBOutlet weak var field3TextField: UITextField!
    @IBOutlet weak var bottomToKeyboardLayout: NSLayoutConstraint!
    @IBOutlet weak var selectButton: UIBarButtonItem!
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.foaasPath = FoaasPathBuilder(operation: self.foaasOperationSelected)
        
        self.field1TextField.delegate = self
        self.field2TextField.delegate = self
        self.field3TextField.delegate = self
        
        callApi()
        fieldLabelAndTextFieldSetUp()
        self.registerForNotifications()
        
        //http://stackoverflow.com/questions/32281651/how-to-dismiss-keyboard-when-touching-anywhere-outside-uitextfield-in-swift
        view.addGestureRecognizer(self.tapGestureRecognizer)
    }

    // make sure your documentation provides helpful info
    /// Shows textfields as needed based on `FoaasOperation`'s `FoaasFields`
    func fieldLabelAndTextFieldSetUp() {
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
            field2TextField.isHidden = false
            field3TextField.isHidden = false
            
            field2Label.text = "<\(keys[1])>"
            field3Label.text = "<\(keys[2])>"
            field2TextField.placeholder = keys[1]
            field3TextField.placeholder = keys[2]
        default:
            break
        }
    }
    
    
    // MARK: - Notifications
    internal func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(keyboardDidAppear(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textFieldDidEndEditing(textField)
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
        self.view.endEditing(true)
    }
    
    
    // MARK: Keyboard Management
    // Your management of the keyboard constraints was a decent first-shot, but there is a proper way to do it by checking
    // UIKeyboardFrameEndUserInfoKey inside of the notification.userInfo. Please look this up for week 3's tasks
    internal func keyboardDidAppear(notification: Notification) {
        self.shouldShowKeyboard(show: true, notification: notification, completion: nil)
    }
    
    internal func keyboardWillDisappear(notification: Notification) {
        self.shouldShowKeyboard(show: false, notification: notification, completion: nil)
    }
    
    private func shouldShowKeyboard(show: Bool, notification: Notification, completion: ((Bool) -> Void)? ) {
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            bottomToKeyboardLayout.constant = keyboardFrame.cgRectValue.size.height * (show ? 1 : -1)
            self.view.updateConstraints()
        }
    }
    
    @IBAction func tapGestureDismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func callApi() {
        guard let validFoaasPath = self.foaasPath else { return }
        let urlBase = "http://www.foaas.com"
        let validUrlString = validFoaasPath.build()
        
        guard let url = URL(string: urlBase + validUrlString) else { return }
        FoaasDataManager.shared.requestFoaas(url: url) { (foaas: Foaas?) in
            guard let validFoaas = foaas else { return }
            self.foaas = validFoaas
            var message = self.foaas.message
            var subtitle = self.foaas.subtitle
            if self.filterIsOn {
                message = FoulLanguageFilter.filterFoulLanguage(text: self.foaas.message)
                subtitle = FoulLanguageFilter.filterFoulLanguage(text: self.foaas.subtitle)
            }
            DispatchQueue.main.async {
                let attributedString = NSMutableAttributedString(string: message, attributes: [ NSFontAttributeName : UIFont.systemFont(ofSize: 30, weight: UIFontWeightMedium) ])
                let fromAttribute = NSMutableAttributedString(string: "\n\n" + subtitle, attributes: [ NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName : UIFont.systemFont(ofSize: 24, weight: UIFontWeightThin) ])
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
    
    ///Button to send notification to FoaasViewController and dismisses current view controllers
    ///http://stackoverflow.com/questions/29435620/xcode-storyboard-cant-drag-bar-button-to-toolbar-at-top
    ///http://stackoverflow.com/questions/24668818/how-to-dismiss-viewcontroller-in-swift
    @IBAction func selectBarBottonTapped(_ sender: UIBarButtonItem) {
        let foaasInfo: [String : AnyObject] = self.foaas.toJson()
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: [ "info" : foaasInfo , "filterStatus": self.filterIsOn])
        dismiss(animated: true, completion: nil)
    }
    
}

class FoulLanguageFilter {
    ///Filter foul language of given text with foulWords in a default foulWordsArray
    static func filterFoulLanguage(text: String) -> String {
        // is there really a difference between "fuck", "fuck.", "fuck?", "fuck‽", "fuck-nugget.", "fuckin'", "fucks", "fucks.", "fucks',", "fucking", "fuckity"?
        // you should just need to check for "fuck". there is unnecessary work being done here
        // I'd like you to fix this
        let foulWordsArray = Set(["fuck", "dick", "cock", "crap", "asshole", "pussy", "shit", "vittupää", "motherfuck"])
        var wordsArr = text.components(separatedBy: " ")
        for f in foulWordsArray {
            wordsArr = wordsArr.map { (word) -> String in
                if word.lowercased().hasPrefix(f) || word.lowercased().hasSuffix(f) {
                    return multateFoulLanguage(word: word)
                } else {
                    return word
                }
            }
        }
        let string = wordsArr.joined(separator: " ")
        return string
    }
    
    ///Replaces word's first vowel into *
    static func multateFoulLanguage(word: String) -> String {
        // re-write this and check for the first instance of a character using CharacterSet. then replace it with a * using String range operations
        let vowels = Set(["a","e","i","o","u"])
        for c in word.lowercased().characters {
            if vowels.contains(String(c)) {
                if word.lowercased().hasPrefix("motherfuck") {
                    return word.replacingOccurrences(of: "u", with: "*")
                }
                return word.replacingOccurrences(of: String(c), with: "*")
            }
        }
//        var counter = 0
//        let filteredWord = word.lowercased().characters.map { (character) -> Character in
//            if vowels.contains(character) && counter == 0 {
//                counter += 1
//                return "*"
//            } else {
//                return character
//            }
//        }
        
//        for character in word.characters {
//            if vowels.contains(String(character)) && counter <= 2 && word.lowercased().hasPrefix("motherfuck") {
//                if counter == 2 {
//                    muatedString += "*"
//                } else {
//                    muatedString += "\(character)"
//                }
//                counter += 1
//            } else if vowels.contains(String(character)) && counter == 0 {
//                muatedString += "*"
//                counter += 1
//            } else {
//                muatedString += "\(character)"
//            }
//        }
        return word
    }

}
