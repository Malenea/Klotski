//
//  GlobalVariables.swift
//  Klotski
//
//  Created by Malenea on 04/12/2018.
//  Copyright © 2018 Malenea. All rights reserved.
//

enum BlockType: Int {
    case empty = 0, smallBlock, verticalBlock, horizontalBlock, bigBlock
}

enum Direction: Int {
    case up = 0, left, down, right
}
