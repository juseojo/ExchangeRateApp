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

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(collectionView)
		collectionView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
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
