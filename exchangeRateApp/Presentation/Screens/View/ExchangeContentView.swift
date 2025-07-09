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

	let countryCodeLabel = UILabel().then {
		$0.font = .systemFont(ofSize: 16, weight: .medium)
	}

	let rateLabel = UILabel().then {
		$0.font = .systemFont(ofSize: 16)
		$0.textAlignment = .right
	}

	let countryLabel = UILabel().then {
		$0.font = .systemFont(ofSize: 14)
		$0.textColor = .gray
	}

	let contentView = UIView()

	let labelStackView = UIStackView().then {
		$0.axis = .vertical
		$0.spacing = 4
	}

	init(configuration: ExchangeContentConfiguration) {
		self.configuration = configuration
		super.init(frame: .zero)
		setLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func apply(configuration: ExchangeContentConfiguration) {
		countryCodeLabel.text = configuration.countryCode
		rateLabel.text = configuration.exchangeRate
		countryLabel.text = configuration.countryName
	}

	private func setLayout() {

		addSubview(contentView)

		[labelStackView, rateLabel].forEach {
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
			make.trailing.equalToSuperview().inset(16)
			make.centerY.equalToSuperview()
			make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).inset(16)
			make.width.equalTo(120)
		}
	}
}
