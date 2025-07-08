//
//  CulViewController.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/8/25.
//

import UIKit

import Then
import SnapKit

class CulViewController: UIViewController {
	let culView = CulView()
	var exchangeItem: ExchangeRateItem

	init(exchangeItem: ExchangeRateItem) {
		self.exchangeItem = exchangeItem
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		view = culView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "환율 계산기"
		view.backgroundColor = .systemBackground
		culView.configure(item: exchangeItem)
		culView.delegate = self
	}
}

extension CulViewController: CulViewDelegate {
	func tapConvertButtonError(errorType: ConvertError) {
		if errorType == .invalid {
			let alert = UIAlertController(title: "오류", message: "올바른 숫자를 입력해주세요.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "확인", style: .default))
			present(alert, animated: true)
		} else if errorType == .empty {
			let alert = UIAlertController(title: "오류", message: "금액을 입력해주세요.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "확인", style: .default))
			present(alert, animated: true)
		}
	}
}
