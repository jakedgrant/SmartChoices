//
//  Roll.swift
//  obey
//
//  Created by Jake Grant on 7/11/24.
//

import Foundation

struct Roll {

    public static func perform() -> Bool {

        // get odds
        var odds = getOdds()
        if odds < 1 {
            odds = resetOdds()
        }

        // get losses
        let losses = getLosses()

        let result = Int.random(in: 1...odds)

        if result == 1 {

            LastStat.shared.update(odds: odds, losses: losses, increasedOdds: true)

            decreaseOdds()
            resetLosses()
            return true
        } else if losses >= odds {

            LastStat.shared.update(odds: odds, losses: losses, increasedOdds: false)

            resetLosses()
            return true
        } else {

            updateLosses(to: losses + 1)
            return false
        }
    }

    public static func perform(for user: SDUser) -> Bool {

        var odds = user.odds
        if odds < 1 {
            odds = resetOdds(for: user)
        }

        let losses = user.losses

        let result = Int.random(in: 1...odds)

        if result == 1 {

            LastStat.shared.update(odds: odds, losses: losses, increasedOdds: true)

            decreaseOdds(for: user)
            resetLosses(for: user)
            return true
        } else if losses >= odds {

            LastStat.shared.update(odds: odds, losses: losses, increasedOdds: false)

            resetLosses(for: user)
            return true
        } else {

            updateLosses(for: user, to: losses + 1)
            return false
        }
    }

	
    @discardableResult
    public static func resetOdds() -> Int {
        let startingOdds = Constants.startingOdds
        updateOdds(to: startingOdds)
        return startingOdds
    }

    @discardableResult
    public static func resetOdds(for user: SDUser) -> Int {
        let startingOdds = Constants.startingOdds
        user.odds = startingOdds
        return startingOdds
    }
	
    private static func getOdds() -> Int {
        guard let defaults = UserDefaults(suiteName: Constants.suiteName) else {
            return 0
        }

        return defaults.integer(forKey: "odds")
    }
	
    private static func updateOdds(to value: Int) {
        guard let defaults = UserDefaults(suiteName: Constants.suiteName) else {
            return
        }

        defaults.setValue(value, forKey: "odds")
    }
	
    public static func decreaseOdds() {
        var odds = getOdds()
        if odds < Constants.maxOdds {
            odds += 1
            updateOdds(to: odds)
        }
    }

    public static func decreaseOdds(for user: SDUser) {
        var odds = user.odds
        if odds < Constants.maxOdds {
            odds += 1
            user.odds = odds
        }
    }
	
    private static func getLosses() -> Int {
        guard let defaults = UserDefaults(suiteName: Constants.suiteName) else {
            return 0
        }

        return defaults.integer(forKey: "losses")
    }
	
    private static func updateLosses(to value: Int) {
        guard let defaults = UserDefaults(suiteName: Constants.suiteName) else {
            return
        }

        defaults.setValue(value, forKey: "losses")
    }
	
    private static func resetLosses() {
        updateLosses(to: 0)
    }

    private static func updateLosses(for user: SDUser, to value: Int) {
        user.losses = value
    }

    private static func resetLosses(for user: SDUser) {
        updateLosses(for: user, to: 0)
    }
}
