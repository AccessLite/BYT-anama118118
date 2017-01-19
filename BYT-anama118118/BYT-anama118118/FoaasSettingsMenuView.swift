//
//  FoaasSettingsMenuView.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 1/13/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class FoaasSettingsMenuView: UIView {
    
    @IBOutlet weak var profanitySwitch: UISwitch!
    @IBOutlet weak var shareImageButton: UIButton!
    @IBOutlet weak var cameraRollButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    var delegate : FoaasSettingMenuDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let view = Bundle.main.loadNibNamed("FoaasSettingsMenuView", owner: self, options: nil)?.first as? UIView {
            //add a view to the subview
            self.addSubview(view)
            view.frame = self.bounds
        }
    }
    
    @IBAction func profanitySwitchDidChange(_ sender: UISwitch) {
        //uploadData()
        self.delegate?.profanitfySwitchChanged()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        self.delegate?.shareButtonTapped()
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        self.delegate?.camerarollButtonTapped()
    }
    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        self.delegate?.facebookButtonTapped()
    }
    
    @IBAction func twitterButtonTapped(_ sender: UIButton) {
        self.delegate?.twitterButtonTapped()
    }

}


