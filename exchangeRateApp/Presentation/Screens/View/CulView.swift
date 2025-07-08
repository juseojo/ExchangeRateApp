//
//  CulView.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/8/25.
//

import UIKit

import Then
import SnapKit

class CulView: UIView {

	let labelStackView = UIStackView().then {
		$0.axis = .vertical
		$0.spacing = 4
		$0.alignment = .center
	}

	let countryCodeLabel = UILabel().then {
		$0.font = .systemFont(ofSize: 24, weight: .bold)
	}

	let countryLabel = UILabel().then {
		$0.font = .systemFont(ofSize: 16)
		$0.textColor = .gray
	}

	let amountTextField = UITextField().then {
		$0.borderStyle = .roundedRect
		$0.keyboardType = .decimalPad
		$0.textAlignment = .center
		$0.placeholder = "금액을 입력하세요."
	}

	let convertButton = UIButton().then {
		$0.backgroundColor = .systemBlue
		$0.setTitle("환율 계산", for: .normal)
		$0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
		$0.titleLabel?.textColor = .white
		$0.layer.cornerRadius = 8
		$0.layer.masksToBounds = true
	}

	let resultLabel = UILabel().then {
		$0.font = .systemFont(ofSize: 20, weight: .medium)
		$0.textAlignment = .center
		$0.numberOfLines = 0
		$0.text = "계산 결과가 여기에 표시됩니다"
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setLayout() {
		[labelStackView, amountTextField, convertButton, resultLabel].forEach {
			addSubview($0)
		}

		[countryCodeLabel, countryLabel].forEach {
			labelStackView.addArrangedSubview($0)
		}

		labelStackView.snp.makeConstraints { make in
			make.top.equalTo(self.safeAreaLayoutGuide).offset(32)
			make.centerX.equalToSuperview()
		}

		amountTextField.snp.makeConstraints { make in
			make.top.equalTo(labelStackView.snp.bottom).offset(32)
			make.leading.trailing.equalToSuperview().inset(24)
			make.height.equalTo(44)
		}

		convertButton.snp.makeConstraints { make in
			make.top.equalTo(amountTextField.snp.bottom).offset(24)
			make.leading.trailing.equalToSuperview().inset(24)
			make.height.equalTo(44)
		}

		resultLabel.snp.makeConstraints { make in
			make.top.equalTo(convertButton.snp.bottom).offset(32)
			make.leading.trailing.equalToSuperview().inset(24)
		}
	}

	func configure(item: ExchangeRateItem) {
		countryCodeLabel.text = item.countryCode
		countryLabel.text = item.countryName
	}
}
