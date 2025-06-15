import SwiftData
import SwiftUI

struct MultiUserMigrationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject private var selectedUserManager = SelectedUserManager.shared

    @AppStorage("userMigrationCompleted", store: UserDefaults(suiteName: Constants.suiteName))
    private var migrationCompleted: Bool = false

    @Query(sort: \SDReward.name) private var rewards: [SDReward]

    @State private var user = SDUser()
    @State private var step: Step = .welcome

    private enum Step { case welcome, name, color, rewards }

    var body: some View {
        VStack {
            currentStepView
        }
        .fontDesign(.rounded)
        .padding()
        .animation(.easeInOut, value: step)
    }

    @ViewBuilder
    private var currentStepView: some View {
        switch step {
        case .welcome:
            welcome.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        case .name:
            nameEntry.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        case .color:
            colorPicker.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        case .rewards:
            rewardSelection.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        }
    }

    private var welcome: some View {
        VStack(spacing: 20) {
            Text("We're adding support for multiple kids! Let's set up a profile and move your rewards.")
                .font(.title)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
            Button(action: {
                modelContext.insert(user)
                selectedUserManager.selectedUser = user
                step = .name
            }) {
                Label("Continue", systemImage: "arrow.right")
            }
            .buttonStyle(SCButtonStyle())
        }
    }

    private var nameEntry: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Who do we want to reward?")
                .font(.title)
            TextField("Name", text: $user.name)
                .textFieldStyle(.roundedBorder)
            Button(action: { step = .color }) {
                Label("Continue", systemImage: "arrow.right")
            }
            .buttonStyle(SCButtonStyle())
            .disabled(user.name.isEmpty)
        }
    }

    private var colorPicker: some View {
        VStack(spacing: 20) {
            Text("Pick their favorite color")
                .font(.title)
            ColorPicker("", selection: Binding(
                get: { user.swiftUIColor },
                set: { user.color = CodableColor($0) }
            ), supportsOpacity: false)
            .labelsHidden()
            .scaleEffect(2)
            Button(action: { step = .rewards }) {
                Label("Continue", systemImage: "arrow.right")
            }
            .buttonStyle(SCButtonStyle())
        }
    }

    private var rewardSelection: some View {
        VStack(alignment: .leading) {
            Text("How do we want to reward them?")
                .font(.title)
            Text("You can add more rewards later")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            List(rewards) { reward in
                Toggle(isOn: binding(for: reward)) {
                    Label(reward.name, systemImage: reward.systemImage)
                }
            }
            Button(action: { finalize() }) {
                Label("Continue", systemImage: "arrow.right")
            }
            .buttonStyle(SCButtonStyle())
            .frame(maxWidth: .infinity)
        }
    }

    private func finalize() {
        do {
            try modelContext.save()
            migrationCompleted = true
            dismiss()
        } catch {
            print("Error saving user - \(error.localizedDescription)")
        }
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
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SDReward.self, SDUser.self, configurations: config)
        let view = MultiUserMigrationView()
        return view.modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
