//
//  obeyWatchApp.swift
//  obeyWatch Watch App
//
//  Created by Jake Grant on 7/2/24.
//

import SwiftData
import SwiftUI

@main
struct obeyWatch_Watch_AppApp: App {
	init() {
		RewardModelMigrator.migrateIfNeeded()
	}

	var body: some Scene {
		WindowGroup {
			ContentView()
		}
		.modelContainer(for: [SDReward.self, SDLog.self])
	}
}
