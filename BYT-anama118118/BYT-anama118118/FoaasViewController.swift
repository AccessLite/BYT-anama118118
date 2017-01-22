//
//  FoaasViewController.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 11/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class FoaasViewController: UIViewController, FoaasSettingMenuDelegate, UIScrollViewDelegate {
    
    // Objects
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var subtitleTextLabel: UILabel!
    @IBOutlet weak var octoButton: UIButton!
    
    // Gestures
    @IBOutlet var shareGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var screenShotLongPressGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet var foaasSettingMenuSlideUpGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var foaasSettingMenuSlideDownGestureRecognizer: UISwipeGestureRecognizer!
    
    // Views
    @IBOutlet weak var foaasSettingView: FoaasSettingsMenuView!
    @IBOutlet weak var foaasView: UIView!
    var pageIndex = 0
    
    // Constraints
    @IBOutlet weak var foaasViewCenterYConstraint: NSLayoutConstraint!
    
    var foaas: Foaas?
    
    var filterIsOn: Bool {
        get {
            return self.foaasSettingView.profanitySwitch.isOn
        }
        set (newValue) {
            foaasSettingView.profanitySwitch.isOn = newValue
        }
    }
    
    var unfilteredMessage: String = ""
    var colorScheme = [ColorScheme]()
    var versions = [Version]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForNotifications()
        self.navigationController?.isNavigationBarHidden = true
        self.foaasSettingView.delegate = self
        
        FoaasDataManager.shared.requestFoaas(url: FoaasDataManager.foaasURL!) { (foaas: Foaas?) in
            if let validFoaas = foaas {
                self.foaas = validFoaas
                var message = validFoaas.message
                var subtitle = validFoaas.subtitle
                self.unfilteredMessage = "\(message)\n\nFrom,\n\(subtitle)"
                
                if self.filterIsOn {
                    message = FoulLanguageFilter.filterFoulLanguage(text: message)
                    subtitle = FoulLanguageFilter.filterFoulLanguage(text: subtitle)
                }
                
                let attributedString = NSMutableAttributedString(string: message, attributes: [NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 1), NSFontAttributeName : UIFont.systemFont(ofSize: 56, weight: UIFontWeightLight) ])
                let fromAttribute = NSMutableAttributedString(string: "\n\n" + "From,\n" + subtitle, attributes: [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 34, weight: UIFontWeightRegular) ])
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .right
                let textLength = fromAttribute.string.characters.count
                let range = NSRange(location: 0, length: textLength)
                
                fromAttribute.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
                attributedString.append(fromAttribute)
    
                DispatchQueue.main.async {
                    self.mainTextLabel.attributedText = attributedString
                    self.mainTextLabel.minimumScaleFactor = 0.5
                    self.mainTextLabel.adjustsFontSizeToFitWidth = true
                    self.mainTextLabel.lineBreakMode = .byTruncatingTail
                }
            }
        }
        
        FoaasDataManager.shared.requestColorSchemeData(endpoint: FoaasAPIManager.colorSchemeURL) { (data: Data?) in
            guard let validData = data else { return }
            dump(validData)
            guard let colorScheme = ColorScheme.parseColorSchemes(from: validData) else { return }
            DispatchQueue.main.async {
                self.colorScheme = colorScheme
            }
        }
        
        FoaasDataManager.shared.requestVersionData(endpoint: FoaasAPIManager.versionURL) { (data: Data?) in
            guard let validData = data else { return }
            dump(validData)
            guard let version = Version.parseVersion(from: validData) else { return }
            DispatchQueue.main.async {
                self.versions = version
                dump(version)
            }
        }
        
        self.view.addGestureRecognizer(self.shareGestureRecognizer)
    }
    
    func uploadData() {
        self.view.reloadInputViews()
    }
    
    ///Button to performSegue ot FoaasOperationsTableViewController
    @IBAction func octoButtonTapped(_ sender: UIButton) {
        // create references to the different transforms
        let newTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        let originalTransform = sender.imageView!.transform
        
        UIView.animate(withDuration: 0.1, animations: {
            // animate to newTransform
            sender.imageView!.transform = newTransform
            }, completion: { (complete) in
                // return to original transform
                sender.imageView!.transform = originalTransform
        })
        
        if self.foaasView.center.y != self.view.center.y {
            UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.foaasView.alpha = 1
            }) { _ in
                self.foaasViewCenterYConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        
        performSegue(withIdentifier: "foaasOperationsTableViewControllerSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "foaasOperationsTableViewControllerSegue" {
            let foaasOperationsTableViewController = segue.destination as! FoaasOperationsTableViewController
            foaasOperationsTableViewController.foaasSettingMenuDelegate = self
        }
    }
    
    internal func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
    }
    
    ///Receive the notification of foaasInfo as json and filterStatus as boolean
    internal func updateFoaas(sender: Notification) {
        if let foaasInfo = sender.userInfo as? [String : AnyObject] {
            if let info = foaasInfo["previewText"] as? String {
                var message = info
                if self.filterIsOn {
                    message = FoulLanguageFilter.filterFoulLanguage(text: info)
                }
                let messageSubtitleArray = message.components(separatedBy: "\n\n")
                
                let attributedString = NSMutableAttributedString(string: messageSubtitleArray[0], attributes: [NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 1), NSFontAttributeName : UIFont.systemFont(ofSize: 56, weight: UIFontWeightLight) ])
                let fromAttribute = NSMutableAttributedString(string: "\n\n" + messageSubtitleArray[1], attributes: [ NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 0.70), NSFontAttributeName : UIFont.systemFont(ofSize: 34, weight: UIFontWeightRegular) ])
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .right
                let textLength = fromAttribute.string.characters.count
                let range = NSRange(location: 0, length: textLength)
                
                fromAttribute.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
                attributedString.append(fromAttribute)
                
                self.mainTextLabel.attributedText = attributedString
                self.mainTextLabel.minimumScaleFactor = 0.5
                self.mainTextLabel.adjustsFontSizeToFitWidth = true
                self.mainTextLabel.lineBreakMode = .byTruncatingTail
            }
        }
    }
    
    ///Allow user to share Foaas message text with tap gesture
    @IBAction func shareText(_ sender: AnyObject) {
        guard let validFoaas = self.foaas else { return }
        var arrayToShare: [String] = []
        var message = validFoaas.message
        var subtitle = validFoaas.subtitle
        
        if self.filterIsOn {
            message = FoulLanguageFilter.filterFoulLanguage(text: validFoaas.message)
            subtitle = FoulLanguageFilter.filterFoulLanguage(text: validFoaas.subtitle)
            arrayToShare.append(message)
            arrayToShare.append(subtitle)
        } else {
            arrayToShare.append(message)
            arrayToShare.append(subtitle)
        }

        let activityViewController = UIActivityViewController(activityItems: arrayToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    ///Allow user to save screenshot with long press gesture to photo album
    @IBAction func screenShot(_ sender: AnyObject) {
        guard let vaidImage = getScreenShotImage(view: self.view) else { return }
        //https://developer.apple.com/reference/uikit/1619125-uiimagewritetosavedphotosalbum
        UIImageWriteToSavedPhotosAlbum(vaidImage, self, #selector(createScreenShotCompletion(image: didFinishSavingWithError: contextInfo:)), nil)
    }
    
    ///Get current screenshot
    func getScreenShotImage(view: UIView) -> UIImage? {
        //https://developer.apple.com/reference/uikit/1623912-uigraphicsbeginimagecontextwitho
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, view.layer.contentsScale)
        guard let context = UIGraphicsGetCurrentContext() else{
            return nil
        }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    ///Present appropriate Alert by UIAlertViewController, indicating images are successfully saved or not
    ///https://developer.apple.com/reference/uikit/uialertcontroller
    internal func createScreenShotCompletion(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        
        if didFinishSavingWithError != nil {
            print("Error in saving image.")
            let alertController = UIAlertController(title: "Failed to save screenshot to photo library", message: nil , preferredStyle: UIAlertControllerStyle.alert)
            let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(okay)
            // do not dismiss the alert yourself in code this way! add a button and let the user handle it
            present(alertController, animated: true, completion: nil)
        }
        else {
        // this has to be in an else clause. because if error is !nil, you're going to be presenting 2x of these alerts
            print("Image saved.")
            let alertController = UIAlertController(title: "Successfully saved screenshot to photo library", message: nil , preferredStyle: UIAlertControllerStyle.alert)
            let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(okay)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    ///https://www.hackingwithswift.com/example-code/uikit/how-to-animate-views-with-spring-damping-using-animatewithduration
    @IBAction func foaasSettingMenuSlideUpGestureRecognizerDragged(_ sender: UISwipeGestureRecognizer) {
        if self.foaasView.center.y == self.view.center.y {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.foaasView.alpha = 1
                self.foaasViewCenterYConstraint.constant = -(self.foaasSettingView.frame.height)
                self.view.layoutIfNeeded()
            }) { _ in
            }
        }
    }
    
    @IBAction func foaasSettingMenuSlideDownGestureRecognizerDragged(_ sender: UISwipeGestureRecognizer) {
        if self.foaasView.center.y != self.view.center.y {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.foaasView.alpha = 1
                self.foaasViewCenterYConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { _ in
            }
        }
    }
    
    func colorSwitcherScrollViewScrolled(color: UIColor) {
        self.foaasView.backgroundColor = color
    }
    
    func profanitfySwitchChanged() {
        print("switch changed")
        var message = self.unfilteredMessage
        if self.filterIsOn {
            message = FoulLanguageFilter.filterFoulLanguage(text: self.unfilteredMessage)
        }
        let messageSubtitleArray = message.components(separatedBy: "\n\n")
        let attributedString = NSMutableAttributedString(string: messageSubtitleArray[0], attributes: [NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 1), NSFontAttributeName : UIFont.systemFont(ofSize: 56, weight: UIFontWeightLight) ])
        let fromAttribute = NSMutableAttributedString(string: "\n\n" + messageSubtitleArray[1], attributes: [ NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 0.70), NSFontAttributeName : UIFont.systemFont(ofSize: 34, weight: UIFontWeightRegular) ])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let textLength = fromAttribute.string.characters.count
        let range = NSRange(location: 0, length: textLength)
        
        fromAttribute.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
        attributedString.append(fromAttribute)
        
        self.mainTextLabel.attributedText = attributedString
        self.mainTextLabel.minimumScaleFactor = 0.5
        self.mainTextLabel.adjustsFontSizeToFitWidth = true
        self.mainTextLabel.lineBreakMode = .byTruncatingTail
    }
    
    func twitterButtonTapped() {
        print("twitter button tapped")
    }
    
    func facebookButtonTapped() {
        print("facebook button tapped")
    }
    
    func camerarollButtonTapped() {
        print("cameraroll button tapped")
        guard let vaidImage = getScreenShotImage(view: self.view) else { return }
        //https://developer.apple.com/reference/uikit/1619125-uiimagewritetosavedphotosalbum
        UIImageWriteToSavedPhotosAlbum(vaidImage, self, #selector(createScreenShotCompletion(image: didFinishSavingWithError: contextInfo:)), nil)
    }
    
    func shareButtonTapped() {
        print("share button tapped")
        guard let validFoaas = self.foaas else { return }
        var arrayToShare: [String] = []
        var message = validFoaas.message
        var subtitle = validFoaas.subtitle
        
        if self.filterIsOn {
            message = FoulLanguageFilter.filterFoulLanguage(text: validFoaas.message)
            subtitle = FoulLanguageFilter.filterFoulLanguage(text: validFoaas.subtitle)
            arrayToShare.append(message)
            arrayToShare.append(subtitle)
        } else {
            arrayToShare.append(message)
            arrayToShare.append(subtitle)
        }
        
        let activityViewController = UIActivityViewController(activityItems: arrayToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}
