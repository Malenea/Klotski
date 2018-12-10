//
//  UIButton+Extensions.swift
//  Klotski
//
//  Created by Malenea on 07/12/2018.
//  Copyright © 2018 Malenea. All rights reserved.
//

// MARK: Native imports
import UIKit

extension UIButton {

    func setAttributedTitle(_ text: String, withColor color: UIColor, withFont font: UIFont) {
        let attributedTitle = NSMutableAttributedString()
        attributedTitle.createTextWithColor(text, color: color, font: font)
        self.setAttributedTitle(attributedTitle, for: .normal)
    }

}
