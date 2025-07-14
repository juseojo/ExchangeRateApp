//
//  DataService.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/7/25.
//

import Foundation
import UIKit
import CoreData

enum DataServiceError: Error {
	case invalidURL
	case networkError(Error)
	case invalidResponse
	case decodingError
}

final class DataService {
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

	private enum RequestType {
		case exchange

		var url: String {
			switch self {
			case .exchange:
				return exchangeURL
			}
		}
	}

	private func fetchData<T: Decodable>(requestType: RequestType) async throws -> T {
		guard let url = URL(string: requestType.url) else {
			throw DataServiceError.invalidURL
		}
		do {
			let (data, response) = try await URLSession.shared.data(from: url)

			guard let httpResponse = response as? HTTPURLResponse,
				  (200...299).contains(httpResponse.statusCode) else {
				throw DataServiceError.invalidResponse
			}

			guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
				throw DataServiceError.decodingError
			}

			return decodedData
		} catch {
			throw DataServiceError.networkError(error)
		}
	}

	func exchangeFetchData() async throws -> ExchangeRates {
		do {
			return try await fetchData(requestType: .exchange)
		} catch {
			print("fetchDataError: \(error)")
			throw error
		}
	}

	func toggleFavorites(str: String) {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let saved: [Favorites]? = favoritesRead()
		let favorites = Favorites(context: context)

		if saved == nil {
			favorites.favoriteCode = str
		}
		else if let target = saved?.first(where: { $0.favoriteCode == str }) {
			context.delete(target)
		} else {
			favorites.favoriteCode = str
		}

		do {
			try context.save()
		} catch {
			print("Save failed: \(error)")
		}
	}

	func favoritesRead() -> [Favorites]? {
		let fetchRequest: NSFetchRequest<Favorites> = Favorites.fetchRequest()

		do {
			let favorites = try context.fetch(fetchRequest)
			return favorites
		} catch {
			print("Fetch failed: \(error)")
			return nil
		}
	}

	func beforeRatesRead() -> [BeforeData] {
		let fetchRequest: NSFetchRequest<BeforeData> = BeforeData.fetchRequest()

		do {
			let recentlyData = try context.fetch(fetchRequest)
			return recentlyData
		} catch {
			print("Fetch failed: \(error)")
			return []
		}
	}

	func todayRatesRead() -> [TodayData] {
		let fetchRequest: NSFetchRequest<TodayData> = TodayData.fetchRequest()

		do {
			let recentlyData = try context.fetch(fetchRequest)
			return recentlyData
		} catch {
			print("Fetch failed: \(error)")
			return []
		}
	}

	func saveBeforeRates(rates: [String: Double]) {
		for (code, rate) in rates {
			let beforeData = BeforeData(context: context)

			beforeData.code = code
			beforeData.rate = rate
		}

		do {
			try context.save()
		} catch {
			print("save failed: \(error)")
		}
	}

	func saveTodayRates(rates: [String: Double]) {
		for (code, rate) in rates {
			let todayData = TodayData(context: context)

			todayData.code = code
			todayData.rate = rate
		}

		do {
			try context.save()
		} catch {
			print("save failed: \(error)")
		}
	}

	func deleteAllBeforeRates() {
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: BeforeData.fetchRequest())

		do {
			try context.execute(deleteRequest)
			try context.save()
		} catch {
			print("delete failed: \(error)")
		}
	}

	func deleteAllTodayRates() {
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: TodayData.fetchRequest())

		do {
			try context.execute(deleteRequest)
			try context.save()
		} catch {
			print("delete failed: \(error)")
		}
	}

	func deleteAllLastVCs() {
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: LastVCs.fetchRequest())

		do {
			try context.execute(deleteRequest)
			try context.save()
		} catch {
			print("delete failed: \(error)")
		}
	}

	func saveLastVCs(vcs: [UIViewController]) {
        deleteAllLastVCs()
		let lastVCs = LastVCs(context: context)
		var vcStrings: [String] = []

		for vc in vcs {
			if vc is MainViewController {
				vcStrings.append("Main")
			} else if let culVC = vc as? CulViewController {
				do {
					// 문자열로 정보들 인코딩
					let itemData = try JSONEncoder().encode(culVC.exchangeItem)
					let itemString = String(data: itemData, encoding: .utf8) ?? ""
					vcStrings.append("Cul:" + itemString)
				} catch {
					print("Failed to encode ExchangeRateItem: \(error)")
				}
			}
		}
		lastVCs.vcs = vcStrings

		do {
			try context.save()
		} catch {
			print("save failed: \(error)")
		}
	}

	func readLastVCs() -> [UIViewController] {
		let fetchRequest: NSFetchRequest<LastVCs> = LastVCs.fetchRequest()

		do {
			let lastVCsData = try context.fetch(fetchRequest)
			guard let vcStrings = lastVCsData.first?.vcs else { return [MainViewController()] }
			var vcs: [UIViewController] = []

			for vcString in vcStrings {
				if vcString == "Main" {
					vcs.append(MainViewController())
				} else if vcString.starts(with: "Cul:") {
					let itemString = String(vcString.dropFirst(4))

					if let itemData = itemString.data(using: .utf8) {
						do {
							let item = try JSONDecoder().decode(ExchangeRateItem.self, from: itemData)
							vcs.append(CulViewController(exchangeItem: item))
						} catch {
							print("Failed to decode ExchangeRateItem: \(error)")
						}
					}
				}
			}

			return vcs.isEmpty ? [MainViewController()] : vcs
		} catch {
			return [MainViewController()]
		}
	}
}
