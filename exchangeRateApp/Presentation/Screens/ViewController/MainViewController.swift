//
//  ViewController.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/4/25.
//

import UIKit

import Combine

class MainViewController: UIViewController {
	typealias DataSource = UICollectionViewDiffableDataSource<Int, ExchangeRateItem>

	let mainView = MainView()
	let exchangeViewModel = ExchangeViewModel()
	var dataSource: DataSource?
	private var cancellables = Set<AnyCancellable>()

	var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, ExchangeRateItem>!

	override func loadView() {
		view = mainView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ExchangeRateItem> { [weak self] (cell, indexPath, item) in
			let configuration = ExchangeContentConfiguration(
				countryCode: item.countryCode,
				exchangeRate: item.rate,
				countryName: item.countryName,
				isFavorite: item.isFavorite,
				beforeExchangeRate: item.beforeRate,
				favoriteAction: self?.favoriteToggle
			)

			cell.contentConfiguration = configuration
		}
		mainView.searchBar.delegate = self
		mainView.collectionView.delegate = self
		self.title = "환율 정보"

		initDataSource()
		bindingData()
		exchangeViewModel.action!(.requestExchangeRate)
	}
}

extension MainViewController {
	private func updateData(_ data: [ExchangeRateItem]) {
		var snapshot = NSDiffableDataSourceSnapshot<Int, ExchangeRateItem>()
		snapshot.appendSections([0])
		snapshot.appendItems(data, toSection: 0)
		dataSource?.apply(snapshot)
	}

	private func initDataSource() {
		dataSource = DataSource(collectionView: mainView.collectionView) {
			(collectionView: UICollectionView, indexPath: IndexPath, item: ExchangeRateItem) in

			return collectionView.dequeueConfiguredReusableCell(
				using: self.cellRegistration,
				for: indexPath,
				item: item
			)
		}
	}

	private func bindingData() {
		exchangeViewModel.$state
			.receive(on: DispatchQueue.main)
			.sink { [weak self] items in
				if items.errorMessage != "" {
					let alert = UIAlertController(
						title: "오류",
						message: "에러메세지 : \(items.errorMessage)",
						preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "확인", style: .default))
					self?.present(alert, animated: true)
				}
				if items.exchangeItems.isEmpty {
					self?.mainView.showNoSearch()
				} else {
					self?.mainView.hideNoSearch()
				}
				self?.updateData(items.exchangeItems)
			}
			.store(in: &cancellables)
	}

	@objc func favoriteToggle(code: String) {
		exchangeViewModel.action!(.toggleFavorite(code: code))
	}
}

extension MainViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		guard let exchangeItem = dataSource?.itemIdentifier(for: indexPath) else {
			return
		}
		let vc = CulViewController(exchangeItem: exchangeItem)
		self.navigationController?.pushViewController(vc, animated: true)
	}
}

extension MainViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		exchangeViewModel.action!(.filtering(str: searchText.uppercased()))
	}
}

@available(iOS 18.0, *)
#Preview {
	MainViewController()
}
