//
//  ObeyShortcuts.swift
//  obey
//
//  Created by Jake Grant on 7/11/24.
//

import AppIntents
import Foundation

class ObeyShortcuts: AppShortcutsProvider {
	static var shortcutTileColor = ShortcutTileColor.teal
	
	static var appShortcuts: [AppShortcut] {
		
		AppShortcut(
			intent: OpenAppIntent(),
			phrases: [
				"Open \(.applicationName)",
				"Go to \(.applicationName)",
			],
			shortTitle: "Open app",
			systemImageName: "arrow.up.forward.square.fill"
		)
		
		AppShortcut(
			intent: RollForRewardIntent(),
			phrases: [
				"Reward in \(.applicationName)",
				"I made \(.applicationName)",
				"Reward me for a \(.applicationName)",
			],
			shortTitle: "Reward",
			systemImageName: "hands.and.sparkles"
		)
	}
}
