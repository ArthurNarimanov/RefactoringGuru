//
//  QuestionTableViewCell.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

final class QuestionTableViewCell: UITableViewCell {
	
	//	MARK: - Private Properties
	@IBOutlet private weak var questionLabel: UILabel!
	@IBOutlet private weak var authorLabel: UILabel!
	@IBOutlet private weak var dateModificationLabel: UILabel!
	@IBOutlet private weak var numberOfAnswerLabel: UILabel!
	@IBOutlet private weak var corneredView: UIView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setupCorneredView()
	}
	
	//	MARK: - Public Methods
	func fill(_ question: Item?) {
		questionLabel.text = question?.title
		authorLabel.text = question?.owner?.display_name
		numberOfAnswerLabel.text = String(format: "%li", Int(question?.answer_count ?? 0))
		let lastActivityDate = question?.last_activity_date ?? 0
		setTextModificationLabel(by: lastActivityDate,
								 with: question?.smartDateFormat)
	}
}

//	MARK: - Private Methods
private extension QuestionTableViewCell {
	func setupCorneredView() {
		corneredView.layer.cornerRadius = 20
		corneredView.layer.masksToBounds = false
		corneredView.layer.shadowOpacity = 0.2
		corneredView.layer.shadowColor = UIColor.black.cgColor
		corneredView.layer.shadowOffset = CGSize.zero
		corneredView.layer.shadowRadius = 5
	}
	
	func setTextModificationLabel(by lastActivityDate: Int,
								  with smartDateFormat: String?) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm d-MM-yyyy"
		if let aFormat = smartDateFormat {
			let aDate = Date.init(timeIntervalSince1970: TimeInterval(exactly: lastActivityDate)!)
			dateModificationLabel.text = "\(dateFormatter.string(from: aDate)) \(aFormat)"
		}
	}
}
