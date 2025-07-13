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
		case toggleFavorite(code: String)
	}

	lazy var action: ((Action) -> Void)? = { [weak self] (action: Action) in
		guard let self = self else { return }
		switch action {
		case .requestExchangeRate:
			self.requestExchangeRate()
		case .filtering(let str):
			self.filterExchangeRate(str: str)
		case .toggleFavorite(let code):
			self.toggleFavorite(code: code)
		}
	}

	@Published private(set) var state = State(exchangeItems: [], errorMessage: "")
	let dataService = DataService()
	private var originItems = [ExchangeRateItem]()

	private func requestExchangeRate() {
		Task {
			do {
				// 날짜 체크
				let now = Date().timeIntervalSince1970
				let refreshDate = UserDefaults.standard.object(forKey: "refreshDate") as? TimeInterval ?? Date().timeIntervalSince1970
				var beforeData = dataService.beforeRatesRead()
				var todayData = dataService.todayRatesRead()

				if now - refreshDate >= -0.01 {
					// 데이터 갱신
					let data = try await dataService.exchangeFetchData()
					var todayRates = [String : Double]()
					for item in todayData {
						todayRates[item.code ?? "None"] = item.rate
					}
					UserDefaults.standard.set(data.refreshTime, forKey: "refreshDate")

					// 전날 데이터 = 오늘데이터
					dataService.deleteAllBeforeRates()
					if todayRates.isEmpty {
						dataService.saveBeforeRates(rates: data.rates)
					} else {
						dataService.saveBeforeRates(rates: todayRates)
					}
					beforeData = dataService.beforeRatesRead()

					// 오늘데이터 = 갱신 데이터
					dataService.deleteAllTodayRates()
					dataService.saveTodayRates(rates: data.rates)
					todayData = dataService.todayRatesRead()
				}

				// 오늘 데이터 등록
				originItems = todayData.map {
					ExchangeRateItem(countryCode: $0.code ?? "None",
									 rate: String(format: "%.4f", $0.rate),
									 countryName: CountryCode[$0.code ?? "None"] ?? "None")
				}

				// 등록된 데이터에서 beforeRate 설정
				originItems = originItems.map { data in
					var newData = data

					newData.beforeRate = beforeData.first(where: { $0.code == data.countryCode })?.rate ?? 0.0

					return newData
				}

				// isFavorit true 설정
				let favorites = dataService.favoritesRead() ?? [Favorites]()

				originItems = originItems.map { favorite in
					if favorites.contains(where: { $0.favoriteCode == favorite.countryCode }) {
						var newFavorite = favorite
						newFavorite.isFavorite = true
						return newFavorite
					}

					return favorite
				}

				// 정렬
				state.exchangeItems = originItems.sorted {
					if $0.isFavorite != $1.isFavorite {
						return $0.isFavorite
					}
					return $0.countryCode < $1.countryCode
				}
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

	private func toggleFavorite(code: String) {
		dataService.toggleFavorites(str: code)
		let favorites = dataService.favoritesRead() ?? [Favorites]()
		print(favorites)
		originItems = originItems.map { favorite in
			if favorites.contains(where: { $0.favoriteCode == favorite.countryCode }) {
				var newFavorite = favorite
				newFavorite.isFavorite = true
				return newFavorite
			} else {
				var newFavorite = favorite
				newFavorite.isFavorite = false
				return newFavorite
			}
		}
		state.exchangeItems = originItems.sorted {
			if $0.isFavorite != $1.isFavorite {
				return $0.isFavorite
			}
			return $0.countryCode < $1.countryCode
		}
	}
}
