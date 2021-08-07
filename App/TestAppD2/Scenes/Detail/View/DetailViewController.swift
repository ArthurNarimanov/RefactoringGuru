//
//  DetailViewController.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
	// MARK: - Private properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var titleNavigationItem: UINavigationItem!
	
    private var refreshControl: UIRefreshControl!
    private var activityIndicatorView: UIActivityIndicatorView!
    private var answers: [AnswerItem] = [AnswerItem()]
    private var currentQuestion: Item?
    
    override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
        addRefreshControlOnTableView()
        settingDynamicHeightForCell()
        addActivityIndicator()
    }
	
	// MARK: - Public methods
	func loadAnswers(by item: Item) {
		currentQuestion = item
		guard let questionId = currentQuestion?.question_id else {
			return
		}
		NetworkRequest.request(withQuestionID: questionId) { answer in
			self.reload(by: answer)
		}
	}
    
}

// MARK: - TableView
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if answers.isEmpty {
            activityIndicatorView.startAnimating()
        }
        return answers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.id,
														   for: indexPath) as? QuestionTableViewCell else {
				return UITableViewCell()
			}
            cell.fill(currentQuestion)
			let title: String = currentQuestion?.title ?? ""
			titleNavigationItem.title = title
            return cell
        } else {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.id,
														   for: indexPath) as? AnswerTableViewCell  else {
				return UITableViewCell()
			}
			let answer: AnswerItem = answers[indexPath.row - 1]
            cell.fill(answer)
            return cell
        }
    }

}

//MARK: - Private Methods
private extension DetailViewController {
	func setupTableView() {
		tableView.register(UINib(nibName: AnswerTableViewCell.id, bundle: nil),
						   forCellReuseIdentifier: AnswerTableViewCell.id)
		tableView.register(UINib(nibName: QuestionTableViewCell.id, bundle: nil),
						   forCellReuseIdentifier: QuestionTableViewCell.id)
	}
	
	func settingDynamicHeightForCell() {
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 100
	}
	
	@objc func reloadData() {
		tableView.reloadData()
		if refreshControl != nil {
			let title = AttributedString.getTitleWithDateNow(by: "Last update:")
			refreshControl?.attributedTitle = title
			refreshControl?.endRefreshing()
		}
	}
	
	func addActivityIndicator() {
		activityIndicatorView = UIActivityIndicatorView()
		activityIndicatorView.style = .gray
		let bounds: CGRect = UIScreen.main.bounds
		activityIndicatorView.center = CGPoint(x: bounds.size.width / 2,
											   y: bounds.size.height / 2)
		activityIndicatorView.hidesWhenStopped = true
		view.addSubview(activityIndicatorView)
	}
	
	func addRefreshControlOnTableView() {
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self,
								  action: #selector(self.reloadData),
								  for: .valueChanged)
		refreshControl?.backgroundColor = UIColor.white
		if let aControl = refreshControl {
			tableView.addSubview(aControl)
		}
	}
	
	func reload(by answer: Answer?) {
		answers = [AnswerItem]()
		if let answer = answer {
			answers = answer.items ?? [AnswerItem]()
		}
		
		DispatchQueue.main.async(execute: {
			self.tableView.reloadData()
			self.activityIndicatorView.stopAnimating()
		})
	}
}
