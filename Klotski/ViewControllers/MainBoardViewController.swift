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
    private var board: Board!
    private var boardDisplay: UIView!
    private var nodesViews: [[UIView]] = []

    // MARK: Functions
    func createBoard(width: Int = 4, height: Int = 5) {
        var cellSize: CGFloat = (self.view.frame.width / CGFloat(width)) * 0.8
        if cellSize * CGFloat(height) > self.view.frame.height {
            cellSize = (self.view.frame.height / CGFloat(height)) * 0.8
        }
        self.board = Board(width: width, height: height)
        self.boardDisplay = UIView(frame: CGRect(x: (self.view.frame.width - (CGFloat(width) * cellSize)) / 2,
                                                 y: (self.view.frame.height - (CGFloat(height) * cellSize)) / 2,
                                                 width: CGFloat(width) * cellSize,
                                                 height: CGFloat(height) * cellSize))
        self.boardDisplay.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.view.addSubview(self.boardDisplay)

        // Place blocks in the board
        self.placeDefaultBlocksInBoard()

        // Display the blocks in the board
        self.createDisplayNodes(with: cellSize)

        // TEST
        print("--> \(self.board.nodes[1][3].canGoLeft())")
    }

    // Default positionning for the blocks
    func placeDefaultBlocksInBoard() {
        self.board.nodes[0][0].block = Block(id: "A", width: 1, height: 2, coordinates: (0, 0))
        self.board.nodes[0][1].block = Block(id: "B", width: 2, height: 2, coordinates: (0, 1))
        self.board.nodes[0][2].block = Block(id: "B", width: 2, height: 2, coordinates: (0, 2))
        self.board.nodes[0][3].block = Block(id: "C", width: 1, height: 2, coordinates: (0, 3))

        self.board.nodes[1][0].block = Block(id: "A", width: 1, height: 2, coordinates: (1, 0))
        self.board.nodes[1][1].block = Block(id: "B", width: 2, height: 2, coordinates: (1, 1))
        self.board.nodes[1][2].block = Block(id: "B", width: 2, height: 2, coordinates: (1, 2))
        self.board.nodes[1][3].block = Block(id: "C", width: 1, height: 2, coordinates: (1, 3))

        self.board.nodes[2][0].block = Block(id: "D", width: 1, height: 2, coordinates: (2, 0))
        self.board.nodes[2][1].block = Block(id: "E", width: 2, height: 1, coordinates: (2, 1))
        self.board.nodes[2][2].block = Block(id: "E", width: 2, height: 1, coordinates: (2, 2))
        self.board.nodes[2][3].block = Block(id: "F", width: 1, height: 2, coordinates: (2, 3))

        self.board.nodes[3][0].block = Block(id: "D", width: 1, height: 2, coordinates: (3, 0))
        self.board.nodes[3][1].block = Block(id: "G", width: 1, height: 1, coordinates: (3, 1))
        self.board.nodes[3][2].block = Block(id: "H", width: 1, height: 1, coordinates: (3, 2))
        self.board.nodes[3][3].block = Block(id: "F", width: 1, height: 2, coordinates: (3, 3))

        self.board.nodes[4][0].block = Block(id: "I", width: 1, height: 1, coordinates: (4, 0))
        self.board.nodes[4][1].block = nil
        self.board.nodes[4][2].block = nil
        self.board.nodes[4][3].block = Block(id: "J", width: 1, height: 1, coordinates: (4, 3))
    }

    // Create the colors for each block
    func createDisplayNodes(with cellSize: CGFloat) {
        var lineCount: Int = 0
        for line in self.board.nodes {
            var nodeCount: Int = 0
            self.nodesViews.append([])
            for node in line {
                let view = UIView(frame: CGRect(x: cellSize * CGFloat(nodeCount),
                                                y: cellSize * CGFloat(lineCount),
                                                width: cellSize,
                                                height: cellSize))
                if let currentBlock = node.block {
                    switch currentBlock.type {
                    case .bigBlock:
                        if lineCount - 1 >= 0, nodeCount - 1 >= 0, let block = self.board.nodes[lineCount - 1][nodeCount - 1].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.bottom, .right], color: .klotskiLightGray)
                        }
                        if lineCount + 1 < self.board.width, nodeCount - 1 >= 0, let block = self.board.nodes[lineCount + 1][nodeCount - 1].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.top, .right], color: .klotskiLightGray)
                        }
                        if lineCount - 1 >= 0, nodeCount + 1 < self.board.width, let block = self.board.nodes[lineCount - 1][nodeCount + 1].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.left, .bottom], color: .klotskiLightGray)
                        }
                        if lineCount + 1 < self.board.width, nodeCount + 1 < self.board.width, let block = self.board.nodes[lineCount + 1][nodeCount + 1].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.top, .left], color: .klotskiLightGray)
                        }
                        view.backgroundColor = .pastelBlue
                    case .smallBlock:
                        view.addBorders(edges: [.all], color: .klotskiLightGray)
                        view.backgroundColor = .pastelYellow
                    case .verticalBlock:
                        if lineCount - 1 >= 0, let block = self.board.nodes[lineCount - 1][nodeCount].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.left, .bottom, .right], color: .klotskiLightGray)
                        }
                        if lineCount + 1 < self.board.width, let block = self.board.nodes[lineCount + 1][nodeCount].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.top, .left, .right], color: .klotskiLightGray)
                        }
                        view.backgroundColor = .pastelPink
                    case .horizontalBlock:
                        if nodeCount - 1 >= 0, let block = self.board.nodes[lineCount][nodeCount - 1].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.top, .bottom, .right], color: .klotskiLightGray)
                        }
                        if nodeCount + 1 < self.board.width, let block = self.board.nodes[lineCount][nodeCount + 1].block, block.id == currentBlock.id {
                            view.addBorders(edges: [.top, .left, .bottom], color: .klotskiLightGray)
                        }
                        view.backgroundColor = .pastelGreen
                    default:
                        break
                    }
                }
                self.nodesViews[lineCount].append(view)
                self.boardDisplay.addSubview(view)
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
