//
//  BoardClass.swift
//  Klotski
//
//  Created by Malenea on 04/12/2018.
//  Copyright © 2018 Malenea. All rights reserved.
//

// MARK: Native imports
import UIKit

class Board {

    // MARK: Variables
    // Properties
    private var _width: Int
    private var _height: Int
    // Nodes of the board
    var nodes: [[Node]] = []
    // Getters
    var width: Int {
        get {
            return _width
        }
    }
    var height: Int {
        get {
            return _height
        }
    }

    // MARK: Init functions
    init(width: Int, height: Int) {
        self._width = width
        self._height = height
        for lineIndex in 0 ..< height {
            self.nodes.append([])
            for rowIndex in 0 ..< width {
                let node = Node()
                node.parentBoard = self
                node.coordinates = (rowIndex, lineIndex)
                self.nodes[lineIndex].append(node)
            }
        }
    }

}
