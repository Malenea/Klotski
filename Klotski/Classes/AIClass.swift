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

    // MARK: Functions
    // Function to handle layouts
    func createLayoutNode(state: [[BlockType]], board: [[String]]) -> LayoutNode<Layout> {
        let layout = Layout(id: Utils.BoardArrayToArray(board), state: state, board: board)
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
                    board[lineCount].append("Empty")
                }
                nodeCount += 1
            }
            lineCount += 1
        }
        return Layout(id: Utils.BoardArrayToArray(board), state: state, board: board)
    }

    // Function to check win conditions
    func checkWin(layoutNode: LayoutNode<Layout>) -> Bool {
        let layout = layoutNode.layout
        return layout.state[layout.state.count - 1][(layout.state[0].count / 2) - 1].rawValue == layout.state[layout.state.count - 1][layout.state[0].count / 2].rawValue &&
        layout.state[layout.state.count - 1][layout.state[0].count / 2].rawValue == layout.state[layout.state.count - 2][(layout.state[0].count / 2) - 1].rawValue &&
        layout.state[layout.state.count - 2][(layout.state[0].count / 2) - 1].rawValue == layout.state[layout.state.count - 2][layout.state[0].count / 2].rawValue &&
        layout.state[layout.state.count - 2][layout.state[0].count / 2].rawValue == BlockType.bigBlock.rawValue
    }

    // MARK: Init functions
    init(_ parentVC: MainBoardViewController, initialBoard: Board) {
        self.parentVC = parentVC
        // Create initial layout
        let layout = self.createLayout(fromBoard: initialBoard)
        // Create initial layout node
        self._initialLayoutNode = self.createLayoutNode(state: layout.state, board: layout.board)
        self._passedLayoutsRecords.append(layout.id)
    }

}
