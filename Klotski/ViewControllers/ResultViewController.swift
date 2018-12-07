//
//  ResultViewController.swift
//  Klotski
//
//  Created by Malenea on 07/12/2018.
//  Copyright © 2018 Malenea. All rights reserved.
//

// MARK: Native imports
import UIKit

// MARK: Frameworks imports
// Logs
import CocoaLumberjack
// UI
import Pageboy

class ResultViewController: PageboyViewController {
    // MARK: Variables
    // Reference to parent view controller
    var parentVC: RootViewController!

    // Views variables
    var viewControllers: [UIViewController] = []

    // Button variables
    var _searchButton: TransitionButton!

    // Label variables
    var _depthLabel: UILabel!

    // Control variable
    var _isFinished: Bool = false

    // MARK: Functions
    @objc func actionForTappedOnSearch(_ sender: UIButton) {
        self._searchButton.startAnimation()
        self.parentVC.startPathSearch()
        self._depthLabel.backgroundColor = UIColor.white.withAlphaComponent(0.4)
    }

    func initResultViewWithDefault(defaultView: UIView) {
        let defaultViewController = UIViewController()
        defaultViewController.view.addSubview(defaultView)
        self.viewControllers.append(defaultViewController)
        self._searchButton = TransitionButton(frame: CGRect(x: (self.view.frame.width - 160.0) / 2,
                                                            y: self.view.frame.height - 160.0,
                                                            width: 160.0,
                                                            height: 50.0))
        self._searchButton.layer.cornerRadius = self._searchButton.frame.height / 2
        self._searchButton.spinnerColor = .white
        self._searchButton.backgroundColor = .pastelPurple
        self._searchButton.setAttributedTitle("Search", withColor: .white, withFont: UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.heavy))
        self._searchButton.addTarget(self, action: #selector(self.actionForTappedOnSearch), for: .touchUpInside)
        self.view.addSubview(self._searchButton)
        self._depthLabel = UILabel(frame: CGRect(x: (self.view.frame.width - 240.0) / 2,
                                                 y: self.view.frame.height - 90.0,
                                                 width: 240.0,
                                                 height: 30.0))
        self._depthLabel.setAttributedText("", withColor: .defaultBlack, withFont: UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.heavy))
        self._depthLabel.textAlignment = .center
        self.view.addSubview(self._depthLabel)
        let title = UIImageView(frame: CGRect(x: (self.view.frame.width - 240.0) / 2,
                                              y: 30.0,
                                              width: 240.0,
                                              height: 48.0))
        title.image = UIImage(named: "KlotskiTitle")
        self.view.addSubview(title)
    }

    // MARK: Override functions
    override func viewDidAppear(_ animated: Bool) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the datasource to self
        self.dataSource = self

        // Set the root background
        self.view.backgroundColor = .clear
    }
}

extension ResultViewController: PageboyViewControllerDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return self.viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        if self._isFinished {
            self._depthLabel.setAttributedText("Depth: \(index + 1)", withColor: .defaultBlack, withFont: UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.heavy))
        }
        return self.viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.at(index: 0)
    }

}
