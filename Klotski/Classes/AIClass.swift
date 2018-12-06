//
//  AIClass.swift
//  Klotski
//
//  Created by Malenea on 04/12/2018.
//  Copyright © 2018 Malenea. All rights reserved.
//

// MARK: Native imports
import UIKit

class AI {

    // MARK: Structures for layout trees
    struct Layout {
        var id: String
        var invertedId: String
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

    // MARK: Variables
    // Reference to the parent VC
    var parentVC: MainBoardViewController!
    // Initial layout and layouts records
    private var _initialLayoutNode: LayoutNode<Layout>!
    private var _passedLayoutsRecords: [String] = []

    private var _parentLayoutNodes: [LayoutNode<Layout>] = []
    private var _childrenLayoutNodes: [LayoutNode<Layout>] = []

    // MARK: Functions
    // Function to handle layouts
    func createLayoutNode(state: [[BlockType]], board: [[String]]) -> LayoutNode<Layout> {
        let layoutArrays: (String, String) = Utils.BoardArrayToArray(board)
        let layout = Layout(id: layoutArrays.0, invertedId: layoutArrays.1, state: state, board: board)
        return LayoutNode(layout)
    }

    func createBoardFrom(layout: Layout) -> Board {
        let board = Board(height: self.parentVC.boardHeight, width: self.parentVC.boardWidth)
        var lineCount: Int = 0
        for line in layout.state {
            var width: Int = -1
            var height: Int = -1
            var rowCount: Int = 0
            for row in line {
                switch row {
                case .smallBlock:
                    width = 1
                    height = 1
                case .verticalBlock:
                    width = 1
                    height = 2
                case .horizontalBlock:
                    width = 2
                    height = 1
                case .bigBlock:
                    width = 2
                    height = 2
                default:
                    width = -1
                    height = -1
                }
                if width == -1 || height == -1 {
                    board.nodes[lineCount][rowCount].block = nil
                } else {
                    board.nodes[lineCount][rowCount].block = Block(id: layout.board[lineCount][rowCount], height: height, width: width, coordinates: (lineCount, rowCount))
                }
                rowCount += 1
            }
            lineCount += 1
        }
        return board
    }

    func createLayout(fromBoard: Board) -> Layout {
        var state: [[BlockType]] = []
        var board: [[String]] = []
        var lineCount: Int = 0
        for line in fromBoard.nodes {
            state.append([])
            board.append([])
            var nodeCount: Int = 0
            for node in line {
                if let block = node.block {
                    state[lineCount].append(block.type)
                    board[lineCount].append(block.id)
                } else {
                    state[lineCount].append(BlockType.empty)
                    board[lineCount].append("0")
                }
                nodeCount += 1
            }
            lineCount += 1
        }
        let layoutArrays: (String, String) = Utils.BoardArrayToArray(board)
        return Layout(id: layoutArrays.0, invertedId: layoutArrays.1, state: state, board: board)
    }

    // Function to check win conditions
    func checkWin(layoutNode: LayoutNode<Layout>) -> Bool {
        let layout = layoutNode.layout
//        return layout.state[layout.state.count - 1][(layout.state[0].count / 2) - 1].rawValue == layout.state[layout.state.count - 1][layout.state[0].count / 2].rawValue &&
//        layout.state[layout.state.count - 1][layout.state[0].count / 2].rawValue == layout.state[layout.state.count - 2][(layout.state[0].count / 2) - 1].rawValue &&
//        layout.state[layout.state.count - 2][(layout.state[0].count / 2) - 1].rawValue == layout.state[layout.state.count - 2][layout.state[0].count / 2].rawValue &&
//        layout.state[layout.state.count - 2][layout.state[0].count / 2].rawValue == BlockType.bigBlock.rawValue
        return (layout.state[3][1].rawValue == layout.state[3][2].rawValue && layout.state[3][2].rawValue == layout.state[4][1].rawValue &&
            layout.state[4][1].rawValue == layout.state[4][2].rawValue && layout.state[4][1].rawValue == BlockType.bigBlock.rawValue)
    }

    // AI and algorythm search functions
    func checkDirectionsForBlockFrom(_ node: Node, completion: @escaping ([Direction]) -> Void) {
        var directions: [Direction] = []
        if node.canGoUp() {
            directions.append(.up)
        }
        if node.canGoLeft() {
            directions.append(.left)
        }
        if node.canGoDown() {
            directions.append(.down)
        }
        if node.canGoRight() {
            directions.append(.right)
        }
        if directions.isEmpty {
            directions.append(.none)
        }
        completion(directions)
    }

    func checkLayoutForLayoutNodeCreationFrom(board: Board) -> LayoutNode<Layout>? {
        let layout = self.createLayout(fromBoard: board)
        if self._passedLayoutsRecords.contains(layout.id) || self._passedLayoutsRecords.contains(layout.invertedId) {
            return nil
        }
        self._passedLayoutsRecords.append(layout.id)
        self._passedLayoutsRecords.append(layout.invertedId)
        let childLayoutNode: LayoutNode = LayoutNode(layout)
        return childLayoutNode
    }

    func searchLayoutNode(_ layoutNode: LayoutNode<Layout>) -> [LayoutNode<Layout>] {
        var result: [LayoutNode<Layout>] = []
        let initialBoard: Board = self.createBoardFrom(layout: layoutNode.layout)
        var lineCount: Int = 0
        for nodeLine in initialBoard.nodes {
            var rowCount: Int = 0
            for node in nodeLine {
                self.checkDirectionsForBlockFrom(node) { (directions) in
                    for direction in directions {
                        switch direction {
                        case .up:
                            let childBoard = initialBoard.copyBoard()
                            if childBoard.nodes[lineCount][rowCount].moveUp() {
                                if let childLayoutNode = self.checkLayoutForLayoutNodeCreationFrom(board: childBoard) {
                                    result.append(childLayoutNode)
                                }
                            }
                        case .left:
                            let childBoard = initialBoard.copyBoard()
                            if childBoard.nodes[lineCount][rowCount].moveLeft() {
                                if let childLayoutNode = self.checkLayoutForLayoutNodeCreationFrom(board: childBoard) {
                                    result.append(childLayoutNode)
                                }
                            }
                        case .down:
                            let childBoard = initialBoard.copyBoard()
                            if childBoard.nodes[lineCount][rowCount].moveDown() {
                                if let childLayoutNode = self.checkLayoutForLayoutNodeCreationFrom(board: childBoard) {
                                    result.append(childLayoutNode)
                                }
                            }
                        case .right:
                            let childBoard = initialBoard.copyBoard()
                            if childBoard.nodes[lineCount][rowCount].moveRight() {
                                if let childLayoutNode = self.checkLayoutForLayoutNodeCreationFrom(board: childBoard) {
                                    result.append(childLayoutNode)
                                }
                            }
                        default:
                            break
                        }
                    }
                }
                rowCount += 1
            }
            lineCount += 1
        }
        return result
    }

    func searchPath() {
        while !self._parentLayoutNodes.isEmpty {
            for parent in self._parentLayoutNodes {
                print("-> \(parent.layout.id)")
                if self.checkWin(layoutNode: parent) {
                    print("Found a solution")
                    return
                }
                let newChildrens = self.searchLayoutNode(parent)
                for newChildren in newChildrens {
                    parent.addChildren(child: newChildren)
                }
                self._childrenLayoutNodes += newChildrens
            }
            self._parentLayoutNodes.removeAll()
            self._parentLayoutNodes = self._childrenLayoutNodes
            self._childrenLayoutNodes = []
            print("=> \(self._parentLayoutNodes.count)")
        }
        print("Didn't find a solution")
    }

    // MARK: Init functions
    init(_ parentVC: MainBoardViewController, initialBoard: Board) {
        self.parentVC = parentVC
        // Create initial layout
        let layout = self.createLayout(fromBoard: initialBoard)
        self._passedLayoutsRecords.append(layout.id)
        self._passedLayoutsRecords.append(layout.invertedId)
        // Create initial layout node
        self._initialLayoutNode = self.createLayoutNode(state: layout.state, board: layout.board)
        // First save the parent layout node
        self._parentLayoutNodes.append(self._initialLayoutNode)
    }

}
