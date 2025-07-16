//
//  ContentView.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import Recap
import RevenueCat
import SwiftData
import SwiftUI
import TipKit

struct ContentView: View {
    @AppStorage("odds", store: UserDefaults(suiteName: Constants.suiteName)) var odds: Int = Constants.startingOdds
    @AppStorage("losses", store: UserDefaults(suiteName: Constants.suiteName)) var losses: Int = 0
    @AppStorage("previousVersionString", store: UserDefaults(suiteName: Constants.suiteName)) var previousVersionString: String = Constants.startingVersion
    @AppStorage("userMigrationCompleted", store: UserDefaults(suiteName: Constants.suiteName)) var userMigrationCompleted: Bool = false
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.themeColor) private var themeColor
    
    @ObservedObject private var userViewModel = UserViewModel.shared
    @ObservedObject private var selectedUserManager = SelectedUserManager.shared
    
    @Query var rewards: [SDReward]
    @Query(sort: \SDUser.name) var users: [SDUser]
    
    @State private var isPresenting = false
    @State private var isShowingRewards = false
    @State private var isShowingSettings = false
    @State private var isShowingRecap = false
    @State private var isShowingMigration = false
    @State private var releasePackage: ReleasePackage? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                ShiftingMeshGradientView(color: themeColor)
                    .ignoresSafeArea()

                VStack {
                    
                    Button("Smart Choice", action: roll)
                        .buttonStyle(SCCircleButtonStyle(padding: 80))
                        .font(.title2)
                    
                        .alert(
                            Alert.unlucky.title,
                            isPresented: $isPresenting,
                            presenting: Alert.unlucky
                        ) { state in
                            
                            Button("Reward Anyway") {
                                LastStat.shared.update(odds: odds, losses: losses, increasedOdds: false)
                                isShowingRewards = true
                            }
                            Button(state.cta, role: .cancel) { }
                        } message: { state in
                            Text(state.subtitle)
                        }
                    
                        .sheet(isPresented: $isShowingRewards) {
                            RewardListView(modelContext: self.modelContext)
                        }
                    
                        .sensoryFeedback(.error, trigger: isPresenting) { _, new in new == true }
                        .sensoryFeedback(.success, trigger: isShowingRewards) { _, new in new == true }
                }
                
                VStack {
                    
                    Picker(SDUser.displayName, selection: $selectedUserManager.selectedUser) {
                        ForEach(users) { user in
                            Text(user.name).tag(Optional(user))
                                .fontDesign(.rounded)
                        }
                    }
                    .pickerStyle(.menu)
                    .sensoryFeedback(.selection, trigger: selectedUserManager.selectedUser)
                    
                    TipView(SwitchUserTip(), arrowEdge: .top)
                        .padding(.horizontal)
                    
                    Spacer()
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        isShowingSettings = true
                    } label: {
                        MenuImageView()
                    }
                }
            }
            
            .sheet(isPresented: $isShowingSettings) {
                SettingsView()
            }
            
            .sheet(isPresented: $isShowingMigration, onDismiss: {
                selectedUserManager.ensureSelectedUser(context: modelContext)
            }) {
                MultiUserMigrationView(
                    flow: previousVersionString == Constants.startingVersion ? .onboarding : .migration
                )
                .interactiveDismissDisabled(true)
            }
            
            .task {
                await populateRewards()
                if userMigrationCompleted {
                    selectedUserManager.ensureSelectedUser(context: modelContext)
                } else {
                    isShowingMigration = true
                }
            }
        }
        .tint(themeColor)
    }
    
    private func roll() {
        let result = if let selectedUser = selectedUserManager.selectedUser {
            Roll.perform(for: selectedUser)
        } else {
            Roll.perform()
        }
        isPresenting = !result
        isShowingRewards = result
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

#Preview {
    ContentView()
}
