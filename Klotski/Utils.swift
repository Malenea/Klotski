//
//  Utils.swift
//  Klotski
//
//  Created by Malenea on 05/12/2018.
//  Copyright © 2018 Malenea. All rights reserved.
//

// MARK: Native imports
import UIKit

class Utils {

    class func BoardArrayToArray(_ MultiArray: [[String]]) -> String {
        var result: String = ""
        for line in MultiArray {
            for row in line {
                result.append(row)
            }
        }
        return result
    }

}
