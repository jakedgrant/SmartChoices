//
//  RewardMode.swift
//  obey
//

import Foundation

enum RewardMode: String, CaseIterable, Identifiable {
	case surprise
	case stars

	var id: String { rawValue }

	var title: String {
		switch self {
		case .surprise: "Surprise"
		case .stars: "Stars"
		}
	}

	var explanation: String {
		switch self {
		case .surprise: "Every smart choice is a chance to win a surprise reward."
		case .stars: "Every smart choice earns a star. Save stars up and trade them in for rewards."
		}
	}

	var systemImage: String {
		switch self {
		case .surprise: "dice.fill"
		case .stars: "star.fill"
		}
	}

	/* The current mode from the shared defaults, for contexts without SwiftUI property wrappers (intents, helpers) */
	static var current: RewardMode {
		guard let defaults = UserDefaults(suiteName: Constants.suiteName),
			  let rawValue = defaults.string(forKey: Constants.rewardModeKey),
			  let mode = RewardMode(rawValue: rawValue) else {
			return .surprise
		}

		return mode
	}
}
