//
//  BlockClass.swift
//  Klotski
//
//  Created by Malenea on 04/12/2018.
//  Copyright © 2018 Malenea. All rights reserved.
//

// MARK: Native imports
import UIKit

class Block {

    // MARK: Variables
    // Properties
    private var _id: String
    private var _width: Int
    private var _height: Int
    // Coordinates
    private var _coordinates: (x: Int, y: Int) = (0, 0)
    // Getters
    var type: BlockType {
        get {
            if self._width == 1 && self._height == 1 {
                return .smallBlock
            }
            if self._width == 2 && self._height == 2 {
                return .bigBlock
            }
            if self._width == 2 && self._height == 1 {
                return .horizontalBlock
            }
            if self._width == 1 && self._height == 2 {
                return .verticalBlock
            }
            return .empty
        }
    }
    var id: String {
        get {
            return self._id
        }
    }
    var width: Int {
        get {
            return self._width
        }
    }
    var height: Int {
        get {
            return self._height
        }
    }
    var coordinates: (Int, Int) {
        get {
            return self._coordinates
        }
    }

    // MARK: Init functions
    init(id: String, width: Int, height: Int, coordinates: (Int, Int)) {
        self._id = id
        self._width = width
        self._height = height
        self._coordinates = coordinates
    }
}
