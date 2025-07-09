//
//  ExchangeViewModel.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/7/25.
//

import Foundation

import Combine

class ExchangeViewModel: ViewModelProtocol {
	struct State {
		var exchangeItems: [ExchangeRateItem]
		var errorMessage: String
	}

	enum Action {
		case requestExchangeRate
		case filtering(str: String)
	}

	lazy var action: ((Action) -> Void)? = { [weak self] (action: Action) in
		guard let self = self else { return }
		switch action {
		case .requestExchangeRate:
			self.requestExchangeRate()
		case .filtering(let str):
			self.filterExchangeRate(str: str)
		}
	}

	@Published private(set) var state = State(exchangeItems: [], errorMessage: "")
    let dataService = DataService()
	private var originItems = [ExchangeRateItem]()

	private func requestExchangeRate() {
		Task {
			do {
				originItems = try await dataService.exchangeFetchData().rates.map {
					ExchangeRateItem(countryCode: $0.key,
									 rate: String(format: "%.4f", $0.value),
									 countryName: CountryCode[$0.key] ?? "None")
				}
				state.exchangeItems = originItems
			} catch DataServiceError.decodingError {
				state.errorMessage = "decodingError"
			} catch {
				state.errorMessage = "네트워크 에러"
			}
		}
	}

	private func filterExchangeRate(str: String) {
		if str == "" {
			state.exchangeItems = originItems
		} else {
			state.exchangeItems = originItems.filter { $0.countryCode.contains(str) || $0.countryName.contains(str) }
		}
	}
}
