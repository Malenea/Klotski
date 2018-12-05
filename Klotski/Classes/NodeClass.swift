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

    // MARK: Functions
    // Can move functions
    func canGoUp() -> Bool {
        if let block = self.block {
            if self.coordinates.y == 0 {
                return false
            }
            if self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x].block == nil {
                switch block.type {
                case .horizontalBlock, .bigBlock:
                    if self.coordinates.x > 0, let nextBlock = self.parentBoard.nodes[self.coordinates.y][self.coordinates.x - 1].block, nextBlock.id == block.id {
                        if self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x - 1].block == nil {
                            return true
                        }
                    }
                    if self.coordinates.x < self.parentBoard.width - 1, let nextBlock = self.parentBoard.nodes[self.coordinates.y][self.coordinates.x + 1].block, nextBlock.id == block.id {
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
                    if self.coordinates.y > 0, let nextBlock = self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x].block, nextBlock.id == block.id {
                        if self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x - 1].block == nil {
                            return true
                        }
                    }
                    if self.coordinates.y < self.parentBoard.height - 1, let nextBlock = self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x].block, nextBlock.id == block.id {
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
            if self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x].block == nil {
                switch block.type {
                case .horizontalBlock, .bigBlock:
                    if self.coordinates.x > 0, let nextBlock = self.parentBoard.nodes[self.coordinates.y][self.coordinates.x - 1].block, nextBlock.id == block.id {
                        if self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x - 1].block == nil {
                            return true
                        }
                    }
                    if self.coordinates.x < self.parentBoard.width - 1, let nextBlock = self.parentBoard.nodes[self.coordinates.y][self.coordinates.x + 1].block, nextBlock.id == block.id {
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
                    if self.coordinates.y > 0, let nextBlock = self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x].block, nextBlock.id == block.id {
                        if self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x + 1].block == nil {
                            return true
                        }
                    }
                    if self.coordinates.y < self.parentBoard.height - 1, let nextBlock = self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x].block, nextBlock.id == block.id {
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

    // Move functions
    func moveUp() -> Bool {
        if let block = self.block {
            if self.canGoUp() {
                let newCurrentBlock = Block(id: block.id, height: block.height, width: block.width, coordinates: (self.coordinates.y - 1, self.coordinates.x))
                self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x].block = newCurrentBlock
                if block.type != .bigBlock && block.type != .verticalBlock {
                    self.block = nil
                }
                switch block.type {
                case .horizontalBlock, .bigBlock:
                    if self.coordinates.x > 0, let nextBlock = self.parentBoard.nodes[self.coordinates.y][self.coordinates.x - 1].block, nextBlock.id == block.id {
                        let newSideBlock = Block(id: nextBlock.id, height: nextBlock.height, width: nextBlock.width, coordinates: (self.coordinates.y - 1, self.coordinates.x - 1))
                        self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x - 1].block = newSideBlock
                        if block.type == .bigBlock {
                            self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x - 1].block = nil
                            self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x].block = nil
                        } else {
                            self.parentBoard.nodes[self.coordinates.y][self.coordinates.x - 1].block = nil
                        }
                    }
                    if self.coordinates.x < self.parentBoard.width - 1, let nextBlock = self.parentBoard.nodes[self.coordinates.y][self.coordinates.x + 1].block, nextBlock.id == block.id {
                        let newSideBlock = Block(id: nextBlock.id, height: nextBlock.height, width: nextBlock.width, coordinates: (self.coordinates.y - 1, self.coordinates.x + 1))
                        self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x + 1].block = newSideBlock
                        if block.type == .bigBlock {
                            self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x + 1].block = nil
                            self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x].block = nil
                        } else {
                            self.parentBoard.nodes[self.coordinates.y][self.coordinates.x + 1].block = nil
                        }
                    }
                case .verticalBlock:
                    self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x].block = nil
                default:
                    break
                }
                return true
            }
        }
        return false
    }

    func moveLeft() -> Bool {
        if let block = self.block {
            if self.canGoLeft() {
                let newCurrentBlock = Block(id: block.id, height: block.height, width: block.width, coordinates: (self.coordinates.y, self.coordinates.x - 1))
                self.parentBoard.nodes[self.coordinates.y][self.coordinates.x - 1].block = newCurrentBlock
                if block.type != .bigBlock && block.type != .horizontalBlock {
                    self.block = nil
                }
                switch block.type {
                case .verticalBlock, .bigBlock:
                    if self.coordinates.y > 0, let nextBlock = self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x].block, nextBlock.id == block.id {
                        let newSideBlock = Block(id: nextBlock.id, height: nextBlock.height, width: nextBlock.width, coordinates: (self.coordinates.y - 1, self.coordinates.x - 1))
                        self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x - 1].block = newSideBlock
                        if block.type == .bigBlock {
                            self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x + 1].block = nil
                            self.parentBoard.nodes[self.coordinates.y][self.coordinates.x + 1].block = nil
                        } else {
                            self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x].block = nil
                        }
                    }
                    if self.coordinates.y < self.parentBoard.height - 1, let nextBlock = self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x].block, nextBlock.id == block.id {
                        let newSideBlock = Block(id: nextBlock.id, height: nextBlock.height, width: nextBlock.width, coordinates: (self.coordinates.y + 1, self.coordinates.x - 1))
                        self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x - 1].block = newSideBlock
                        if block.type == .bigBlock {
                            self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x + 1].block = nil
                            self.parentBoard.nodes[self.coordinates.y][self.coordinates.x + 1].block = nil
                        } else {
                            self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x].block = nil
                        }
                    }
                case .horizontalBlock:
                    self.parentBoard.nodes[self.coordinates.y][self.coordinates.x + 1].block = nil
                default:
                    break
                }
                return true
            }
        }
        return false
    }

    func moveDown() -> Bool {
        if let block = self.block {
            if self.canGoDown() {
                let newCurrentBlock = Block(id: block.id, height: block.height, width: block.width, coordinates: (self.coordinates.y + 1, self.coordinates.x))
                self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x].block = newCurrentBlock
                if block.type != .bigBlock && block.type != .verticalBlock {
                    self.block = nil
                }
                switch block.type {
                case .horizontalBlock, .bigBlock:
                    if self.coordinates.x > 0, let nextBlock = self.parentBoard.nodes[self.coordinates.y][self.coordinates.x - 1].block, nextBlock.id == block.id {
                        let newSideBlock = Block(id: nextBlock.id, height: nextBlock.height, width: nextBlock.width, coordinates: (self.coordinates.y + 1, self.coordinates.x - 1))
                        self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x - 1].block = newSideBlock
                        if block.type == .bigBlock {
                            self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x - 1].block = nil
                            self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x].block = nil
                        } else {
                            self.parentBoard.nodes[self.coordinates.y][self.coordinates.x - 1].block = nil
                        }
                    }
                    if self.coordinates.x < self.parentBoard.width - 1, let nextBlock = self.parentBoard.nodes[self.coordinates.y][self.coordinates.x + 1].block, nextBlock.id == block.id {
                        let newSideBlock = Block(id: nextBlock.id, height: nextBlock.height, width: nextBlock.width, coordinates: (self.coordinates.y + 1, self.coordinates.x + 1))
                        self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x + 1].block = newSideBlock
                        if block.type == .bigBlock {
                            self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x + 1].block = nil
                            self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x].block = nil
                        } else {
                            self.parentBoard.nodes[self.coordinates.y][self.coordinates.x + 1].block = nil
                        }
                    }
                case .verticalBlock:
                    self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x].block = nil
                default:
                    break
                }
                return true
            }
        }
        return false
    }

    func moveRight() -> Bool {
        if let block = self.block {
            if self.canGoRight() {
                let newCurrentBlock = Block(id: block.id, height: block.height, width: block.width, coordinates: (self.coordinates.y, self.coordinates.x + 1))
                self.parentBoard.nodes[self.coordinates.y][self.coordinates.x + 1].block = newCurrentBlock
                if block.type != .bigBlock && block.type != .horizontalBlock {
                    self.block = nil
                }
                switch block.type {
                case .verticalBlock, .bigBlock:
                    if self.coordinates.y > 0, let nextBlock = self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x].block, nextBlock.id == block.id {
                        let newSideBlock = Block(id: nextBlock.id, height: nextBlock.height, width: nextBlock.width, coordinates: (self.coordinates.y - 1, self.coordinates.x + 1))
                        self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x + 1].block = newSideBlock
                        if block.type == .bigBlock {
                            self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x - 1].block = nil
                            self.parentBoard.nodes[self.coordinates.y][self.coordinates.x - 1].block = nil
                        } else {
                            self.parentBoard.nodes[self.coordinates.y - 1][self.coordinates.x].block = nil
                        }
                    }
                    if self.coordinates.y < self.parentBoard.height - 1, let nextBlock = self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x].block, nextBlock.id == block.id {
                        let newSideBlock = Block(id: nextBlock.id, height: nextBlock.height, width: nextBlock.width, coordinates: (self.coordinates.y + 1, self.coordinates.x + 1))
                        self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x + 1].block = newSideBlock
                        if block.type == .bigBlock {
                            self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x - 1].block = nil
                            self.parentBoard.nodes[self.coordinates.y][self.coordinates.x - 1].block = nil
                        } else {
                            self.parentBoard.nodes[self.coordinates.y + 1][self.coordinates.x].block = nil
                        }
                    }
                case .horizontalBlock:
                    self.parentBoard.nodes[self.coordinates.y][self.coordinates.x - 1].block = nil
                default:
                    break
                }
                return true
            }
        }
        return false
    }

}
