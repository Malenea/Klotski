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

    // MARK: Functions
    // Copy functions
    func copyBoard() -> Board {
        let newBoard = Board(height: self.height, width: self.width)
        var lineCount: Int = 0
        for line in self.nodes {
            var rowCount: Int = 0
            for row in line {
                newBoard.nodes[lineCount][rowCount].block = row.block
                rowCount += 1
            }
            lineCount += 1
        }
        return newBoard
    }

    // MARK: Init functions
    init(height: Int, width: Int) {
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
