//
//  UILabel+Extensions.swift
//  Klotski
//
//  Created by Malenea on 07/12/2018.
//  Copyright © 2018 Malenea. All rights reserved.
//

// MARK: Native imports
import UIKit

extension UILabel {

    func setAttributedText(_ text: String, withColor color: UIColor, withFont font: UIFont) {
        let attributedText = NSMutableAttributedString()
        attributedText.createTextWithColor(text, color: color, font: font)
        self.attributedText = attributedText
    }

}
