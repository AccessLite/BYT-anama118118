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

enum RobotoWeight: String {
    case light = "Roboto-Light"
    case regular = "Roboto-Regular"
    case medium = "Roboto-Medium"
}

extension UIFont {
    
    func roboto(weight: RobotoWeight, size: CGFloat) -> UIFont {
        return UIFont(name: weight.rawValue, size: size)!
    }
    
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
    //http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

}

class FoaasFontManager {
    //`FoaasFontManager.light.pt(35).alpha(0.87)`
}

class FoaasColorManager {
    let shared: FoaasColorManager = FoaasColorManager()
}
