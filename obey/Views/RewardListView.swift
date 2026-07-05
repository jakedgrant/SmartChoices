//
//  RewardListView.swift
//  obey
//
//  Created by Jake Grant on 6/28/24.
//

import ConfettiSwiftUI
import SwiftData
import SwiftUI
import TipKit

struct RewardListView: View {
    @Environment(\.dismiss) var dismiss
    
    var modelContext: ModelContext
    
    @State private var topRewards: [SDReward]
    @State private var otherRewards: [SDReward]
    @State private var showAllRewards = false
    @State private var counter = 1
    @State private var hasLoggedReward = false
    @State private var isConfirmingDismiss = false
    
    let logRewardTip = LogRewardTip()
    
    init(modelContext: ModelContext) {
        
        self.modelContext = modelContext
        
        let fetchDescriptor = FetchDescriptor<SDReward>(predicate: #Predicate<SDReward> { $0.isActive }, sortBy: [])
        
        do {
            var rewards = try modelContext.fetch(fetchDescriptor).shuffled()
            
            if let selectedUser = SelectedUserManager.shared.selectedUser {
                rewards = rewards.filter { reward in
                    reward.users?.contains(where: { $0.id == selectedUser.id }) ?? false
                }
            }
            
            topRewards = Array(rewards.prefix(3))
            otherRewards = Array(rewards.dropFirst(3))
            
        } catch {
            print("uh oh: \(error.localizedDescription)")
            self.topRewards = []
            self.otherRewards = []
        }
    }
    
    var body: some View {
        
        NavigationStack {
            List {
                Section("Top Rewards") {
                    ForEach(topRewards) { reward in
                        
                        Button {
                            log(reward)
                        } label: {
                            Label(reward.name, systemImage: reward.systemImage)
                        }
                        .buttonStyle(SCButtonStyle())
                        .sensoryFeedback(.success, trigger: hasLoggedReward)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(.init(top: -8, leading: 0, bottom: -8, trailing: 0))
                    }
                }
                
                TipView(logRewardTip)
                    .tipBackground(.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                if showAllRewards {
                    Section("More Rewards") {
                        
                        ForEach(otherRewards) { reward in
                            
                            Button {
                                log(reward)
                            } label: {
                                Label(reward.name, systemImage: reward.systemImage)
                            }
                            .buttonStyle(SCButtonStyle())
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init(top: -8, leading: 0, bottom: -8, trailing: 0))
                        }
                    }
                }
            }
            .navigationTitle(Text(SDReward.sectionName))
            
            .safeAreaInset(edge: .bottom) {
                if !otherRewards.isEmpty {
                    ShowHideButton(isShowing: $showAllRewards)
                        .sensoryFeedback(.increase, trigger: showAllRewards) { _, new in new == true }
                        .sensoryFeedback(.decrease, trigger: showAllRewards) { _, new in new == false }
                }
            }
            
            .confettiCannon(
                counter: $counter,
                num: 100,
                rainHeight: 700,
                radius: 400
            )
            
            .onAppear {
                counter += 1
            }
            
            .navigationBarTitleDisplayMode(.inline)
            
            .interactiveDismissDisabled()
            
            .toolbar {
                ToolbarItem {
                    CloseButton {
                        if hasLoggedReward {
                            dismiss()
                        } else {
                            isConfirmingDismiss = true
                        }
                    }
                }
            }
            
            .alert(
                "No reward selected",
                isPresented: $isConfirmingDismiss
            ) {
                Button("Stay Here", role: .cancel) { }
                Button("Dismiss Anyway", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("Select a reward before closing or dismiss anyway.")
            }
        }
        .fontDesign(.rounded)
    }
    
    private struct ShowHideButton: View {
        
        @Binding var isShowing: Bool
        
        var body: some View {
            Button {
                withAnimation {
                    isShowing.toggle()
                }
            } label: {
                
                Label(isShowing ? "hide" : "show more rewards",
                      systemImage: isShowing ? "xmark.circle.fill" : "plus.circle.fill")
            }
            .buttonStyle(SCButtonStyle())
            .background(Color.clear)
            .frame(maxWidth: .infinity)
        }
    }
    
    private func log(_ reward: SDReward) {
        
        let selectedUser = SelectedUserManager.shared.selectedUser
        let log = SDLog(
            odds: selectedUser?.odds ?? LastStat.shared.odds,
            losses: selectedUser?.losses ?? LastStat.shared.losses,
            increasedOdds: LastStat.shared.increasedOdds
        )
        log.reward = reward
        log.user = selectedUser
        
        modelContext.insert(log)
        
        do {
            try modelContext.save()
        } catch {
            print("error saving log - \(error.localizedDescription)")
        }
        
        hasLoggedReward = true
        
        dismiss()
    }
}
