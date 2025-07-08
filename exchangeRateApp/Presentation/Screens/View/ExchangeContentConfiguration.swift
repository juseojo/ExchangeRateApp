//
//  ExchangeContentConfiguration.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/7/25.
//

import UIKit

struct ExchangeContentConfiguration: UIContentConfiguration, Hashable {
	var countryCode: String
	var exchangeRate: String

	func makeContentView() -> any UIView & UIContentView {
		return ExchangeContentView(configuration: self)
	}
	
	func updated(for state: any UIConfigurationState) -> ExchangeContentConfiguration {
		return self
	}
}
