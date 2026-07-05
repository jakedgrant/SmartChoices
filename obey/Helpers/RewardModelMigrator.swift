//
//  RewardModelMigrator.swift
//  obey
//

import Foundation

/* One-time migrations for changes to the rewards model.
 Version 2 introduced reward modes and star-based rewards. */
struct RewardModelMigrator {

	static let currentVersion = 2

	public static func migrateIfNeeded() {
		guard let defaults = UserDefaults(suiteName: Constants.suiteName) else {
			return
		}

		let version = defaults.integer(forKey: Constants.rewardModelVersionKey)
		guard version < currentVersion else {
			return
		}

		migrateToRewardModes(defaults)

		defaults.setValue(currentVersion, forKey: Constants.rewardModelVersionKey)
	}

	/* Existing users predate reward modes: keep them on the surprise mechanic they know,
	 skip the new-user reward setup, and seed their star balance from accumulated losses
	 so switching to stars later doesn't start them from zero.
	 Fresh installs are left untouched so onboarding can run.
	 Existing rewards receive a default star cost through SwiftData's lightweight migration. */
	private static func migrateToRewardModes(_ defaults: UserDefaults) {

		guard isExistingUser(defaults) else {
			return
		}

		if defaults.string(forKey: Constants.rewardModeKey) == nil {
			defaults.setValue(RewardMode.surprise.rawValue, forKey: Constants.rewardModeKey)
		}

		if defaults.object(forKey: Constants.starBalanceKey) == nil {
			defaults.setValue(defaults.integer(forKey: "losses"), forKey: Constants.starBalanceKey)
		}

		defaults.setValue(true, forKey: Constants.hasCompletedRewardSetupKey)
	}

	/* Users upgrading from 1.1+ have a stored version string; users upgrading from
	 older versions are recognized by their existing rewards. */
	private static func isExistingUser(_ defaults: UserDefaults) -> Bool {

		if let previousVersion = defaults.string(forKey: "previousVersionString"),
		   previousVersion != Constants.startingVersion {
			return true
		}

		guard let db = try? RewardDatabase() else {
			return false
		}

		return !db.allRewards().isEmpty
	}
}
