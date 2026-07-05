//
//  ContentView.swift
//  obeyWatch Watch App
//
//  Created by Jake Grant on 7/2/24.
//

import CoreData
import SwiftData
import SwiftUI

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @ObservedObject private var selectedUserManager = SelectedUserManager.shared
    @Query var rewards: [SDReward]
    
    var body: some View {
        NavigationStack {
            Group {
                if selectedUserManager.selectedUser == nil && rewards.isEmpty {
                    NoticeView(navigationTitle: "Open the app", message: "Open the app on your phone to set up rewards and children", imageName: "apps.iphone")
                } else {
                    ContentTabView()
                }
            }
            .onReceive(
                NotificationCenter.default.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification)
            ) { notification in
                
                guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey] as? NSPersistentCloudKitContainer.Event else {
                    return
                }
                
                if event.endDate != nil && event.type == .import {
                    Task { @MainActor in
                        
                        let rewardFetchDescriptor = FetchDescriptor<SDReward>(
                            predicate: nil,
                            sortBy: [.init(\.name)]
                        )
                        _ = try? modelContext.fetch(rewardFetchDescriptor)
                    }
                }
            }
        }
    }
}




#Preview {
    ContentView()
}
