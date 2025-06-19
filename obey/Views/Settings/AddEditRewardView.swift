//
//  AddEditRewardView.swift
//  obey
//
//  Created by Jake Grant on 7/26/24.
//

import SwiftData
import SwiftUI

struct AddEditRewardView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var nav: NavigationStateManager
    @Environment(\.themeColor) private var themeColor
    
    @ObservedObject private var userViewModel = UserViewModel.shared
    
    @Bindable var reward: SDReward
    
    @State private var isShowingIconPicker = false
    @State private var isConfirmingDelete = false
    
    @Query(sort: \SDUser.name) private var users: [SDUser]
    
    @State private var logs: [SDLog] = []
    
    var body: some View {
        Form {
            
            Section("Name") {
                TextField("Reward description", text: $reward.name)
            }
            
            Section("Icon") {
                Button {
                    isShowingIconPicker = true
                } label: {
                    IconView(icon: reward.systemImage)
                }
                .sheet(isPresented: $isShowingIconPicker) {
                    IconPickerView(selectedImageName: $reward.systemImage)
                        .presentationDetents([.medium])
                }
            }
            
            Section("Users") {
                ForEach(users) { user in
                    Toggle(isOn: binding(for: user)) {
                        HStack {
                            Circle()
                                .fill(user.swiftUIColor)
                                .frame(width: 20, height: 20)
                            Text(user.name)
                        }
                    }
                    .disabled(disableToggle(for: user))
                }
            }
            
            Section {
                Toggle("Active", isOn: $reward.isActive)
                    .tint(themeColor)
                    .disabled(!userViewModel.unlockActive)
            } footer: {
                if !userViewModel.unlockActive {
                    Text("Subscribe to enable and disable rewards")
                }
            }
            
            Section {
                Button(role: .destructive) {
                    isConfirmingDelete = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .foregroundStyle(.white)
                .alert(
                    "Delete reward",
                    isPresented: $isConfirmingDelete
                ) {
                    Button(role: .destructive) {
                        deleteReward(reward)
                        dismiss()
                    } label: {
                        Text("Delete")
                    }
                } message: {
                    Text("Are you sure?")
                }
            }
            .listRowBackground(Color.red)
            
            Section("History") {
                if logs.isEmpty {
                    
                    Button {
                        guard userViewModel.unlockActive else {
                            nav.path.append(Route.paywall)
                            return
                        }
                        Task {
                            await getLogs()
                        }
                    } label: {
                        Label("Load reward history", systemImage: userViewModel.unlockActive ? "scroll" : "lock")
                    }
                } else {
                    
                    ForEach(logs) { log in
                        
                        LogEntryView(timestamp: log.timestamp, name: log.reward?.name, systemImage: log.reward?.systemImage, odds: log.odds, losses: log.losses, increasedOdds: log.increasedOdds, userName: log.user?.name, userColor: log.user?.swiftUIColor)
                            .transition(.opacity.animation(.easeInOut))
                    }
                }
            } footer: {
                
                if !userViewModel.unlockActive {
                    Text("Subscribe to view reward history")
                }
            }
        }
        .navigationTitle(Text(reward.name))
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled()
        .fontDesign(.rounded)
    }
    
    private func binding(for user: SDUser) -> Binding<Bool> {
        Binding(
            get: {
                reward.users?.contains(where: { $0.id == user.id }) ?? false
            },
            set: { newValue in
                if newValue {
                    if reward.users == nil { reward.users = [] }
                    if !(reward.users?.contains(where: { $0.id == user.id }) ?? false) {
                        reward.users?.append(user)
                    }
                } else {
                    guard let idx = reward.users?.firstIndex(where: { $0.id == user.id }),
                          (reward.users?.count ?? 0) > 1 else { return }
                    reward.users?.remove(at: idx)
                }
            }
        )
    }
    
    // Prevent unassigning the last user from a reward by disabling the
    // toggle when a single user is assigned. This enforces the rule that
    // every reward must have at least one associated user.
    private func disableToggle(for user: SDUser) -> Bool {
        reward.users?.contains(where: { $0.id == user.id }) == true && (reward.users?.count ?? 0) == 1
    }
    
    private func deleteReward(_ reward: SDReward) {
        modelContext.delete(reward)
    }
    
    private func getLogs() async {
        
        do {
            let db = try LogDatabase()
            
            let newlogs = db.logs(for: reward)
            
            withAnimation {
                logs = newlogs
            }
        } catch {
            print("Error trying to retrieve reward logs - \(error.localizedDescription)")
        }
    }
}

extension Section where Parent == Text, Content: View, Footer: View{
    
    init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content, @ViewBuilder footer: () -> Footer) {
        
        self.init(content: content, header: { Text(titleKey) }, footer: footer)
    }
    
    init<S>(_ title: S, @ViewBuilder content: () -> Content, @ViewBuilder footer: () -> Footer) where S : StringProtocol {
        
        self.init(content: content, header: { Text(title) }, footer: footer)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SDReward.self, configurations: config)
        
        let r = SDReward(name: "Preview reward")
        return AddEditRewardView(reward: r)
            .modelContainer(container)
            .environmentObject(NavigationStateManager())
    } catch {
        fatalError("Failed to create model container.")
    }
}
