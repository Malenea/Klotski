//
//  RootViewController.swift
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
// UI
import Pageboy

class RootViewController: PageboyViewController {

    // MARK: Variables
    // Views variables
    private var viewControllers: [UIViewController] = []
    private var mainBoardVC: UIViewController = {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .green
        return viewController
    }()
    // Control variables
    private enum PageVC: Int {
        case mainBoard = 0
    }

    // MARK: Override functions
    override func viewDidAppear(_ animated: Bool) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Populate view controllers array
        self.viewControllers.append(self.mainBoardVC)

        // Set the datasource to self
        self.dataSource = self

        // Remove the scrolling possibilities
        self.isScrollEnabled = false
    }

}

extension RootViewController: PageboyViewControllerDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return self.viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return self.viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.at(index: PageVC.mainBoard.rawValue)
    }

}
