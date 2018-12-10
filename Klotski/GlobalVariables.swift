//
//  GlobalVariables.swift
//  Klotski
//
//  Created by Malenea on 04/12/2018.
//  Copyright © 2018 Malenea. All rights reserved.
//

// Enums for controls
enum BlockType: Int {
    case empty = 0, smallBlock, verticalBlock, horizontalBlock, bigBlock
}

enum Direction: Int {
    case none = 0, up, left, down, right
}

// MARK: Structures for layout trees
struct Layout {
    var id: [BlockType]
    var invertedId: [BlockType]
    var state: [[BlockType]]
    var board: [[String]]
}

class LayoutNode<Layout> {
    var layout: Layout
    var children: [LayoutNode] = []
    weak var parent: LayoutNode?

    // MARK: Functions
    func addChildren(child: LayoutNode) {
        self.children.append(child)
        child.parent = self
    }

    // MARK: Init functions
    init(_ layout: Layout) {
        self.layout = layout
    }
}
