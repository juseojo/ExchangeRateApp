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

	let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ExchangeRateItem> { (cell, indexPath, item) in
		var configuration = ExchangeContentConfiguration(countryCode: item.countryCode, exchangeRate: item.rate, countryName: item.countryName)
		cell.contentConfiguration = configuration
	}

	override func loadView() {
		view = mainView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBar.isHidden = true
		initDataSource()
		bindingData()
		exchangeViewModel.requestExchangeRate()
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
		exchangeViewModel.$exchangeItems
			.receive(on: DispatchQueue.main)
			.sink { [weak self] items in
				self?.updateData(items)
			}
			.store(in: &cancellables)
		exchangeViewModel.$errorMessage
			.receive(on: DispatchQueue.main)
			.sink { [weak self] errorMessage in
				if errorMessage != nil {
					let alert = UIAlertController(
						title: "오류",
						message: "에러메세지 : \(errorMessage!)",
						preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "확인", style: .default))
					self?.present(alert, animated: true)
				}
			}
			.store(in: &cancellables)
	}
}

@available(iOS 18.0, *)
#Preview {
	MainViewController()
}
