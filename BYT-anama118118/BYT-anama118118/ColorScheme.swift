//
//  ColorScheme.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 1/22/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation
import UIKit

class ColorScheme {
    var record_url: String
    var color_scheme_name: String
    var _50: UIColor
    var _100: UIColor
    var _200: UIColor
    var _300: UIColor
    var _400: UIColor
    var _500: UIColor
    var _600: UIColor
    var _700: UIColor
    var _800: UIColor
    var _900: UIColor
    var a200: UIColor
    var premium: String
    var version_available : [VersionInColorScheme]
    
    var colorArray: [UIColor] {
        get {
            return [_50, _100, _200, _300, _400, _500, _600, _700, _800, _900]
        }
    }
    var primary: UIColor {
        get { return _500 }
    }
    var primaryDark: UIColor {
        get { return _700 }
    }
    var primaryLight: UIColor {
        get { return _100 }
    }
    var accent: UIColor {
        get { return a200 }
    }
    
    init(record_url: String,
         color_scheme_name: String,
         _50: String,
         _100: String,
         _200: String,
         _300: String,
         _400: String,
         _500: String,
         _600: String,
         _700: String,
         _800: String,
         _900: String,
         a200: String,
         premium: String,
         version_available : [VersionInColorScheme]) {
        self.record_url = record_url
        self.color_scheme_name = color_scheme_name
        self._50 = UIColor(hexString: _50 )
        self._100 = UIColor(hexString: _100)
        self._200 = UIColor(hexString: _200)
        self._300 = UIColor(hexString: _300)
        self._400 = UIColor(hexString: _400)
        self._500 = UIColor(hexString: _500)
        self._600 = UIColor(hexString: _600)
        self._700 = UIColor(hexString: _700)
        self._800 = UIColor(hexString: _800)
        self._900 = UIColor(hexString: _900)
        self.a200 = UIColor(hexString: a200)
        self.premium = premium
        self.version_available = version_available
    }
    
     convenience init?(from dict:[String:Any]) {
        if let record_url = dict["record_url"] as? String,
            let color_scheme_name = dict["color_scheme_name"] as? String,
            let _50 = dict["_50"] as? String,
            let _100 = dict["_100"] as? String,
            let _200 = dict["_200"] as? String,
            let _300 = dict["_300"] as? String,
            let _400 = dict["_400"] as? String,
            let _500 = dict["_500"] as? String,
            let _600 = dict["_600"] as? String,
            let _700 = dict["_700"] as? String,
            let _800 = dict["_800"] as? String,
            let _900 = dict["_900"] as? String,
            let a200 = dict["a200"] as? String,
            let premium = dict["premium"] as? String,
            let version_availableArrayOfDict = dict["version_available"] as? [[String: Any]]{
            var v = [VersionInColorScheme]()
            for dict in version_availableArrayOfDict {
//                guard let version = VersionInColorScheme(from: dict) else { return }
//                v.append(version)
            }
            self.init(record_url:record_url,
                      color_scheme_name: color_scheme_name,
                      _50: _50,
                      _100: _100,
                      _200: _200,
                      _300: _300,
                      _400: _400,
                      _500: _500,
                      _600: _600,
                      _700: _700,
                      _800: _800,
                      _900: _900,
                      a200: a200,
                      premium: premium,
                      version_available: [] )
        } else {
            return nil
        }
    }
    
    static func parseColorSchemes(from data: Data) -> [ColorScheme]? {
        var colorSchemes = [ColorScheme]()
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let validArr = json as? [[String: Any]] else { return nil }
            for scheme in validArr {
                if let scheme = ColorScheme(from: scheme) {
                    colorSchemes.append(scheme)
                }
            }
        }
        catch {
            print(error)
        }
        return colorSchemes
    }
    
}

class VersionInColorScheme {
    var id: Int
    var version_name: String
//    init(id: Int, version_name: String) {
//        self.id = id
//        self.version_name = version_name
//    }
    init?(from dict: [String:Any]) {
        if let id = dict["id"] as? Int,
            let version_name = dict["version_name"] as? String {
            self.id = id
            self.version_name = version_name
        } else {
            return nil
        }
    }
    static func parseVersionInColorScheme(from arr:[String:Any]) -> [VersionInColorScheme]{
        return []
    }
}