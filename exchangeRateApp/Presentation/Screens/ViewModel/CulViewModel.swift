//
//  CulViewModel.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/9/25.
//

import Foundation

class CulViewModel: ViewModelProtocol {
	struct State {
		var resultText: String
	}

	enum Action {
		case culExchange(amount: Double, rate: String, countryCode: String)
	}

	@Published private(set) var state = State(resultText: "계산 결과가 여기에 표시됩니다")

	lazy var action: ((Action) -> Void)? = { [weak self] (action: Action) in
		guard let self = self else { return }
		switch action {
		case .culExchange(amount: let amount, rate: let rate, countryCode: let countryCode):
			culExchange(amount: amount, rate: rate, countryCode: countryCode)
		}
	}

	private func culExchange(amount: Double, rate: String, countryCode: String) {
		state.resultText = "$\(amount) -> \(String(format: "%.2f", amount * Double(rate)!)) \(countryCode)"
	}
}
