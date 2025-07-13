//
//  ExchangeContentView.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/7/25.
//

import UIKit

import Then
import SnapKit

class ExchangeContentView: UIView, UIContentView {

	internal var configuration: UIContentConfiguration {
		didSet {
			guard let newConfig = configuration as? ExchangeContentConfiguration else { return }
			apply(configuration: newConfig)
		}
	}
    var favoriteAction: ((String) -> Void)?

	let countryCodeLabel = UILabel().then {
		$0.font = .systemFont(ofSize: 16, weight: .medium)
		$0.textColor = .text
	}

	let rateLabel = UILabel().then {
		$0.font = .systemFont(ofSize: 16)
		$0.textAlignment = .right
		$0.textColor = .text
	}

	let countryLabel = UILabel().then {
		$0.font = .systemFont(ofSize: 14)
		$0.textColor = .secondaryText
	}

	let contentView = UIView()

	let labelStackView = UIStackView().then {
		$0.axis = .vertical
		$0.spacing = 4
	}

	lazy var favoriteButton = UIButton().then {
		let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
		$0.setImage(UIImage(systemName: "star", withConfiguration: config), for: .normal)
		$0.setImage(UIImage(systemName: "star.fill", withConfiguration: config), for: .selected)
		$0.tintColor = .favorite
		$0.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
	}

	init(configuration: ExchangeContentConfiguration) {
		self.configuration = configuration
		super.init(frame: .zero)
		setLayout()
		apply(configuration: configuration)
		self.backgroundColor = .cellBackground
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func apply(configuration: ExchangeContentConfiguration) {
		countryCodeLabel.text = configuration.countryCode
		if (Double(configuration.exchangeRate) ?? 0.0) - configuration.beforeExchangeRate > 0.01 {
			rateLabel.text = configuration.exchangeRate + " ⬆️"
		} else if (Double(configuration.exchangeRate) ?? 0.0)  - configuration.beforeExchangeRate <= -0.01 {
			rateLabel.text = configuration.exchangeRate + " ⬇️"
		} else {
			rateLabel.text = configuration.exchangeRate
		}
		countryLabel.text = configuration.countryName
		favoriteButton.isSelected = configuration.isFavorite
		favoriteAction = configuration.favoriteAction
	}

	@objc private func favoriteButtonTapped() {
		favoriteAction?(countryCodeLabel.text ?? "")
	}

	private func setLayout() {

		addSubview(contentView)

		[labelStackView, rateLabel, favoriteButton].forEach {
			contentView.addSubview($0)
		}

		[countryCodeLabel, countryLabel].forEach {
			labelStackView.addArrangedSubview($0)
		}

		contentView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
			make.height.equalTo(60)
		}

		labelStackView.snp.makeConstraints { make in
			make.leading.equalToSuperview().inset(16)
			make.centerY.equalToSuperview()
		}

		rateLabel.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).inset(16)
			make.width.equalTo(120)
		}

		favoriteButton.snp.makeConstraints { make in
			make.leading.equalTo(rateLabel.snp.trailing).offset(8)
			make.centerY.equalToSuperview()
			make.trailing.equalToSuperview().inset(16)
		}
	}
}
