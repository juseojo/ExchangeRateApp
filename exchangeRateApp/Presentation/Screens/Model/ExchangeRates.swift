//
//  ExchangeRates.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/7/25.
//

import Foundation

struct ExchangeRates: Codable {
	let rates: [String: Double]
	let refreshTime: TimeInterval

	enum CodingKeys: String, CodingKey {
		case rates
		case refreshTime = "time_next_update_unix"
	}
}
