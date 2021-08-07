//
//  ViewController.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
	
	private var activityIndicatorView: UIActivityIndicatorView!
	private var questions: [Item] = []
	private var refreshControl: UIRefreshControl?
	private var loadMoreStatus = false
	private var numberOfPageToLoad: Int = 1
	private var requestedTag = ArrayOfTags.shared[0]
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var leadingTableViewLayoutConstraint: NSLayoutConstraint!
	@IBOutlet weak var trailingTableViewLayoutConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		addObservers()
		getItems(removeAllObjects: true)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setupPositionActivityIndicatorView()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let indexPath: IndexPath? = tableView.indexPathForSelectedRow
		let detailViewController = (segue.destination as? UINavigationController)?.topViewController as? DetailViewController
		let item = questions[indexPath?.row ?? 0]
		detailViewController?.currentQuestion = item
		detailViewController?.loadAnswers()
		detailViewController?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
		detailViewController?.navigationItem.leftItemsSupplementBackButton = true
	}
	
	// MARK: - IBAction
	@IBAction private func slideMenu(_ sender: Any) {
		if leadingTableViewLayoutConstraint.constant == 0 {
			leadingTableViewLayoutConstraint.constant = UIScreen.main.bounds.size.width / 2
			trailingTableViewLayoutConstraint.constant = UIScreen.main.bounds.size.width * -0.5
			UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
				self.view.layoutIfNeeded()
			})
			tableView.allowsSelection = false
		} else {
			leadingTableViewLayoutConstraint.constant = 0
			trailingTableViewLayoutConstraint.constant = 0
			UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
				self.view.layoutIfNeeded()
			})
			tableView.allowsSelection = true
		}
	}
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController:  UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if questions.isEmpty {
			activityIndicatorView.startAnimating()
		}
		return questions.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.id,
													   for: indexPath) as? QuestionTableViewCell else {
			return UITableViewCell()
		}
		
		if !questions.isEmpty {
			cell.fill(questions[indexPath.row])
		}
		cell.selectionStyle = .none
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "DetailSegue", sender: self)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let actualPosition: CGFloat = scrollView.contentOffset.y
		let contentHeight: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
		if actualPosition >= contentHeight && actualPosition > 0 && loadMoreStatus == false {
			activityIndicatorView.startAnimating()
			loadMoreStatus = true
			getItems(removeAllObjects: false) {
				self.loadMoreStatus = false
			}
		}
	}
}

//MARK: - Private Methods
private extension MainViewController {
	func setupTableView() {
		tableView.register(UINib(nibName: QuestionTableViewCell.id, bundle: nil),
						   forCellReuseIdentifier: QuestionTableViewCell.id)
		addRefreshControlOnTableView()
		settingDynamicHeightForCell()
		addActivityIndicator()
	}
	
	func addRefreshControlOnTableView() {
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(self.reloadData), for: .valueChanged)
		if let refreshControl = refreshControl {
			tableView.addSubview(refreshControl)
		}
	}
	
	func settingDynamicHeightForCell() {
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 100
	}
	
	func addActivityIndicator() {
		activityIndicatorView = UIActivityIndicatorView()
		activityIndicatorView.style = .gray
		setupPositionActivityIndicatorView()
		activityIndicatorView.hidesWhenStopped = true
		view.addSubview(activityIndicatorView)
	}
	
	func setupPositionActivityIndicatorView() {
		let bounds: CGRect = UIScreen.main.bounds
		let heightNavigationBar: CGFloat = self.navigationController?.navigationBar.bounds.height ?? .zero
		activityIndicatorView.center = CGPoint(x: bounds.size.width / 2,
											   y: bounds.size.height / 2 - heightNavigationBar)
	}
	
	func getItems(removeAllObjects: Bool, completion: VoidClosure? = nil) {
		NetworkRequest.request(tagged: requestedTag,
							   numberOfPageToLoad: numberOfPageToLoad) {[weak self] items in
			guard let _self = self else { return }
			_self.reload(by: items, removeAllObjects: removeAllObjects)
			_self.numberOfPageToLoad += 1
			completion?()
		}
	}
	
	@objc func reloadData() {
		numberOfPageToLoad = 1
		getItems(removeAllObjects: true)
		if refreshControl != nil {
			refreshControl?.attributedTitle = getLastUpdateTitle()
			refreshControl?.endRefreshing()
		}
	}
	
	func getLastUpdateTitle() -> NSAttributedString? {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM d, h:mm a"
		let title = "Last update: \(formatter.string(from: Date()))"
		let attributesDictionary = [NSAttributedString.Key.foregroundColor : UIColor.white]
		return NSAttributedString(string: title, attributes: attributesDictionary)
	}
	
	func reload(by items: [Item]?, removeAllObjects: Bool) {
		if removeAllObjects {
			questions = [Item]()
			tableView.isHidden = true
		}
		if let items = items {
			questions.append(contentsOf: items)
		}
		DispatchQueue.main.async(execute: {
			self.tableView.isHidden = false
			self.tableView.reloadData()
			self.activityIndicatorView.stopAnimating()
		})
	}
	
	// MARK: - Notification
	func addObservers() {
		NotificationCenter.default
			.addObserver(self,
						 selector: #selector(self.requestedTagNotification(_:)),
						 name: NSNotification.Name("RequestedTagNotification"), object: nil)
	}
	
	@objc func requestedTagNotification(_ notification: Notification?) {
		activityIndicatorView.startAnimating()
		requestedTag = notification?.object as! String
		numberOfPageToLoad = 1
		getItems(removeAllObjects: true)
	}
}
