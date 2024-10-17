//
//  LastStat.swift
//  obey
//
//  Created by Jake Grant on 10/16/24.
//

import Foundation

final public class LastStat {
	
	static let shared = LastStat()
	fileprivate init() { }
	
	private(set) var odds: Int = 0
	private(set) var losses: Int = 0
	private(set) var increasedOdds: Bool = false
	
	public func update(odds: Int, losses: Int, increasedOdds: Bool) {
		self.odds = odds
		self.losses = losses
		self.increasedOdds = increasedOdds
	}
}
