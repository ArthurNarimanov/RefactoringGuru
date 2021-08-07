//
//  MenuViewController.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController {
	// MARK: - Private properties
    @IBOutlet private weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
		super.viewDidLoad()
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Tags.allCases.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellForMenuTableView",
																  for: indexPath)
		cell.textLabel?.text = Tags.allCases[indexPath.row].rawValue
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		NotificationCenter.default.post(name: NSNotification.Name("RequestedTagNotification"),
										object: Tags.allCases[indexPath.row].rawValue)
	}
}
