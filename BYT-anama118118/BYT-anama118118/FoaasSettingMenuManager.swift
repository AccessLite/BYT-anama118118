//
//  FoaasSettingMenuManager.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 1/17/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation
import UIKit

class FoaasSettingMenuManager: FoaasSettingMenuDelegate {
    static let manager: FoaasSettingMenuManager = FoaasSettingMenuManager()
    var filterIsOn : Bool = true
    func uploadData() {
        
    }
    
    func profanitfySwitchChanged() {
        
    }
    func twitterButtonTapped() {
        
    }
    func facebookButtonTapped() {
        
    }
    func camerarollButtonTapped() {
        
    }
    func shareButtonTapped(){
        
    }
    
    func colorSwitcherScrollViewScrolled(color: UIColor) {
        
    }
}

extension UIFont {

    func robotoHeadLine() -> UIFont {
        return UIFont(name: "Roboto-Light", size: 56.0)!
    }
    func robotoSubHeadline() -> UIFont {
        return UIFont(name: "Roboto-Regular", size: 34.0)!
    }
    func robotoTitle() -> UIFont {
        return UIFont(name: "Roboto-Regular", size: 34.0)!
    }
    func robotoBody() -> UIFont {
        return UIFont(name: "Roboto-Light", size: 24.0)!
    }
    func robotoLabel() -> UIFont {
        return UIFont(name: "Roboto-Medium", size: 18.0)!
    }
    func robotoPlaceholder() -> UIFont {
        return UIFont(name: "Roboto-Regular", size: 13.0)!
    }
    func robotoSettings() -> UIFont {
        return UIFont(name: "Roboto-Regular", size: 18.0)!
    }
    func robotoCaption1() -> UIFont {
        return UIFont(name: "Roboto-Regular", size: 14.0)!
    }
    func robotoCaption2() -> UIFont {
        return UIFont(name: "Roboto-Regular", size: 12.0)!
    }

    class Roboto {
        var headline: UIFont = {
            return UIFont(name: "Roboto-Light", size: 56.0)
        }()!
        var subHeadline: UIFont = {
            return UIFont(name: "Roboto-Regular", size: 34.0)
        }()!
        var title: UIFont = {
            return UIFont(name: "Roboto-Regular", size: 34.0)
        }()!
        var body: UIFont = {
            return UIFont(name: "Roboto-Light", size: 24.0)
        }()!
        var label: UIFont = {
            return UIFont(name: "Roboto-Medium", size: 18.0)
        }()!
        var placeholder: UIFont = {
            return UIFont(name: "Roboto-Regular", size: 13.0)
        }()!
        var settings: UIFont = {
            return UIFont(name: "Roboto-Regular", size: 18.0)
        }()!
        var caption1: UIFont = {
            return UIFont(name: "Roboto-Regular", size: 14.0)
        }()!
        var caption2: UIFont = {
            return UIFont(name: "Roboto-Regular", size: 12.0)
        }()!
    }
}

extension UIColor {
    class FoaasColorManager {
    }
}
