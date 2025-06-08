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
	
	let container: ModelContainer
	
	init() {		
		do {
			container = try ModelContainer(
				for: SDReward.self, SDLog.self, SDUser.self,
				migrationPlan: ObeyMigrationPlan.self
			)
		} catch {
			fatalError("Failed to initialize model container.")
		}
	}


    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
