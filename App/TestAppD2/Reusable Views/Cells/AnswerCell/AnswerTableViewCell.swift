//
//  AnswerTableViewCell.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

private let codeColorBG: UIColor = UIColor(red: 0, green: 110.0 / 255.0, blue: 200.0 / 255.0, alpha: 0.5)

final class AnswerTableViewCell: UITableViewCell {
	//	MARK: - Private Properties
	@IBOutlet private weak var answerLabel: UILabel!
	@IBOutlet private weak var authorLabel: UILabel!
	@IBOutlet private weak var lastActivityDateLabel: UILabel!
	@IBOutlet private weak var numberOfVotesLabel: UILabel!
	@IBOutlet private weak var checkImageView: UIImageView!
	
	//	MARK: - Public methods
	func fill(_ answer: AnswerItem?) {
		authorLabel.text = answer?.owner?.display_name
		numberOfVotesLabel.text = String(format: "%li", Int(answer?.score ?? 0))
		checkImageView.isHidden = answer?.is_accepted != nil
		setLastActivityDateIfNeeded(by: answer?.last_activity_date)
		setupAnswerLabel(by: answer?.body)
	}
}

//	MARK: - Private Methods
private extension AnswerTableViewCell {
	func setupAnswerLabel(by answerBody: String?) {
		var answerBody: String = answerBody ?? ""
		var attributedString = NSMutableAttributedString(string: answerBody)
		code(by: answerBody,
			 attributedString: &attributedString)
		lineBreak(by: &answerBody,
				  attributedString: &attributedString)
		answerLabel.attributedText = attributedString
	}
	
	func code(by answerBody: String,
			  attributedString: inout NSMutableAttributedString) {
		let pattern = "<code>[^>]+</code>"
		let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
		let matches = regex?.matches(in: answerBody,
									 options: [],
									 range: NSRange(location: 0,
													length: answerBody.count)) ?? []
		for match in matches {
			attributedString.addAttribute(.backgroundColor,
										  value: codeColorBG,
										  range: match.range)
			if let aSize = UIFont(name: "Courier", size: 17) {
				attributedString.addAttribute(.font,
											  value: aSize,
											  range: match.range)
			}
		}
	}
	
	func lineBreak(by answerBody: inout String,
				   attributedString: inout NSMutableAttributedString) {
		var cycle: Bool = true
		while cycle {
			if let aSearch = (answerBody as NSString?)?.range(of: "<[^>]+>",
															  options: .regularExpression), aSearch.location != NSNotFound {
				attributedString.removeAttribute(.backgroundColor,
												 range: aSearch)
				attributedString.replaceCharacters(in: aSearch, with: "\n")
				answerBody = (answerBody as NSString?)?.replacingCharacters(in: aSearch,
																			with: "\n") ?? ""
			} else {
				cycle = false
			}
		}
	}
	
	private func setLastActivityDateIfNeeded(by lastActivityDate: Int?) {
		if let lastActivityDate = lastActivityDate {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "HH:mm d-MM-yyyy"
			let last = TimeInterval(exactly: lastActivityDate) ?? 0
			let from = Date.init(timeIntervalSince1970: last)
			let lastActivityDate = "\(dateFormatter.string(from: from))"
			lastActivityDateLabel.text = lastActivityDate
		}
	}
}
