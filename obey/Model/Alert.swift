//
//  Alert.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import Foundation

struct Alert: Equatable {
	let title: String
	let subtitle: String
	let cta: String
	
	static let winner = Alert(title: "You win", subtitle: "Great job!", cta: "Woooooo!")
	static let unlucky = Alert(title: "You did great", subtitle: "Keep it up, maybe you'll win next time.", cta: "OK")
	static let starEarned = Alert(title: "You earned a star!", subtitle: "Keep making smart choices to earn more stars.", cta: "Keep it up!")
	static let empty = Alert(title: "", subtitle: "", cta: "")
}
