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

	internal var configuration: UIContentConfiguration

	let countryCodeLabel = UILabel().then {
		$0.font = .systemFont(ofSize: 22, weight: .semibold)
	}

	let rateLabel = UILabel().then {
		$0.font = .systemFont(ofSize: 22, weight: .regular)
	}

	init(configuration: ExchangeContentConfiguration) {
		self.configuration = configuration
		super.init(frame: .zero)
		setLayout()
		apply(configuration: configuration)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func apply(configuration: ExchangeContentConfiguration) {
		countryCodeLabel.text = configuration.countryCode
		rateLabel.text = configuration.exchangeRate
	}

	private func setLayout() {
		addSubview(countryCodeLabel)
		addSubview(rateLabel)

		countryCodeLabel.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview()
			make.leading.equalToSuperview().offset(8)
			make.height.equalTo(countryCodeLabel.font.lineHeight + 10)
		}

		rateLabel.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview()
			make.trailing.equalToSuperview().inset(8)
			make.height.equalTo(rateLabel.font.lineHeight + 10)
		}
	}
}
