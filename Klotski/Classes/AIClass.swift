//
//  AIClass.swift
//  Klotski
//
//  Created by Malenea on 04/12/2018.
//  Copyright © 2018 Malenea. All rights reserved.
//

// MARK: Native imports
import UIKit

// MARK: Framework imports
// Logs
import CocoaLumberjack

class AI {

    // MARK: Variables
    // Reference to the parent VC
    var parentVC: MainBoardViewController!
    // Initial layout and layouts records
    private var _initialLayoutNode: LayoutNode<Layout>!
    private var _passedLayoutsRecords: [[BlockType]] = []

    private var _parentLayoutNodes: [LayoutNode<Layout>] = []
    private var _childrenLayoutNodes: [LayoutNode<Layout>] = []

    // MARK: Functions
    // Function to handle layouts
    func createLayoutNode(state: [[BlockType]], board: [[String]]) -> LayoutNode<Layout> {
        let layoutArrays: ([BlockType], [BlockType]) = Utils.boardArrayToArray(state)
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
        let layoutArrays: ([BlockType], [BlockType]) = Utils.boardArrayToArray(state)
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
    // Check directions from nodes' board or from BlockType's board
    func checkDirectionsForBlockFromBoard(_ node: Node, completion: @escaping ([Direction]) -> Void) {
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

    func checkDirectionForBlockFromState(_ board: [[BlockType]], boardId: [[String]], with y: Int, and x: Int, completion: @escaping ([Direction], [Direction]) -> Void) {
        var directions: [Direction] = []
        var next: [Direction] = []
        switch board[y][x] {
        case .smallBlock:
            if y > 0, board[y - 1][x] == .empty {
                directions.append(.up)
                next.append(.none)
            }
            if x > 0, board[y][x - 1] == .empty {
                directions.append(.left)
                next.append(.none)
            }
            if y < board.count - 1, board[y + 1][x] == .empty {
                directions.append(.down)
                next.append(.none)
            }
            if x < board[y].count - 1, board[y][x + 1] == .empty {
                directions.append(.right)
                next.append(.none)
            }
        case .verticalBlock:
            if y > 0, board[y - 1][x] == .empty {
                directions.append(.up)
                next.append(.none)
            }
            if x > 0 && board[y][x - 1] == .empty {
                if y > 0, boardId[y - 1][x] == boardId[y][x], board[y - 1][x - 1] == .empty {
                    directions.append(.left)
                    next.append(.up)
                } else if y < board.count - 1, boardId[y + 1][x] == boardId[y][x], board[y + 1][x - 1] == .empty {
                    directions.append(.left)
                    next.append(.down)
                }
            }
            if y < board.count - 1, board[y + 1][x] == .empty {
                directions.append(.down)
                next.append(.none)
            }
            if x < board[y].count - 1 && board[y][x + 1] == .empty {
                if y > 0, boardId[y - 1][x] == boardId[y][x], board[y - 1][x + 1] == .empty {
                    directions.append(.right)
                    next.append(.up)
                } else if y < board.count - 1, boardId[y + 1][x] == boardId[y][x], board[y + 1][x + 1] == .empty {
                    directions.append(.right)
                    next.append(.down)
                }
            }
        case .horizontalBlock:
            if y > 0, board[y - 1][x] == .empty {
                if x > 0, boardId[y][x - 1] == boardId[y][x], board[y - 1][x - 1] == .empty {
                    directions.append(.up)
                    next.append(.left)
                } else if x < board[y].count - 1, boardId[y][x + 1] == boardId[y][x], board[y - 1][x + 1] == .empty {
                    directions.append(.up)
                    next.append(.right)
                }
            }
            if x > 0, board[x - 1][y] == .empty {
                directions.append(.left)
                next.append(.none)
            }
            if y < board.count - 1, board[y + 1][x] == .empty {
                if x > 0, boardId[y][x - 1] == boardId[y][x], board[y + 1][x - 1] == .empty {
                    directions.append(.down)
                    next.append(.left)
                } else if x < board[y].count - 1, boardId[y][x + 1] == boardId[y][x], board[y + 1][x + 1] == .empty {
                    directions.append(.down)
                    next.append(.right)
                }
            }
            if x < board[y].count - 1, board[y][x + 1] == .empty {
                directions.append(.right)
                next.append(.none)
            }
        case .bigBlock:
            if y > 0, board[y - 1][x] == .empty {
                if x > 0, boardId[y][x - 1] == boardId[y][x], board[y - 1][x - 1] == .empty {
                    directions.append(.up)
                    next.append(.left)
                } else if x < board[y].count - 1, boardId[y][x + 1] == boardId[y][x], board[y - 1][x + 1] == .empty {
                    directions.append(.up)
                    next.append(.right)
                }
            }
            if x > 0 && board[y][x - 1] == .empty {
                if y > 0, boardId[y - 1][x] == boardId[y][x], board[y - 1][x - 1] == .empty {
                    directions.append(.left)
                    next.append(.up)
                } else if y < board.count - 1, boardId[y + 1][x] == boardId[y][x], board[y + 1][x - 1] == .empty {
                    directions.append(.left)
                    next.append(.down)
                }
            }
            if y < board.count - 1, board[y + 1][x] == .empty {
                if x > 0, boardId[y][x - 1] == boardId[y][x], board[y + 1][x - 1] == .empty {
                    directions.append(.down)
                    next.append(.left)
                } else if x < board[y].count - 1, boardId[y][x + 1] == boardId[y][x], board[y + 1][x + 1] == .empty {
                    directions.append(.down)
                    next.append(.right)
                }
            }
            if x < board[y].count - 1 && board[y][x + 1] == .empty {
                if y > 0, boardId[y - 1][x] == boardId[y][x], board[y - 1][x + 1] == .empty {
                    directions.append(.right)
                    next.append(.up)
                } else if y < board.count - 1, boardId[y + 1][x] == boardId[y][x], board[y + 1][x + 1] == .empty {
                    directions.append(.right)
                    next.append(.down)
                }
            }
        default:
            directions.append(.none)
            next.append(.none)
        }
        completion(directions, next)
    }

    // Check functions for layout node from nodes' board or from BlockType's board
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

    func checkLayoutForLayoutNodeCreationFrom(layout: Layout) -> LayoutNode<Layout>? {
        if self._passedLayoutsRecords.contains(layout.id) || self._passedLayoutsRecords.contains(layout.invertedId) {
            return nil
        }
        self._passedLayoutsRecords.append(layout.id)
        self._passedLayoutsRecords.append(layout.invertedId)
        let childLayoutNode: LayoutNode = LayoutNode(layout)
        return childLayoutNode
    }

    func searchLayoutNodeFromBoard(_ layoutNode: LayoutNode<Layout>) -> [LayoutNode<Layout>] {
        var result: [LayoutNode<Layout>] = []
        let initialBoard: Board = self.createBoardFrom(layout: layoutNode.layout)
        var lineCount: Int = 0
        for nodeLine in initialBoard.nodes {
            var rowCount: Int = 0
            for node in nodeLine {
                self.checkDirectionsForBlockFromBoard(node) { (directions) in
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

    func searchLayoutNodeFromLayout(_ layoutNode: LayoutNode<Layout>) -> [LayoutNode<Layout>] {
        var result: [LayoutNode<Layout>] = []
        var lineCount: Int = 0
        let layout = layoutNode.layout
        for stateLine in layout.state {
            var rowCount: Int = 0
            for _ in stateLine {
                self.checkDirectionForBlockFromState(layout.state, boardId: layout.board, with: lineCount, and: rowCount) { (directions, next) in
                    for (index, direction) in directions.enumerated() {
                        switch direction {
                        case .up:
                            var childState = layout.state
                            var childBoard = layout.board
                            childState[lineCount - 1][rowCount] = layout.state[lineCount][rowCount]
                            childBoard[lineCount - 1][rowCount] = layout.board[lineCount][rowCount]
                            switch layout.state[lineCount][rowCount] {
                            case .verticalBlock:
                                childState[lineCount + 1][rowCount] = .empty
                                childBoard[lineCount + 1][rowCount] = "0"
                            case .horizontalBlock:
                                childState[lineCount - 1][next[index] == .left ? rowCount - 1 : rowCount + 1] = layout.state[lineCount][rowCount]
                                childBoard[lineCount - 1][next[index] == .left ? rowCount - 1 : rowCount + 1] = layout.board[lineCount][rowCount]
                                childState[lineCount][next[index] == .left ? rowCount - 1 : rowCount + 1] = .empty
                                childBoard[lineCount][next[index] == .left ? rowCount - 1 : rowCount + 1] = "0"
                                childState[lineCount][rowCount] = .empty
                                childBoard[lineCount][rowCount] = "0"
                            case .bigBlock:
                                childState[lineCount - 1][next[index] == .left ? rowCount - 1 : rowCount + 1] = layout.state[lineCount][rowCount]
                                childBoard[lineCount - 1][next[index] == .left ? rowCount - 1 : rowCount + 1] = layout.board[lineCount][rowCount]
                                childState[lineCount + 1][next[index] == .left ? rowCount - 1 : rowCount + 1] = .empty
                                childBoard[lineCount + 1][next[index] == .left ? rowCount - 1 : rowCount + 1] = "0"
                                childState[lineCount + 1][rowCount] = .empty
                                childBoard[lineCount + 1][rowCount] = "0"
                            default:
                                childState[lineCount][rowCount] = .empty
                                childBoard[lineCount][rowCount] = "0"
                            }
                            let layoutArrays: ([BlockType], [BlockType]) = Utils.boardArrayToArray(childState)
                            let layout = Layout(id: layoutArrays.0, invertedId: layoutArrays.1, state: childState, board: childBoard)
                            if let childLayoutNode = self.checkLayoutForLayoutNodeCreationFrom(layout: layout) {
                                result.append(childLayoutNode)
                            }
                        case .left:
                            var childState = layout.state
                            var childBoard = layout.board
                            childState[lineCount][rowCount - 1] = layout.state[lineCount][rowCount]
                            childBoard[lineCount][rowCount - 1] = layout.board[lineCount][rowCount]
                            switch layout.state[lineCount][rowCount] {
                            case .verticalBlock:
                                childState[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount - 1] = layout.state[lineCount][rowCount]
                                childBoard[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount - 1] = layout.board[lineCount][rowCount]
                                childState[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount] = .empty
                                childBoard[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount] = "0"
                                childState[lineCount][rowCount] = .empty
                                childBoard[lineCount][rowCount] = "0"
                            case .horizontalBlock:
                                childState[lineCount][rowCount + 1] = .empty
                                childBoard[lineCount][rowCount + 1] = "0"
                            case .bigBlock:
                                childState[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount - 1] = layout.state[lineCount][rowCount]
                                childBoard[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount - 1] = layout.board[lineCount][rowCount]
                                childState[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount + 1] = .empty
                                childBoard[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount + 1] = "0"
                                childState[lineCount][rowCount + 1] = .empty
                                childBoard[lineCount][rowCount + 1] = "0"
                            default:
                                childState[lineCount][rowCount] = .empty
                                childBoard[lineCount][rowCount] = "0"
                            }
                            let layoutArrays: ([BlockType], [BlockType]) = Utils.boardArrayToArray(childState)
                            let layout = Layout(id: layoutArrays.0, invertedId: layoutArrays.1, state: childState, board: childBoard)
                            if let childLayoutNode = self.checkLayoutForLayoutNodeCreationFrom(layout: layout) {
                                result.append(childLayoutNode)
                            }
                        case .down:
                            var childState = layout.state
                            var childBoard = layout.board
                            childState[lineCount + 1][rowCount] = layout.state[lineCount][rowCount]
                            childBoard[lineCount + 1][rowCount] = layout.board[lineCount][rowCount]
                            switch layout.state[lineCount][rowCount] {
                            case .verticalBlock:
                                childState[lineCount - 1][rowCount] = .empty
                                childBoard[lineCount - 1][rowCount] = "0"
                            case .horizontalBlock:
                                childState[lineCount + 1][next[index] == .left ? rowCount - 1 : rowCount + 1] = layout.state[lineCount][rowCount]
                                childBoard[lineCount + 1][next[index] == .left ? rowCount - 1 : rowCount + 1] = layout.board[lineCount][rowCount]
                                childState[lineCount][next[index] == .left ? rowCount - 1 : rowCount + 1] = .empty
                                childBoard[lineCount][next[index] == .left ? rowCount - 1 : rowCount + 1] = "0"
                                childState[lineCount][rowCount] = .empty
                                childBoard[lineCount][rowCount] = "0"
                            case .bigBlock:
                                childState[lineCount + 1][next[index] == .left ? rowCount - 1 : rowCount + 1] = layout.state[lineCount][rowCount]
                                childBoard[lineCount + 1][next[index] == .left ? rowCount - 1 : rowCount + 1] = layout.board[lineCount][rowCount]
                                childState[lineCount - 1][next[index] == .left ? rowCount - 1 : rowCount + 1] = .empty
                                childBoard[lineCount - 1][next[index] == .left ? rowCount - 1 : rowCount + 1] = "0"
                                childState[lineCount - 1][rowCount] = .empty
                                childBoard[lineCount - 1][rowCount] = "0"
                            default:
                                childState[lineCount][rowCount] = .empty
                                childBoard[lineCount][rowCount] = "0"
                            }
                            let layoutArrays: ([BlockType], [BlockType]) = Utils.boardArrayToArray(childState)
                            let layout = Layout(id: layoutArrays.0, invertedId: layoutArrays.1, state: childState, board: childBoard)
                            if let childLayoutNode = self.checkLayoutForLayoutNodeCreationFrom(layout: layout) {
                                result.append(childLayoutNode)
                            }
                        case .right:
                            var childState = layout.state
                            var childBoard = layout.board
                            childState[lineCount][rowCount + 1] = layout.state[lineCount][rowCount]
                            childBoard[lineCount][rowCount + 1] = layout.board[lineCount][rowCount]
                            switch layout.state[lineCount][rowCount] {
                            case .verticalBlock:
                                childState[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount + 1] = layout.state[lineCount][rowCount]
                                childBoard[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount + 1] = layout.board[lineCount][rowCount]
                                childState[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount] = .empty
                                childBoard[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount] = "0"
                                childState[lineCount][rowCount] = .empty
                                childBoard[lineCount][rowCount] = "0"
                            case .horizontalBlock:
                                childState[lineCount][rowCount - 1] = .empty
                                childBoard[lineCount][rowCount - 1] = "0"
                            case .bigBlock:
                                childState[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount + 1] = layout.state[lineCount][rowCount]
                                childBoard[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount + 1] = layout.board[lineCount][rowCount]
                                childState[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount - 1] = .empty
                                childBoard[next[index] == .up ? lineCount - 1 : lineCount + 1][rowCount - 1] = "0"
                                childState[lineCount][rowCount - 1] = .empty
                                childBoard[lineCount][rowCount - 1] = "0"
                            default:
                                childState[lineCount][rowCount] = .empty
                                childBoard[lineCount][rowCount] = "0"
                            }
                            let layoutArrays: ([BlockType], [BlockType]) = Utils.boardArrayToArray(childState)
                            let layout = Layout(id: layoutArrays.0, invertedId: layoutArrays.1, state: childState, board: childBoard)
                            if let childLayoutNode = self.checkLayoutForLayoutNodeCreationFrom(layout: layout) {
                                result.append(childLayoutNode)
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

    // Main AI search path function
    func searchPath(completion: @escaping ([LayoutNode<Layout>]) -> Void) {
        var depth: Int = 1
        while !self._parentLayoutNodes.isEmpty {
            print("-> \(self._parentLayoutNodes.count) for \(depth)")
            for parent in self._parentLayoutNodes {
                if self.checkWin(layoutNode: parent) {
                    DDLogInfo("Found a solution")
                    var resultArray: [LayoutNode<Layout>] = []
                    var pathParent = parent
                    while pathParent.parent != nil {
                        resultArray.append(pathParent)
                        if let source = pathParent.parent {
                            pathParent = source
                        }
                    }
                    completion(resultArray.reversed())
                    return
                }
                let newChildrens = self.searchLayoutNodeFromLayout(parent)
                for newChildren in newChildrens {
                    parent.addChildren(child: newChildren)
                }
                self._childrenLayoutNodes += newChildrens
                self._parentLayoutNodes.removeFirst()
            }
            self._parentLayoutNodes = self._childrenLayoutNodes
            self._childrenLayoutNodes = []
            depth += 1
        }
        DDLogInfo("Didn't find a solution")
    }

    // MARK: Init functions
    init(_ parentVC: MainBoardViewController, initialBoard: Board) {
        self.parentVC = parentVC
        // Create initial layout
        let layout = self.createLayout(fromBoard: initialBoard)
        self._passedLayoutsRecords.append(layout.id)
        if !self._passedLayoutsRecords.contains(layout.invertedId) {
            self._passedLayoutsRecords.append(layout.invertedId)
        }
        // Create initial layout node
        self._initialLayoutNode = self.createLayoutNode(state: layout.state, board: layout.board)
        // First save the parent layout node
        self._parentLayoutNodes.append(self._initialLayoutNode)
    }

}
