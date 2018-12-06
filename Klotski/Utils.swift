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

    class func BoardArrayToArray(_ MultiArray: [[String]]) -> (String, String) {
        var result: String = ""
        var invertedResult: String = ""
        for line in MultiArray {
            var newLine = ""
            for row in line {
                newLine.append(row)
            }
            result.append(newLine)
            invertedResult.append(String(newLine.reversed()))
        }
        return (result, invertedResult)
    }

}
