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
        self.view.addGestureRecognizer(self.shareGestureRecognizer)
    }
    
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
    
    @IBAction func shareText(_ sender: AnyObject) {
        var arrayToShare: [String] = []
        arrayToShare.append(self.foaas.message)
        arrayToShare.append(self.foaas.subtitle)
    
        let activityViewController = UIActivityViewController(activityItems: arrayToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func screenShot(_ sender: AnyObject) {
        guard let vaidImage = getScreenShotImage(view: self.view) else { return }
        //https://developer.apple.com/reference/uikit/1619125-uiimagewritetosavedphotosalbum
        UIImageWriteToSavedPhotosAlbum(vaidImage, self, #selector(createScreenShotCompletion(image: didFinishSavingWithError: contextInfo:)), nil)
    }
    
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
    
    internal func createScreenShotCompletion(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        // check if error != nil
        if didFinishSavingWithError != nil {
            print("Error in saving image.")
            // present appropriate message in UIAlertViewController
            //https://developer.apple.com/reference/uikit/uialertcontroller
            let alertController = UIAlertController(title: "Failed to save screenshot to photo library", message: nil , preferredStyle: UIAlertControllerStyle.alert)
            present(alertController, animated: true, completion: nil)
            alertController.dismiss(animated: true, completion: nil)
        }
            // present appropriate message in UIAlertViewController
            print("Image saved.")
            let alertController = UIAlertController(title: "Successfully saved screenshot to photo library", message: nil , preferredStyle: UIAlertControllerStyle.alert)
            let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(okay)
        
            present(alertController, animated: true, completion: nil)
            alertController.dismiss(animated: true, completion: nil)
            // double check that the image actually gets saved to the camera roll. Not sure how?
    }    
}
