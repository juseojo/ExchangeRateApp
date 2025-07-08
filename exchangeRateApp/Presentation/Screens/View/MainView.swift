//
//  MainView.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/4/25.
//

import UIKit

import SnapKit
import Then

class MainView: UIView {
	lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout()).then {
		$0.backgroundColor = .systemBackground
		$0.showsVerticalScrollIndicator = false
	}

	let searchBar = UISearchBar().then {
		$0.placeholder = "통화 검색"
		$0.searchBarStyle = .minimal
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .systemBackground

		addSubview(searchBar)
		searchBar.snp.makeConstraints { make in
			make.top.equalTo(self.safeAreaLayoutGuide)
			make.leading.trailing.equalToSuperview()
		}

		addSubview(collectionView)
		collectionView.snp.makeConstraints { make in
			make.top.equalTo(searchBar.snp.bottom)
			make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func makeCollectionViewLayout() -> UICollectionViewLayout {
		let config = UICollectionLayoutListConfiguration(appearance: .plain)
		let layout = UICollectionViewCompositionalLayout.list(using: config)

		return layout
	}
}
