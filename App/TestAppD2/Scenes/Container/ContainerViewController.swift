//
//  ContainerViewController.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

final class ContainerViewController: UIViewController {
	// MARK: - Private properties
    @IBOutlet private weak var tableContainerView: UIView!
    @IBOutlet private weak var mainContainerView: UIView!
    @IBOutlet private weak var leadingTableViewLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var trailingTableViewLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerNavigationItem: UINavigationItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = Tags.objc.rawValue
        NotificationCenter.default.addObserver(self,
											   selector: #selector(self.requestedTagNotification(_:)),
											   name: NSNotification.Name("RequestedTagNotification"),
											   object: nil)
    }

	deinit {
		NotificationCenter.default.removeObserver(self,
												  name: NSNotification.Name("RequestedTagNotification"),
												  object: nil)
	}
	
    @objc func requestedTagNotification(_ notification: NSNotification) {
		let tag = notification.object as? String
		let requestedTag = tag ?? Tags.objc.rawValue
        title = requestedTag
    }
    
    @IBAction private func menu(_ sender: Any) {
        if leadingTableViewLayoutConstraint.constant == 0 {
			let size: CGSize = UIScreen.main.bounds.size
            leadingTableViewLayoutConstraint.constant = size.width / 2
            trailingTableViewLayoutConstraint.constant = size.width * -0.5
            UIView.animate(withDuration: 0.3,
						   delay: 0.0,
						   options: .layoutSubviews,
						   animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            leadingTableViewLayoutConstraint.constant = 0
            trailingTableViewLayoutConstraint.constant = 0
            UIView.animate(withDuration: 0.3,
						   delay: 0.0,
						   options: .layoutSubviews,
						   animations: {
                self.view.layoutIfNeeded()
            })
        }
    }    
}
