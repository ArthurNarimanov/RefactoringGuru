//
//  StoredData.swift
//  TestAppD1
//
//  Created by  on 24/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation

struct StoredData: Codable {
	var key: String
	var date: Date
	var data: Data
    
    private enum CodingKeys: String, CodingKey {
        case key
        case date
        case data
    }

	init(key: String, date: Date, data: Data) {
		self.key = key
		self.date = date
		self.data = data
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		key = try container.decode(String.self, forKey: .key)
		date = try container.decode(Date.self, forKey: .date)
		data = try container.decode(Data.self, forKey: .data)
	}
	
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(date, forKey: .date)
        try container.encode(data, forKey: .data)
    }
	
}
