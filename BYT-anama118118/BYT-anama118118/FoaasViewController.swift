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
    @IBOutlet var shareGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var screenShotLongPressGestureRecognizer: UILongPressGestureRecognizer!
    
    var foaas: Foaas?
    var filterIsOn: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForNotifications()
        
        FoaasDataManager.shared.requestFoaas(url: FoaasDataManager.foaasURL!) { (foaas: Foaas?) in
            if let validFoaas = foaas {
                self.foaas = validFoaas
                var message = validFoaas.message
                var subtitle = validFoaas.subtitle
                if self.filterIsOn {
                    message = FoulLanguageFilter.filterFoulLanguage(text: message)
                    subtitle = FoulLanguageFilter.filterFoulLanguage(text: subtitle)
                }
                DispatchQueue.main.async {
                    self.mainTextLabel.text = message
                    self.subtitleTextLabel.text = "From,\n \(subtitle)"
                }
            }
        }
        self.view.addGestureRecognizer(self.shareGestureRecognizer)
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
        performSegue(withIdentifier: "foaasOperationsTableViewControllerSegue", sender: sender)
    }
    
    internal func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
    }
    
    ///Receive the notification of foaasInfo as json and filterStatus as boolean
    internal func updateFoaas(sender: Notification) {
        if let foaasInfo = sender.userInfo as? [String : AnyObject] {
            if let info = foaasInfo["info"] as? [String : AnyObject],
                let filterStatus = foaasInfo["filterStatus"] as? Bool{
                self.foaas = Foaas(json: info)!
                self.filterIsOn = filterStatus
                guard let validFoaas = self.foaas else { return }
                var message = validFoaas.message
                var subtitle = validFoaas.subtitle
                if self.filterIsOn {
                    message = FoulLanguageFilter.filterFoulLanguage(text: validFoaas.message)
                    subtitle = FoulLanguageFilter.filterFoulLanguage(text: validFoaas.subtitle)
                }
                self.mainTextLabel.text = message
                self.subtitleTextLabel.text = "From,\n \(subtitle)"
            }
        }
    }
    
    ///Allow user to share Foaas message text with tap gesture
    @IBAction func shareText(_ sender: AnyObject) {
        guard let validFoaas = self.foaas else { return }
        var arrayToShare: [String] = []
        arrayToShare.append(validFoaas.message)
        arrayToShare.append(validFoaas.subtitle)
    
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
            present(alertController, animated: true, completion: nil)
            alertController.dismiss(animated: true, completion: nil)
        }
            print("Image saved.")
            let alertController = UIAlertController(title: "Successfully saved screenshot to photo library", message: nil , preferredStyle: UIAlertControllerStyle.alert)
            let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(okay)
        
            present(alertController, animated: true, completion: nil)
            alertController.dismiss(animated: true, completion: nil)
    }    
}
