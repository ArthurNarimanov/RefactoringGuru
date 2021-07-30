//
//  AppDelegate.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let splitViewController = window?.rootViewController as? UISplitViewController
        let navigationController = splitViewController?.viewControllers.last as? UINavigationController
        navigationController?.topViewController?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        splitViewController?.delegate = self
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
							 collapseSecondary secondaryViewController: UIViewController,
							 onto primaryViewController: UIViewController) -> Bool {
        return true
    }

}

