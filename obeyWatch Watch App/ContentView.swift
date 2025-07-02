//
//  ContentView.swift
//  obeyWatch Watch App
//
//  Created by Jake Grant on 7/2/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    
    @Environment(\.themeColor) var themeColor
    @Environment(\.modelContext) var modelContext
    @Query var rewards: [SDReward]
    @ObservedObject private var selectedUserManager = SelectedUserManager.shared
    @State private var isSwitchingUser = false
    
    var body: some View {
        NavigationStack {
            TabView {
                
                RollView(selectedUser: selectedUserManager.selectedUser)
                    .containerBackground(themeColor.gradient, for: .tabView)
                
                List {
                    StatsView()
                }
                .navigationTitle("Stats for \(selectedUserManager.selectedUser?.name ?? "All")")
                .tint(themeColor)
            }
            .tabViewStyle(.verticalPage)
            .sheet(isPresented: $isSwitchingUser) {
                SwitchUserView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isSwitchingUser = true
                    } label: {
                        Label("Switch Child", systemImage: "person.crop.circle")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        
        .task {
            await populateRewards()
            selectedUserManager.ensureSelectedUser(context: modelContext)
        }
    }
    
    private func populateRewards() async {
        
        if rewards.isEmpty {
            
            Reward.allCases.forEach {
                let newReward = SDReward(name: $0.description, systemImage: $0.image)
                modelContext.insert(newReward)
            }
            
            do {
                try modelContext.save()
            } catch {
                print("error saving log - \(error.localizedDescription)")
            }
        }
    }
}

struct RollView: View {
    @Environment(\.modelContext) var modelContext
    @Query var rewards: [SDReward]
    @Environment(\.themeColor) private var themeColor
    
    var selectedUser: SDUser?
    
    @State private var isShowingRewards = false
    @State private var isAlerting = false
    
    var body: some View {
        VStack {
            Button("Smart Choice", action: { roll(for: selectedUser) })
                .bold()
                .fontDesign(.rounded)
        }
        .alert(
            Alert.unlucky.title,
            isPresented: $isAlerting,
            presenting: Alert.unlucky
        ) { state in
            Button(state.cta) { }
        } message: { state in
            Text(state.subtitle)
        }
        .sheet(isPresented: $isShowingRewards) {
            RewardListView(modelContext: self.modelContext)
        }
    }
    
    private func roll(for user: SDUser?) {
        
        let result = if let user {
            Roll.perform(for: user)
        } else {
            Roll.perform()
        }
        
        if result {
            isShowingRewards = true
        } else {
            isAlerting = true
        }
    }
}


#Preview {
    ContentView()
}
