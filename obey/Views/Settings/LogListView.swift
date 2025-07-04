//
//  LogListView.swift
//  obey
//
//  Created by Jake Grant on 9/6/24.
//

import SwiftData
import SwiftUI

struct LogListView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var nav: NavigationStateManager
    
    @Query(sort: \SDLog.timestamp, order: .reverse) private var logs: [SDLog]
    
    var body: some View {
        List {
            Section {
                DisclosureGroup("Key", content: {
                    KeyView()
                })
            }
            
            Section {
                ForEach(logs) { log in
                    LogEntryView(
                        timestamp: log.timestamp,
                        name: log.reward?.name,
                        systemImage: log.reward?.systemImage,
                        odds: log.odds,
                        losses: log.losses,
                        increasedOdds: log.increasedOdds,
                        userName: log.user?.name,
                        userColor: log.user?.swiftUIColor
                    )
                }
            }
        }
        .navigationTitle(Text(SDLog.sectionName))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SDReward.self, configurations: config)
    
    let r1 = SDReward(name: "r1", systemImage: "trophy.fill")
    let r2 = SDReward(name: "r2", systemImage: "car")
    
    container.mainContext.insert(r1)
    container.mainContext.insert(r2)
    
    let l1 = SDLog(timestamp: .init(timeIntervalSince1970: 1000), odds: 5, losses: 0, increasedOdds: true)
    l1.reward = r1
    let l2 = SDLog(timestamp: .init(timeIntervalSince1970: 0), odds: 6, losses: 6, increasedOdds: false)
    l2.reward = r1
    let l3 = SDLog(timestamp: .init(timeIntervalSince1970: 2000), odds: 6, losses: 2, increasedOdds: true)
    l3.reward = r2
    
    container.mainContext.insert(l1)
    container.mainContext.insert(l2)
    container.mainContext.insert(l3)
    
    return LogListView()
        .modelContainer(container)
        .environmentObject(NavigationStateManager())
}
