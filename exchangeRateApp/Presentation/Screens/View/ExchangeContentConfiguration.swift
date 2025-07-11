//
//  ExchangeContentConfiguration.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/7/25.
//

import UIKit

struct ExchangeContentConfiguration: UIContentConfiguration {
	var countryCode: String
	var exchangeRate: String
	var countryName: String
	var isFavorite: Bool
	var favoriteAction: ((String) -> Void)?

	func makeContentView() -> any UIView & UIContentView {
		return ExchangeContentView(configuration: self)
	}
	
	func updated(for state: any UIConfigurationState) -> ExchangeContentConfiguration {
		return self
	}
}
