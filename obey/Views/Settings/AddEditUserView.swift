import SwiftData
import SwiftUI

struct AddEditUserView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var user: SDUser

    @Query(sort: \SDReward.name) private var rewards: [SDReward]

    @State private var isConfirmingDelete = false

    var body: some View {
        Form {
            Section("Name") {
                TextField("Child name", text: $user.name)
            }

            Section("Color") {
                StandardColorPicker(selection: $user.color)
            }

            Section("Rewards") {
                ForEach(rewards) { reward in
                    Toggle(isOn: binding(for: reward)) {
                        Label(reward.name, systemImage: reward.systemImage)
                    }
                }
            }

            Section {
                Button(role: .destructive) {
                    isConfirmingDelete = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .foregroundStyle(.white)
                .alert("Delete child", isPresented: $isConfirmingDelete) {
                    Button(role: .destructive) {
                        deleteUser(user)
                        dismiss()
                    } label: {
                        Text("Delete")
                    }
                } message: {
                    Text("Are you sure?")
                }
            }
            .listRowBackground(Color.red)
        }
        .navigationTitle(Text(user.name.isEmpty ? "New Child" : user.name))
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled()
        .fontDesign(.rounded)
    }

    private func deleteUser(_ user: SDUser) {
        modelContext.delete(user)
    }

    private func binding(for reward: SDReward) -> Binding<Bool> {
        Binding(
            get: { user.rewards?.contains(where: { $0.id == reward.id }) ?? false },
            set: { newValue in
                if newValue {
                    if user.rewards == nil { user.rewards = [] }
                    if !(user.rewards?.contains(where: { $0.id == reward.id }) ?? false) {
                        user.rewards?.append(reward)
                    }
                } else {
                    guard let idx = user.rewards?.firstIndex(where: { $0.id == reward.id }) else { return }
                    user.rewards?.remove(at: idx)
                }
            }
        )
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SDReward.self, SDUser.self, configurations: config)
    for r in Reward.allCases {
        let new = SDReward(name: r.description, systemImage: r.image)
        container.mainContext.insert(new)
    }
    let u = SDUser(name: "Preview")
    container.mainContext.insert(u)
    return AddEditUserView(user: u)
        .modelContainer(container)
}
