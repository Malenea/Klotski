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
    var parentVC: RootViewController!
    
    // Initial layout and layouts records
    private var _initialLayoutNode: LayoutNode<Layout>!
    private var _passedLayoutsRecords: [[BlockType]: Bool] = [:]

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
        return layout.state[layout.state.count - 1][(layout.state[0].count / 2) - 1].rawValue == layout.state[layout.state.count - 1][layout.state[0].count / 2].rawValue &&
        layout.state[layout.state.count - 1][layout.state[0].count / 2].rawValue == layout.state[layout.state.count - 2][(layout.state[0].count / 2) - 1].rawValue &&
        layout.state[layout.state.count - 2][(layout.state[0].count / 2) - 1].rawValue == layout.state[layout.state.count - 2][layout.state[0].count / 2].rawValue &&
        layout.state[layout.state.count - 2][layout.state[0].count / 2].rawValue == BlockType.bigBlock.rawValue
//        return (layout.state[3][1].rawValue == layout.state[3][2].rawValue && layout.state[3][2].rawValue == layout.state[4][1].rawValue &&
//            layout.state[4][1].rawValue == layout.state[4][2].rawValue && layout.state[4][1].rawValue == BlockType.bigBlock.rawValue)
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

    func checkDirectionForBlockFromState(_ board: [[BlockType]], boardId: [[String]], with y: Int, and x: Int, completion: @escaping ([Direction]) -> Void) {
        var directions: [Direction] = []
        switch board[y][x] {
        case .smallBlock:
            if y > 0, board[y - 1][x] == .empty {
                directions.append(.up)
            }
            if x > 0, board[y][x - 1] == .empty {
                directions.append(.left)
            }
            if y < board.count - 1, board[y + 1][x] == .empty {
                directions.append(.down)
            }
            if x < board[y].count - 1, board[y][x + 1] == .empty {
                directions.append(.right)
            }
        case .verticalBlock:
            if y > 0, board[y - 1][x] == .empty {
                directions.append(.up)
            }
            if x > 0, board[y][x - 1] == .empty {
                if y > 0, boardId[y - 1][x] == boardId[y][x], board[y - 1][x - 1] == .empty {
                    directions.append(.left)
                }
                if y < board[y].count - 1, boardId[y + 1][x] == boardId[y][x], board[y + 1][x - 1] == .empty {
                    directions.append(.left)
                }
            }
            if y < board.count - 1, board[y + 1][x] == .empty {
                directions.append(.down)
            }
            if x < board[y].count - 1, board[y][x + 1] == .empty {
                if y > 0, boardId[y - 1][x] == boardId[y][x], board[y - 1][x + 1] == .empty {
                    directions.append(.right)
                }
                if y < board[y].count - 1, boardId[y + 1][x] == boardId[y][x], board[y + 1][x + 1] == .empty {
                    directions.append(.right)
                }
            }
        case .horizontalBlock:
            if y > 0, board[y - 1][x] == .empty {
                if x > 0, boardId[y][x - 1] == boardId[y][x], board[y - 1][x - 1] == .empty {
                    directions.append(.up)
                }
                if x < board[y].count - 1, boardId[y][x + 1] == boardId[y][x], board[y - 1][x + 1] == .empty {
                    directions.append(.up)
                }
            }
            if x > 0, board[y][x - 1] == .empty {
                directions.append(.left)
            }
            if y < board.count - 1, board[y + 1][x] == .empty {
                if x > 0, boardId[y][x - 1] == boardId[y][x], board[y + 1][x - 1] == .empty {
                    directions.append(.down)
                }
                if x < board[y].count - 1, boardId[y][x + 1] == boardId[y][x], board[y + 1][x + 1] == .empty {
                    directions.append(.down)
                }
            }
            if x < board[y].count - 1, board[y][x + 1] == .empty {
                directions.append(.right)
            }
        case .bigBlock:
            if y > 0, board[y - 1][x] == .empty {
                if x > 0, boardId[y][x - 1] == boardId[y][x], board[y - 1][x - 1] == .empty {
                    directions.append(.up)
                }
                if x < board[y].count - 1, boardId[y][x + 1] == boardId[y][x], board[y - 1][x + 1] == .empty {
                    directions.append(.up)
                }
            }
            if x > 0, board[y][x - 1] == .empty {
                if y > 0, boardId[y - 1][x] == boardId[y][x], board[y - 1][x - 1] == .empty {
                    directions.append(.left)
                }
                if y < board[y].count - 1, boardId[y + 1][x] == boardId[y][x], board[y + 1][x - 1] == .empty {
                    directions.append(.left)
                }
            }
            if y < board.count - 1, board[y + 1][x] == .empty {
                if x > 0, boardId[y][x - 1] == boardId[y][x], board[y + 1][x - 1] == .empty {
                    directions.append(.down)
                }
                if x < board[y].count - 1, boardId[y][x + 1] == boardId[y][x], board[y + 1][x + 1] == .empty {
                    directions.append(.down)
                }
            }
            if x < board[y].count - 1, board[y][x + 1] == .empty {
                if y > 0, boardId[y - 1][x] == boardId[y][x], board[y - 1][x + 1] == .empty {
                    directions.append(.right)
                }
                if y < board[y].count - 1, boardId[y + 1][x] == boardId[y][x], board[y + 1][x + 1] == .empty {
                    directions.append(.right)
                }
            }
        default:
            directions.append(.none)
        }
        completion(directions)
    }

    // Check functions for layout node from nodes' board or from BlockType's board
    func checkLayoutForLayoutNodeCreationFrom(board: Board) -> LayoutNode<Layout>? {
        let layout = self.createLayout(fromBoard: board)
        if self._passedLayoutsRecords[layout.id] != nil ||
        self._passedLayoutsRecords[layout.invertedId] != nil {
            return nil
        }
        self._passedLayoutsRecords[layout.id] = true
        self._passedLayoutsRecords[layout.invertedId] = true
        let childLayoutNode: LayoutNode = LayoutNode(layout)
        return childLayoutNode
    }

    func checkLayoutForLayoutNodeCreationFrom(layout: Layout) -> LayoutNode<Layout>? {
        if self._passedLayoutsRecords[layout.id] != nil ||
            self._passedLayoutsRecords[layout.invertedId] != nil {
            return nil
        }
        self._passedLayoutsRecords[layout.id] = true
        self._passedLayoutsRecords[layout.invertedId] = true
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

    func modifyNodeInLayout(state: [[BlockType]], board: [[String]], direction: Direction, y: Int, x: Int) -> ([[BlockType]], [[String]]) {
        var childState: [[BlockType]] = state
        var childBoard: [[String]] = board
        let currentNodeState: BlockType = state[y][x]
        let currentNodeName: String = board[y][x]
        switch direction {
        case .up:
            childState[y - 1][x] = currentNodeState
            childBoard[y - 1][x] = currentNodeName
            switch currentNodeState {
            case .smallBlock:
                childState[y][x] = .empty
                childBoard[y][x] = "0"
            case .verticalBlock:
                childState[y + 1][x] = .empty
                childBoard[y + 1][x] = "0"
            case .horizontalBlock:
                childState[y][x] = .empty
                childBoard[y][x] = "0"
                if x > 0, board[y][x - 1] == currentNodeName {
                    childState[y - 1][x - 1] = currentNodeState
                    childBoard[y - 1][x - 1] = currentNodeName
                    childState[y][x - 1] = .empty
                    childBoard[y][x - 1] = "0"
                }
                if x < board[y].count - 1, board[y][x + 1] == currentNodeName {
                    childState[y - 1][x + 1] = currentNodeState
                    childBoard[y - 1][x + 1] = currentNodeName
                    childState[y][x + 1] = .empty
                    childBoard[y][x + 1] = "0"
                }
            case .bigBlock:
                childState[y + 1][x] = .empty
                childBoard[y + 1][x] = "0"
                if x > 0, board[y][x - 1] == currentNodeName {
                    childState[y - 1][x - 1] = currentNodeState
                    childBoard[y - 1][x - 1] = currentNodeName
                    childState[y + 1][x - 1] = .empty
                    childBoard[y + 1][x - 1] = "0"
                }
                if x < board[y].count - 1, board[y][x + 1] == currentNodeName {
                    childState[y - 1][x + 1] = currentNodeState
                    childBoard[y - 1][x + 1] = currentNodeName
                    childState[y + 1][x + 1] = .empty
                    childBoard[y + 1][x + 1] = "0"
                }
            default:
                break
            }
        case .left:
            childState[y][x - 1] = currentNodeState
            childBoard[y][x - 1] = currentNodeName
            switch currentNodeState {
            case .smallBlock:
                childState[y][x] = .empty
                childBoard[y][x] = "0"
            case .verticalBlock:
                childState[y][x] = .empty
                childBoard[y][x] = "0"
                if y > 0, board[y - 1][x] == currentNodeName {
                    childState[y - 1][x - 1] = currentNodeState
                    childBoard[y - 1][x - 1] = currentNodeName
                    childState[y - 1][x] = .empty
                    childBoard[y - 1][x] = "0"
                }
                if y < board.count - 1, board[y + 1][x] == currentNodeName {
                    childState[y + 1][x - 1] = currentNodeState
                    childBoard[y + 1][x - 1] = currentNodeName
                    childState[y + 1][x] = .empty
                    childBoard[y + 1][x] = "0"
                }
            case .horizontalBlock:
                childState[y][x + 1] = .empty
                childBoard[y][x + 1] = "0"
            case .bigBlock:
                childState[y][x + 1] = .empty
                childBoard[y][x + 1] = "0"
                if y > 0, board[y - 1][x] == currentNodeName {
                    childState[y - 1][x - 1] = currentNodeState
                    childBoard[y - 1][x - 1] = currentNodeName
                    childState[y - 1][x + 1] = .empty
                    childBoard[y - 1][x + 1] = "0"
                }
                if y < board.count - 1, board[y + 1][x] == currentNodeName {
                    childState[y + 1][x - 1] = currentNodeState
                    childBoard[y + 1][x - 1] = currentNodeName
                    childState[y + 1][x + 1] = .empty
                    childBoard[y + 1][x + 1] = "0"
                }
            default:
                break
            }
        case .down:
            childState[y + 1][x] = currentNodeState
            childBoard[y + 1][x] = currentNodeName
            switch currentNodeState {
            case .smallBlock:
                childState[y][x] = .empty
                childBoard[y][x] = "0"
            case .verticalBlock:
                childState[y - 1][x] = .empty
                childBoard[y - 1][x] = "0"
            case .horizontalBlock:
                childState[y][x] = .empty
                childBoard[y][x] = "0"
                if x > 0, board[y][x - 1] == currentNodeName {
                    childState[y + 1][x - 1] = currentNodeState
                    childBoard[y + 1][x - 1] = currentNodeName
                    childState[y][x - 1] = .empty
                    childBoard[y][x - 1] = "0"
                }
                if x < board[y].count - 1, board[y][x + 1] == currentNodeName {
                    childState[y + 1][x + 1] = currentNodeState
                    childBoard[y + 1][x + 1] = currentNodeName
                    childState[y][x + 1] = .empty
                    childBoard[y][x + 1] = "0"
                }
            case .bigBlock:
                childState[y - 1][x] = .empty
                childBoard[y - 1][x] = "0"
                if x > 0, board[y][x - 1] == currentNodeName {
                    childState[y + 1][x - 1] = currentNodeState
                    childBoard[y + 1][x - 1] = currentNodeName
                    childState[y - 1][x - 1] = .empty
                    childBoard[y - 1][x - 1] = "0"
                }
                if x < board[y].count - 1, board[y][x + 1] == currentNodeName {
                    childState[y + 1][x + 1] = currentNodeState
                    childBoard[y + 1][x + 1] = currentNodeName
                    childState[y - 1][x + 1] = .empty
                    childBoard[y - 1][x + 1] = "0"
                }
            default:
                break
            }
        case .right:
            childState[y][x + 1] = currentNodeState
            childBoard[y][x + 1] = currentNodeName
            switch currentNodeState {
            case .smallBlock:
                childState[y][x] = .empty
                childBoard[y][x] = "0"
            case .verticalBlock:
                childState[y][x] = .empty
                childBoard[y][x] = "0"
                if y > 0, board[y - 1][x] == currentNodeName {
                    childState[y - 1][x + 1] = currentNodeState
                    childBoard[y - 1][x + 1] = currentNodeName
                    childState[y - 1][x] = .empty
                    childBoard[y - 1][x] = "0"
                }
                if y < board.count - 1, board[y + 1][x] == currentNodeName {
                    childState[y + 1][x + 1] = currentNodeState
                    childBoard[y + 1][x + 1] = currentNodeName
                    childState[y + 1][x] = .empty
                    childBoard[y + 1][x] = "0"
                }
            case .horizontalBlock:
                childState[y][x - 1] = .empty
                childBoard[y][x - 1] = "0"
            case .bigBlock:
                childState[y][x - 1] = .empty
                childBoard[y][x - 1] = "0"
                if y > 0, board[y - 1][x] == currentNodeName {
                    childState[y - 1][x + 1] = currentNodeState
                    childBoard[y - 1][x + 1] = currentNodeName
                    childState[y - 1][x - 1] = .empty
                    childBoard[y - 1][x - 1] = "0"
                }
                if y < board.count - 1, board[y + 1][x] == currentNodeName {
                    childState[y + 1][x + 1] = currentNodeState
                    childBoard[y + 1][x + 1] = currentNodeName
                    childState[y + 1][x - 1] = .empty
                    childBoard[y + 1][x - 1] = "0"
                }
            default:
                break
            }
        default:
            break
        }
        return (childState, childBoard)
    }

    func searchLayoutNodeFromLayout(_ layoutNode: LayoutNode<Layout>) -> [LayoutNode<Layout>] {
        var result: [LayoutNode<Layout>] = []
        var lineCount: Int = 0
        let layout = layoutNode.layout
        for stateLine in layout.state {
            var rowCount: Int = 0
            for _ in stateLine {
                self.checkDirectionForBlockFromState(layout.state, boardId: layout.board, with: lineCount, and: rowCount) { (directions) in
                    for direction in directions {
                        let stateBoardArray: ([[BlockType]], [[String]]) = self.modifyNodeInLayout(state: layout.state, board: layout.board, direction: direction, y: lineCount, x: rowCount)
                        let layoutArray: ([BlockType], [BlockType]) = Utils.boardArrayToArray(stateBoardArray.0)
                        let layout: Layout = Layout(id: layoutArray.0, invertedId: layoutArray.1, state: stateBoardArray.0, board: stateBoardArray.1)
                        if let childLayoutNode = self.checkLayoutForLayoutNodeCreationFrom(layout: layout) {
                            result.append(childLayoutNode)
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
            DDLogInfo("Got \(self._parentLayoutNodes.count) occurences for depth \(depth)")
            DispatchQueue.main.async {
                self.parentVC._resultViewController._depthLabel.setAttributedText("Searching with depth: \(depth)", withColor: .defaultBlack, withFont: UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.heavy))
            }
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
            }
            self._parentLayoutNodes = self._childrenLayoutNodes
            self._childrenLayoutNodes = []
            depth += 1
        }
        DDLogInfo("Didn't find a solution")
    }

    // MARK: Init functions
    init(_ parentVC: RootViewController, initialBoard: Board) {
        self.parentVC = parentVC
        // Create initial layout
        let layout = self.createLayout(fromBoard: initialBoard)
        self._passedLayoutsRecords[layout.id] = true
        if self._passedLayoutsRecords[layout.invertedId] == nil {
            self._passedLayoutsRecords[layout.invertedId] = true
        }
        // Create initial layout node
        self._initialLayoutNode = self.createLayoutNode(state: layout.state, board: layout.board)
        // First save the parent layout node
        self._parentLayoutNodes.append(self._initialLayoutNode)
    }

}
