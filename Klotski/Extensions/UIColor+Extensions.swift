//
//  UIColor+Extensions.swift
//  Klotski
//
//  Created by Malenea on 04/12/2018.
//  Copyright © 2018 Malenea. All rights reserved.
//

// MARK: Native imports
import UIKit

extension UIColor {

    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        assert(red >= 0.0 && red <= 255.0, "Invalid red component")
        assert(green >= 0.0 && green <= 255.0, "Invalid green component")
        assert(blue >= 0.0 && blue <= 255.0, "Invalid blue component")

        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }

    @nonobjc class var defaultBlack: UIColor {
        return UIColor(red: 51.0, green: 51.0, blue: 51.0)
    }

    @objc class var pastelPurple: UIColor {
        return UIColor(red: 204.0, green: 170.0, blue: 238.0)
    }

    @objc class var pastelPink: UIColor {
        return UIColor(red: 255.0, green: 179.0, blue: 186.0)
    }

    @objc class var pastelYellow: UIColor {
        return UIColor(red: 255.0, green: 255.0, blue: 186.0)
    }

    @objc class var pastelGreen: UIColor {
        return UIColor(red: 186.0, green: 255.0, blue: 201.0)
    }

    @objc class var pastelBlue: UIColor {
        return UIColor(red: 186.0, green: 225.0, blue: 255.0)
    }

    @nonobjc class var klotskiLightGray: UIColor {
        return UIColor(red: 242.0, green: 242.0, blue: 242.0)
    }

}
