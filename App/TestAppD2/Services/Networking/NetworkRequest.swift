//
//  FabricRequest.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation

struct NetworkRequest {
	private static let basePath: String = "https://api.stackexchange.com/2.2/questions"
	private static let parametrs: String = "order=desc&sort=activity&site=stackoverflow&key=G*0DJzE8SfBrKn4tMej85Q(("
	private static let cash: Cacheable = CacheWithTimeInterval()
	
	static func request(tagged stringTagged: String?,
						numberOfPageToLoad: Int,
						withBlock completionHandler: @escaping (_ data: [Item]?) -> Void) {
		
		let stringURL = NetworkRequest.basePath + "?" +
			NetworkRequest.parametrs + "&pagesize=50&tagged=" +
			stringTagged! + String(format: "&page=%ld",
								   numberOfPageToLoad)
		
		guard let url = URL(string: stringURL) else {
			completionHandler(nil)
			return
		}
		
		if cash.objectForKey(stringURL) == nil {
			NetworkRequest.getRequest(by: url) { data in
				if let jsonData = data,
				   let items = try? JSONDecoder().decode(Question.self, from: jsonData).items {
					completionHandler(items)
					cash.set(data: data, for: stringURL)
				} else {
					completionHandler(nil)
				}
			}
		} else {
			if let jsonData = cash.objectForKey(stringURL),
			   let items = try? JSONDecoder().decode(Question.self, from: jsonData).items {
				completionHandler(items)
			} else {
				completionHandler(nil)
			}
		}
		
	}
	
	static func request(withQuestionID questionID: Int,
						withBlock completionHandler: @escaping (_ data: Answer?) -> Void) {
		let stringURLQuestionID = String(format: "%@/%li/answers?%@&filter=!9YdnSMKKT",
										 NetworkRequest.basePath,
										 questionID,
										 NetworkRequest.parametrs)
		guard let url = URL(string: stringURLQuestionID) else {
			completionHandler(nil)
			return
		}
		NetworkRequest.getRequest(by: url) { data in
			if let jsonData = data,
			   let answerModel = try? JSONDecoder().decode(Answer.self, from: jsonData) {
				completionHandler(answerModel)
			} else {
				completionHandler(nil)
			}
		}
	}
	
	private static func getRequest(by url: URL,
								   completionHandler: @escaping (_ data: Data?) -> Void) {
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
			DispatchQueue.main.async {
				completionHandler(data)
			}
		}
		task.resume()
	}
}
