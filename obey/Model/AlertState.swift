//
//  AlertState.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import Foundation

struct AlertState: Equatable {
	let title: String
	let subtitle: String
	let cta: String
	
	static let winner = AlertState(title: "You win", subtitle: "Great job!", cta: "Woooooo!")
	static let unlucky = AlertState(title: "You did great", subtitle: "Keep it up, maybe you'll win next time.", cta: "OK")
	static let empty = AlertState(title: "", subtitle: "", cta: "")
}
