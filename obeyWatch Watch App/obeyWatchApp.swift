//
//  obeyWatchApp.swift
//  obeyWatch Watch App
//
//  Created by Jake Grant on 7/2/24.
//

import RevenueCat
import SwiftData
import SwiftUI

@main
struct obeyWatch_Watch_AppApp: App {

    @StateObject private var selectedUserManager = SelectedUserManager.shared
    
    init() {
#if DEBUG
        Purchases.logLevel = .debug
#endif
        
        // Use this initializer if your app does not have an account system.
        let defaults = UserDefaults(suiteName: Constants.suiteName) ?? UserDefaults.standard
        Purchases.configure(
            with: Configuration.Builder(withAPIKey: Secrets.apiKey)
                .with(userDefaults: defaults)
                .build()
        )
        Purchases.configure(withAPIKey: Secrets.apiKey)
        
        /* Set the delegate to our shared instance of PurchasesDelegateHandler */
        Purchases.shared.delegate = PurchasesDelegateHandler.shared
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .themeColor(selectedUserManager.selectedUser?.color.color ?? .accentColor)
        }
        .modelContainer(for: [SDReward.self, SDLog.self, SDUser.self])
    }
}
