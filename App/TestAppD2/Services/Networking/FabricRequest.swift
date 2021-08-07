//
//  FabricRequest.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation

struct NetworkRequest {
	static let basePath: String = "https://api.stackexchange.com/2.2/questions"
	static let parametrs: String = "order=desc&sort=activity&site=stackoverflow&key=G*0DJzE8SfBrKn4tMej85Q(("
	static let cash: Cacheable = CacheWithTimeInterval()
	
	static func request(tagged stringTagged: String?,
						numberOfPageToLoad: Int,
						withBlock completionHandler: @escaping (_ data: Data?) -> Void) {
		
		let stringURL = NetworkRequest.basePath + "?" + NetworkRequest.parametrs + "&pagesize=50&tagged=" +
			stringTagged! + String(format: "&page=%ld", numberOfPageToLoad)
		
		guard let url = URL(string: stringURL) else {
			completionHandler(nil)
			return
		}
		
		if cash.objectForKey(stringURL) == nil {
			NetworkRequest.getRequest(by: url) { data in
				completionHandler(data)
				cash.set(data: data, for: stringURL)
			}
		} else {
			completionHandler(cash.objectForKey(stringURL))
		}
		
	}
	
	static func request(withQuestionID questionID: Int,
						withBlock completionHandler: @escaping (_ data: Data?) -> Void) {
		let stringURLQuestionID = String(format: "%@/%li/answers?%@&filter=!9YdnSMKKT", NetworkRequest.basePath, questionID, NetworkRequest.parametrs)
		guard let url = URL(string: stringURLQuestionID) else {
			completionHandler(nil)
			return
		}
		NetworkRequest.getRequest(by: url) { data in
			completionHandler(data)
		}
	}
	
	private static func getRequest(by url: URL, completionHandler: @escaping (_ data: Data?) -> Void) {
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
			completionHandler(data)
		}
		task.resume()
	}
}
