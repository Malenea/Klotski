//
//  MainBoardViewController.swift
//  Klotski
//
//  Created by Malenea on 04/12/2018.
//  Copyright © 2018 Malenea. All rights reserved.
//

// MARK: Native imports
import UIKit

// MARK: Frameworks imports
// Logs
import CocoaLumberjack

class MainBoardViewController: UIViewController {

    // MARK: Variables
    private var _cellSize: CGFloat!
    private var _board: Board!
    private var _boardWidth: Int!
    private var _boardHeight: Int!
    private var _boardDisplay: UIView!
    private var _AI: AI!
    // Getters
    var boardWidth: Int {
        get {
            return self._boardWidth
        }
    }
    var boardHeight: Int {
        get {
            return self._boardHeight
        }
    }

    // MARK: Functions
    func createBoard(width: Int = 4, height: Int = 5) {
        var cellSize: CGFloat = (self.view.frame.width / CGFloat(width)) * 0.8
        if cellSize * CGFloat(height) > self.view.frame.height {
            cellSize = (self.view.frame.height / CGFloat(height)) * 0.8
        }
        self._cellSize = cellSize
        self._boardWidth = width
        self._boardHeight = height
        self._board = Board(height: height, width: width)
        self._boardDisplay = UIView(frame: CGRect(x: (self.view.frame.width - (CGFloat(width) * cellSize)) / 2,
                                                 y: (self.view.frame.height - (CGFloat(height) * cellSize)) / 2,
                                                 width: CGFloat(width) * cellSize,
                                                 height: CGFloat(height) * cellSize))
        self._boardDisplay.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.view.addSubview(self._boardDisplay)

        // Place blocks in the board
        self.placeDefaultBlocksInBoard()

        // Init the AI with the board
        self._AI = AI(self, initialBoard: self._board)

        // Display the blocks in the board
        self.createDisplayNodes(from: self._board, with: self._cellSize)

        DispatchQueue.global(qos: .background).async {
            self._AI.searchPath() { layoutNodes in
                DispatchQueue.main.async {
                    for node in layoutNodes {
                        print("~> \(node.layout.board)")
                        let updatedBoard = self._AI.createBoardFrom(layout: node.layout)
                        self._boardDisplay.removeFromSuperview()
                        self.createDisplayNodes(from: updatedBoard, with: self._cellSize)
                        self.view.addSubview(self._boardDisplay)
                        sleep(1)
                    }
                }
            }
        }
    }

    // Default positionning for the blocks
    func placeDefaultBlocksInBoard() {
        self._board.nodes[0][0].block = Block(id: "A", height: 2, width: 1, coordinates: (0, 0))
        self._board.nodes[0][1].block = Block(id: "B", height: 2, width: 2, coordinates: (0, 1))
        self._board.nodes[0][2].block = Block(id: "B", height: 2, width: 2, coordinates: (0, 2))
        self._board.nodes[0][3].block = Block(id: "C", height: 2, width: 1, coordinates: (0, 3))

        self._board.nodes[1][0].block = Block(id: "A", height: 2, width: 1, coordinates: (1, 0))
        self._board.nodes[1][1].block = Block(id: "B", height: 2, width: 2, coordinates: (1, 1))
        self._board.nodes[1][2].block = Block(id: "B", height: 2, width: 2, coordinates: (1, 2))
        self._board.nodes[1][3].block = Block(id: "C", height: 2, width: 1, coordinates: (1, 3))

        self._board.nodes[2][0].block = Block(id: "D", height: 2, width: 1, coordinates: (2, 0))
        self._board.nodes[2][1].block = Block(id: "E", height: 1, width: 2, coordinates: (2, 1))
        self._board.nodes[2][2].block = Block(id: "E", height: 1, width: 2, coordinates: (2, 2))
        self._board.nodes[2][3].block = Block(id: "F", height: 2, width: 1, coordinates: (2, 3))

        self._board.nodes[3][0].block = Block(id: "D", height: 2, width: 1, coordinates: (3, 0))
        self._board.nodes[3][1].block = Block(id: "G", height: 1, width: 1, coordinates: (3, 1))
        self._board.nodes[3][2].block = Block(id: "H", height: 1, width: 1, coordinates: (3, 2))
        self._board.nodes[3][3].block = Block(id: "F", height: 2, width: 1, coordinates: (3, 3))

        self._board.nodes[4][0].block = Block(id: "I", height: 1, width: 1, coordinates: (4, 0))
        self._board.nodes[4][1].block = nil
        self._board.nodes[4][2].block = nil
        self._board.nodes[4][3].block = Block(id: "J", height: 1, width: 1, coordinates: (4, 3))
    }

    // Create the colors for each block
    func createDisplayNodes(from board: Board, with cellSize: CGFloat) {
        self._boardDisplay.removeAllSubviews()
        var lineCount: Int = 0
        for line in board.nodes {
            var nodeCount: Int = 0
            for node in line {
                let view = UIView(frame: CGRect(x: cellSize * CGFloat(nodeCount),
                                                y: cellSize * CGFloat(lineCount),
                                                width: cellSize,
                                                height: cellSize))
                if let currentBlock = node.block {
                    switch currentBlock.type {
                    case .bigBlock:
                        if lineCount - 1 >= 0, nodeCount - 1 >= 0, let block = board.nodes[lineCount - 1][nodeCount - 1].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.bottom, .right], color: .klotskiLightGray)
                        }
                        if lineCount + 1 < board.width, nodeCount - 1 >= 0, let block = board.nodes[lineCount + 1][nodeCount - 1].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.top, .right], color: .klotskiLightGray)
                        }
                        if lineCount - 1 >= 0, nodeCount + 1 < board.width, let block = board.nodes[lineCount - 1][nodeCount + 1].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.left, .bottom], color: .klotskiLightGray)
                        }
                        if lineCount + 1 < board.width, nodeCount + 1 < board.width, let block = board.nodes[lineCount + 1][nodeCount + 1].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.top, .left], color: .klotskiLightGray)
                        }
                        view.backgroundColor = .pastelBlue
                    case .smallBlock:
                        view.addBorders(edges: [.all], color: .klotskiLightGray)
                        view.backgroundColor = .pastelYellow
                    case .verticalBlock:
                        if lineCount - 1 >= 0, let block = board.nodes[lineCount - 1][nodeCount].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.left, .bottom, .right], color: .klotskiLightGray)
                        }
                        if lineCount + 1 < board.width, let block = board.nodes[lineCount + 1][nodeCount].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.top, .left, .right], color: .klotskiLightGray)
                        }
                        view.backgroundColor = .pastelPink
                    case .horizontalBlock:
                        if nodeCount - 1 >= 0, let block = board.nodes[lineCount][nodeCount - 1].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.top, .bottom, .right], color: .klotskiLightGray)
                        }
                        if nodeCount + 1 < board.width, let block = board.nodes[lineCount][nodeCount + 1].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.top, .left, .bottom], color: .klotskiLightGray)
                        }
                        view.backgroundColor = .pastelGreen
                    default:
                        break
                    }
                }
                self._boardDisplay.addSubview(view)
                nodeCount += 1
            }
            lineCount += 1
        }
    }

    // MARK: Override functions
    override func viewDidAppear(_ animated: Bool) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the background
        let backgroundView = UIImageView(frame: self.view.frame)
        backgroundView.image = UIImage(named: "Background")
        self.view.addSubview(backgroundView)

        // Create the board
        self.createBoard()
    }

}
