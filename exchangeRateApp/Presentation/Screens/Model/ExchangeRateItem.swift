//
//  ExchangeRateItem.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/7/25.
//

import Foundation

struct ExchangeRateItem: Hashable {
	var countryCode: String
	var rate: String
	var countryName: String
	var isFavorite: Bool = false
	var beforeRate: Double = 0.0
}
