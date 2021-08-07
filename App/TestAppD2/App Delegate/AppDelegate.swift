//
//  AppDelegate.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		MainBuild.setSpitVC(rootVC: window?.rootViewController,
							delegate: self)
		return true
	}
	
}

extension AppDelegate: UISplitViewControllerDelegate {
	func splitViewController(_ splitViewController: UISplitViewController,
							 collapseSecondary secondaryViewController: UIViewController,
							 onto primaryViewController: UIViewController) -> Bool {
		return true
	}
}
