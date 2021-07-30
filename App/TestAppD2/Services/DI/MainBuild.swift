//
//  MainBuild.swift
//  TestAppD2
//
//  Created by Arthur Narimanov on 7/30/21.
//  Copyright © 2021 Григорий Соловьев. All rights reserved.
//

import UIKit

protocol Buildable {
	static func setSpitVC(rootVC: UIViewController?,
						  delegate: UISplitViewControllerDelegate)
}

struct MainBuild: Buildable {
	static func setSpitVC(rootVC: UIViewController?,
						  delegate: UISplitViewControllerDelegate) {
		guard let splitViewController = rootVC as? UISplitViewController else { return }
		let navigationController = splitViewController.viewControllers.last as? UINavigationController
		
		navigationController?.topViewController?
			.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
		splitViewController.delegate = delegate
	}
}
