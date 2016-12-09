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
 
 Q1: Am I using the FoaasPathBuilder Correctly?
 Q2: I didn't use the indexOf(key: String) -> Int?, can I use it somewhere in my code?
 Q3: What does it mean that we need to create a master/ develop/ feature branch? 
    Is it just like creaking a develop branch? What about the feature part?
 Q4. What does the following message mean?
    "You’ve been added to the Foaas Week 2 team for the AccessLite organization. Foaas Week 2 has 2 members and gives pull access to 1 AccessLite repository.
    View Foaas Week 2: https://github.com/orgs/AccessLite/teams/foaas-week-2
    Read more about team permissions here: https://help.github.com/articles/what-are-the-different-access-permissions"
 
 */
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
    
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBOutlet weak var bottomToKeyboardLayout: NSLayoutConstraint!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
//    var editingTextField: Int = 0
    
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
        let urlBase = "http://www.foaas.com"
        let validUrlString = validFoaasPath.build()
        
        guard let url = URL(string: urlBase + validUrlString) else { return }
        FoaasDataManager.shared.requestFoaas(url: url) { (foaas: Foaas?) in
            guard let validFoaas = foaas else { return }
            self.foaas = validFoaas
            var message = self.foaas.message
            var subtitle = self.foaas.subtitle
            if self.filterIsOn {
                message = LanguageFilter.filterFoulLanguage(text: self.foaas.message)
                subtitle = LanguageFilter.filterFoulLanguage(text: self.foaas.subtitle)
            }
            DispatchQueue.main.async {
                // interesting choice to use NSAttributedString. What made you decide to go this route? Because the text is able to be in the same textView, and the self.foaas.subtitle is 80% of the self.foaas.message in size
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
    
    //http://stackoverflow.com/questions/29435620/xcode-storyboard-cant-drag-bar-button-to-toolbar-at-top
    @IBAction func selectBarBottonTapped(_ sender: UIBarButtonItem) {
        let foaasInfo: [String : AnyObject] = self.foaas.toJson()
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: [ "info" : foaasInfo , "filterStatus": self.filterIsOn])
        //http://stackoverflow.com/questions/24668818/how-to-dismiss-viewcontroller-in-swift
        dismiss(animated: true, completion: nil)
    }
    
}

class LanguageFilter {
    static func filterFoulLanguage(text: String) -> String {
        //Ballmer
        //cocksplate
        //Fucking
        //keep
        ////You think
        ////This guy
        var stringToReturn = text
        let foulLanguageArr = ["fuck", "fuck.", "fuck?", "fuck‽", "fuck-nugget.", "fuckin'", "fucks", "fucks.", "fucks',", "fucking", "fuckity", "dick", "dickface.", "dicks", "dicks.", "cock", "cocks", "cocks.", "cocksplat", "asshole" ,"asshole..." , "foxtrot", "dickface", "perkeleen", "vittupää", "crap", "motherfucker", "motherfucker,", "motherfuck", "fucktard", "Dick","Fuck", "Fuck's", "Fucks", "Fucking", "Fuckity", "Fick", "Cock", "Cocks", "Cocksplat", "Asshole", "Foxtrot", "Dickface", "Perkeleen", "Vittupää", "Crap", "Motherfucker", "Motherfuck", "Fucktard", "Fucktard!"]
        
        for f in foulLanguageArr {
            let wordsArr = stringToReturn.components(separatedBy: " ")
            var fString = ""
            if wordsArr.contains(f) {
                fString = multateFoulLanguage(word: f)
                let string = wordsArr.joined(separator: " ")
                stringToReturn = string.replacingOccurrences(of: f, with: fString)
            }
        }
        return stringToReturn
        
//        let wordsArr = text.components(separatedBy: " ")
//        for w in wordsArr {
//            var fString = ""
//            if foulLanguageArr.contains(w){
//                fString = multateFoulLanguage(word: w)
//                let string = wordsArr.joined(separator: " ")
//                stringToReturn = string.replacingOccurrences(of: w, with: fString)
//            }
//        }
//        return stringToReturn
    }
    
    static func multateFoulLanguage(word: String) -> String {
        var muatedString = ""
        var counter = 0
        for character in word.characters {
            if (character == "a" || character == "e" || character == "i" || character == "o" || character == "u") && counter == 0 {
                muatedString += "*"
                counter += 1
            } else {
                muatedString += "\(character)"
            }
        }
        return muatedString
    }

}
