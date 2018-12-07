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

    class func boardArrayToArray(_ MultiArray: [[BlockType]]) -> ([BlockType], [BlockType]) {
        var result: [BlockType] = []
        var invertedResult: [BlockType] = []
        for line in MultiArray {
            var newLine: [BlockType] = []
            for row in line {
                result.append(row)
                newLine.append(row)
            }
            invertedResult += newLine.reversed()
        }
        return (result, invertedResult)
    }

}
