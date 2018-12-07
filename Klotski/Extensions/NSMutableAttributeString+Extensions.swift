//
//  NSMutableAttributeString+Extensions.swift
//  Klotski
//
//  Created by Malenea on 07/12/2018.
//  Copyright © 2018 Malenea. All rights reserved.
//

// MARK: Native imports
import UIKit

extension NSMutableAttributedString {
    @discardableResult func createText(_ text: String, font: UIFont? = UIFont.systemFont(ofSize: 17.0)) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font ?? UIFont.systemFont(ofSize: 17.0)]
        let string = NSMutableAttributedString(string: text, attributes: attrs)
        append(string)
        return self
    }

    @discardableResult func createTextWithColor(_ text: String, color: UIColor, font: UIFont? = UIFont.systemFont(ofSize: 17.0)) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font ?? UIFont.systemFont(ofSize: 17.0), .foregroundColor: color]
        let string = NSMutableAttributedString(string: text, attributes: attrs)
        append(string)
        return self
    }
}
