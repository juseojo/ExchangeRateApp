//
//  DataService.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/7/25.
//

import Foundation

enum DataServiceError: Error {
	case invalidURL
	case networkError(Error)
	case invalidResponse
	case decodingError
}

final class DataService {
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
}
