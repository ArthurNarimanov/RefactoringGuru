//
//  IdentifiableClass.swift
//  TestAppD2
//
//  Created by Arthur Narimanov on 8/7/21.
//  Copyright © 2021 Григорий Соловьев. All rights reserved.
//

import UIKit

/// Sets the identifier by the class name
protocol IdentifiableClass: AnyObject {
	static var id: String { get }
}

extension IdentifiableClass {
	static var id: String {
		return String(describing: self)
	}
}

extension UITableViewCell: IdentifiableClass {}
