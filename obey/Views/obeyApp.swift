//
//  obeyApp.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import RevenueCat
import SwiftUI
import SwiftData

@main
struct obeyApp: App {
	init() {
		
        #if DEBUG
		Purchases.logLevel = .debug
        #endif
		
		// Use this initializer if your app does not have an account system.
		Purchases.configure(withAPIKey: Secrets.apiKey)

		/* Set the delegate to our shared instance of PurchasesDelegateHandler */
		Purchases.shared.delegate = PurchasesDelegateHandler.shared
	}


    var body: some Scene {
        WindowGroup {
            ContentView()
				.task {
					do {
						// Fetch the available offerings
						UserViewModel.shared.offerings = try await Purchases.shared.offerings()
					} catch {
						print("Error fetching offerings: \(error)")
					}
				}
        }
		.modelContainer(for: [SDReward.self, SDLog.self])
    }
}
