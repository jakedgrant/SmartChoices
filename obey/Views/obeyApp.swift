//
//  obeyApp.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import RevenueCat
import SwiftUI
import SwiftData
import TipKit
import CoreData

@main
struct obeyApp: App {
    
    @StateObject private var selectedUserManager = SelectedUserManager.shared
    let modelContainer: ModelContainer
    
    init() {
        
#if DEBUG
        Purchases.logLevel = .debug
        do {
            try Tips.resetDatastore()
        } catch {
            print("error reseting tips: \(error)")
        }
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
        
        
        do {
            // Configure and load all tips in the app.
            try Tips.configure()
        }
        catch {
            print("Error initializing tips: \(error)")
        }
        
        let config = ModelConfiguration()
        
        
        do {
#if DEBUG
            // Use an autorelease pool to make sure Swift deallocates the persistent
            // container before setting up the SwiftData stack.
            try autoreleasepool {
                let desc = NSPersistentStoreDescription(url: config.url)
                let opts = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.jacobgrant.obey")
                desc.cloudKitContainerOptions = opts
                // Load the store synchronously so it completes before initializing the
                // CloudKit schema.
                desc.shouldAddStoreAsynchronously = false
                if let mom = NSManagedObjectModel.makeManagedObjectModel(for: [SDReward.self, SDLog.self, SDUser.self]) {
                    let container = NSPersistentCloudKitContainer(name: "Trips", managedObjectModel: mom)
                    container.persistentStoreDescriptions = [desc]
                    container.loadPersistentStores {_, err in
                        if let err {
                            fatalError(err.localizedDescription)
                        }
                    }
                    // Initialize the CloudKit schema after the store finishes loading.
                    try container.initializeCloudKitSchema()
                    // Remove and unload the store from the persistent container.
                    if let store = container.persistentStoreCoordinator.persistentStores.first {
                        try container.persistentStoreCoordinator.remove(store)
                    }
                }
            }
#endif
            modelContainer = try ModelContainer(for: SDReward.self, SDLog.self, SDUser.self,
                                                configurations: config)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .themeColor(selectedUserManager.selectedUser?.swiftUIColor ?? .accentColor)
                .task {
                    do {
                        // Fetch the available offerings
                        UserViewModel.shared.offerings = try await Purchases.shared.offerings()
                    } catch {
                        print("Error fetching offerings: \(error)")
                    }
                }
        }
        .modelContainer(modelContainer)
    }
}
