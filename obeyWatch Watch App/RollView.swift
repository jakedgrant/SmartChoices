//
//  RollView.swift
//  obey
//
//  Created by Jake Grant on 7/3/25.
//

import SwiftData
import SwiftUI

struct RollView: View {
    @Environment(\.modelContext) var modelContext
    @Query var rewards: [SDReward]
    
    var selectedUser: SDUser?
    
    @State private var isShowingRewards = false
    @State private var isAlerting = false
    
    var body: some View {
        VStack {
            if let selectedUser, !rewards.isEmpty {
                Button("Smart Choice", action: { roll(for: selectedUser) })
                    .bold()
                    .fontDesign(.rounded)
            } else {
                
            }
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
