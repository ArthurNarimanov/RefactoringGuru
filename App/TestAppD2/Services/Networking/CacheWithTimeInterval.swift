//
//  CacheWithTimeInterval.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation

protocol Cacheable {
	func objectForKey(_ key: String) -> Data?
	func set(data: Data?, for key: String)
}

struct CacheWithTimeInterval: Cacheable {
	
	func objectForKey(_ key: String) -> Data? {
		let arrayOfCachedData: [Data] = getCash(by: key)
		var mutableArrayOfCachedData = arrayOfCachedData
		var deletedCount = 0
		
		for (index, data) in arrayOfCachedData.enumerated() {
			guard let storedData = try? PropertyListDecoder()
					.decode(StoredData.self, from: data) else { break }
			
			if abs(storedData.date.timeIntervalSinceNow) < 300 {
				if storedData.key == key {
					return storedData.data
				} else {
					break
				}
			} else {
				mutableArrayOfCachedData.remove(at: index - deletedCount)
				deletedCount += 1
				UserDefaults.standard.set(mutableArrayOfCachedData, forKey: key)
			}
		}
		
		return nil
	}
	
	func set(data: Data?, for key: String) {
		var arrayOfCachedData: [Data] = getCash(by: key)
		
		if let data = data {
			if objectForKey(key) == nil {
				let storedData = StoredData(key: key, date: Date(), data: data)
				if let encodeData = try? PropertyListEncoder().encode(storedData) {
					arrayOfCachedData.append(encodeData)
				}
			}
		}
		
		UserDefaults.standard.set(arrayOfCachedData, forKey: key)
	}
	
}

private extension CacheWithTimeInterval {
	func getCash(by key: String) -> [Data] {
		if let cash = UserDefaults.standard.array(forKey: key),
		   let cashData = cash as? [Data] {
			return cashData
		} else {
			return []
		}
	}
}
