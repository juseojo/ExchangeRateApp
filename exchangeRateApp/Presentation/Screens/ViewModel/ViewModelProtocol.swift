//
//  ViewModelProtocol.swift
//  exchangeRateApp
//
//  Created by seongjun cho on 7/9/25.
//

protocol ViewModelProtocol {
	associatedtype Action
	associatedtype State

	var action: ((Action) -> Void)? { get }
	var state: State { get }
}
