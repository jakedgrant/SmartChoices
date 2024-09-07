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
		
		List(logs) { log in
			Label("t:\(log.timestamp.formatted()), r:\(log.reward?.name ?? "A reward")", systemImage: log.reward?.systemImage ?? Constants.defaultImageName)
		}
		.navigationTitle(Text("Reward History"))
    }
}

#Preview {
	let config = ModelConfiguration(isStoredInMemoryOnly: true)
	let container = try! ModelContainer(for: SDReward.self, configurations: config)
	
	let r1 = SDReward(name: "r1", systemImage: "trophy.fill")
	let r2 = SDReward(name: "r2", systemImage: "car")
	
	container.mainContext.insert(r1)
	container.mainContext.insert(r2)
	
	let l1 = SDLog(timestamp: .init(timeIntervalSince1970: 1000), reward: r1)
	let l2 = SDLog(timestamp: .init(timeIntervalSince1970: 0), reward: r1)
	let l3 = SDLog(timestamp: .init(timeIntervalSince1970: 2000), reward: r2)
	
	container.mainContext.insert(l1)
	container.mainContext.insert(l2)
	container.mainContext.insert(l3)
	
    return LogListView()
		.modelContainer(container)
}
