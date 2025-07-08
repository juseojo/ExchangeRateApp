//
//  ExchangeViewModel.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/7/25.
//

import Foundation

import Combine

class ExchangeViewModel {
    let dataService = DataService()
	@Published var exchangeItems = [ExchangeRateItem]()
	@Published var errorMessage: String?

	func requestExchangeRate() {
		Task {
			do {
				exchangeItems = try await dataService.exchangeFetchData().rates.map {
					ExchangeRateItem(countryCode: $0.key,
									 rate: String(format: "%.4f", $0.value),
									 countryName: CountryCode[$0.key] ?? "None")
				}
			} catch DataServiceError.decodingError {
				errorMessage = "decodingError"
			} catch {
				errorMessage = "네트워크 에러"
			}
		}
	}
}
