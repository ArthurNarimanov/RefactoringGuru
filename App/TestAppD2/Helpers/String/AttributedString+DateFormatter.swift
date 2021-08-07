//
//  AttributedString+DateFormatter.swift
//  TestAppD2
//
//  Created by Arthur Narimanov on 8/7/21.
//  Copyright © 2021 Григорий Соловьев. All rights reserved.
//

import UIKit

struct AttributedString {
	static func getTitleWithDateNow(by title: String, dateFormat: String = "MMM d, h:mm a") -> NSAttributedString? {
		let formatter = DateFormatter()
		formatter.dateFormat = dateFormat
		let title = "\(title) \(formatter.string(from: Date()))"
		let attributesDictionary = [NSAttributedString.Key.foregroundColor : UIColor.black]
		return NSAttributedString(string: title, attributes: attributesDictionary)
	}
}
