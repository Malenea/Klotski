//
//  NodeClass.swift
//  Klotski
//
//  Created by Malenea on 04/12/2018.
//  Copyright © 2018 Malenea. All rights reserved.
//

// MARK: Native imports
import UIKit

class Node {

    // MARK: Variables
    // Reference to parent board
    var parentBoard: Board!
    // Properties
    var coordinates: (x: Int, y: Int) = (0, 0)
    // Block and visitors
    var block: Block?
    var visitors: [String] = []

    // MARK: Functions
    func canGoUp() -> Bool {
        if let block = self.block {
            if self.coordinates.y == 0 {
                return false
            }
            if self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x].block == nil {
                switch block.type {
                case .horizontalBlock, .bigBlock:
                    if self.coordinates.x > 0, self.parentBoard.nodes[self.coordinates.y][self.coordinates.x - 1].block != nil {
                        if self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x - 1].block == nil {
                            return true
                        }
                    }
                    if self.coordinates.x < self.parentBoard.width - 1, self.parentBoard.nodes[self.coordinates.y][self.coordinates.x + 1].block != nil {
                        if self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x + 1].block == nil {
                            return true
                        }
                    }
                default:
                    return true
                }
            }
        }
        return false
    }

    func canGoLeft() -> Bool {
        if let block = self.block {
            if self.coordinates.x == 0 {
                return false
            }
            if self.parentBoard.nodes[self.coordinates.y][self.coordinates.x - 1].block == nil {
                switch block.type {
                case .verticalBlock, .bigBlock:
                    if self.coordinates.y > 0, self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x].block != nil {
                        if self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x - 1].block == nil {
                            return true
                        }
                    }
                    if self.coordinates.y < self.parentBoard.height - 1, self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x].block != nil {
                        if self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x - 1].block == nil {
                            return true
                        }
                    }
                default:
                    return true
                }
            }
        }
        return false
    }

    func canGoDown() -> Bool {
        if let block = self.block {
            if self.coordinates.y == self.parentBoard.height - 1 {
                return false
            }
            if self.parentBoard.nodes[self.coordinates.y][self.coordinates.x].block == nil {
                switch block.type {
                case .horizontalBlock, .bigBlock:
                    if self.coordinates.x > 0, self.parentBoard.nodes[self.coordinates.y][self.coordinates.x - 1].block != nil {
                        if self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x - 1].block == nil {
                            return true
                        }
                    }
                    if self.coordinates.x < self.parentBoard.width - 1, self.parentBoard.nodes[self.coordinates.y][self.coordinates.x + 1].block != nil {
                        if self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x + 1].block == nil {
                            return true
                        }
                    }
                default:
                    return true
                }
            }
        }
        return false
    }

    func canGoRight() -> Bool {
        if let block = self.block {
            if self.coordinates.x == self.parentBoard.width - 1 {
                return false
            }
            if self.parentBoard.nodes[self.coordinates.y][self.coordinates.x + 1].block == nil {
                switch block.type {
                case .verticalBlock, .bigBlock:
                    if self.coordinates.y > 0, self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x].block != nil {
                        if self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x + 1].block == nil {
                            return true
                        }
                    }
                    if self.coordinates.y < self.parentBoard.height - 1, self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x].block != nil {
                        if self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x + 1].block == nil {
                            return true
                        }
                    }
                default:
                    return true
                }
            }
        }
        return false
    }

}
