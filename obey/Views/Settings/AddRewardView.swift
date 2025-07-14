import SwiftData
import SwiftUI

struct AddRewardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.themeColor) private var themeColor

    @Query(sort: \SDUser.name) private var users: [SDUser]

    @State private var reward = SDReward()
    @State private var stepIndex: Int = 0
    @State private var isRewardInserted = false
    @FocusState private var isNameFocused: Bool
    @FocusState private var isIconFocused: Bool

    enum Step { case name, icon, users }

    private let steps: [Step] = [.name, .icon, .users]
    private var step: Step { steps[stepIndex] }

    var body: some View {
        NavigationStack {
            VStack {
                currentStepView
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { cancel() }
                }
            }
        }
        .fontDesign(.rounded)
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .animation(.easeIn, value: step)
    }

    @ViewBuilder
    private var currentStepView: some View {
        switch step {
        case .name:
            nameEntry.transition(stepTransition)
        case .icon:
            iconEntry.transition(stepTransition)
        case .users:
            userSelection.transition(stepTransition)
        }
    }

    private var nameEntry: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "trophy.fill")
                .font(.system(size: 100))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(themeColor)
            Text("What's the reward?")
                .font(.title)
                .bold()
            TextField("Reward name", text: $reward.name)
                .textFieldStyle(.plain)
                .font(.largeTitle)
                .focused($isNameFocused)
                .onAppear { isNameFocused = true }
            Spacer()
            Button(action: advance) {
                Label("Continue", systemImage: "arrow.right")
            }
            .buttonStyle(SCButtonStyle())
            .disabled(reward.name.isEmpty)
        }
    }

    private var iconEntry: some View {
        VStack(spacing: 20) {
            Spacer()
            Color.clear
                .overlay {
                    
                    Image(systemName: reward.systemImage)
                        .font(.system(size: 100))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(themeColor)
                }
                .frame(width: 100, height: 100)
            Text("Pick an icon")
                .font(.title)
                .bold()
            IconPickerView(selectedImageName: $reward.systemImage, tintColor: themeColor)
            Spacer()
            Button(action: advance) {
                Label("Continue", systemImage: "arrow.right")
            }
            .buttonStyle(SCButtonStyle())
        }
    }

    private var userSelection: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Which children can earn this reward?")
                .font(.title)
                .bold()
            List(users) { user in
                Toggle(isOn: binding(for: user)) {
                    HStack {
                        Circle()
                            .fill(user.swiftUIColor)
                            .frame(width: 20, height: 20)
                        Text(user.name)
                    }
                }
            }
            .listStyle(.plain)
            Spacer()
            Button(action: finalize) {
                Label("Done", systemImage: "checkmark")
            }
            .buttonStyle(SCButtonStyle())
        }
    }

    private func finalize() {
        insertRewardIfNeeded()
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving reward - \(error.localizedDescription)")
        }
    }

    private func advance() {
        if step == .name { insertRewardIfNeeded() }
        if isNameFocused { isNameFocused = false }
        if isIconFocused { isIconFocused = false }
        if stepIndex < steps.count - 1 { stepIndex += 1 }
    }

    private func cancel() {
        removeInsertedReward()
        dismiss()
    }

    private func insertRewardIfNeeded() {
        guard !isRewardInserted else { return }
        modelContext.insert(reward)
        isRewardInserted = true
    }

    private func removeInsertedReward() {
        guard isRewardInserted else { return }
        modelContext.delete(reward)
        isRewardInserted = false
    }

    private func binding(for user: SDUser) -> Binding<Bool> {
        Binding(
            get: { reward.users?.contains(where: { $0.id == user.id }) ?? false },
            set: { newValue in
                if newValue {
                    if reward.users == nil { reward.users = [] }
                    if !(reward.users?.contains(where: { $0.id == user.id }) ?? false) {
                        reward.users?.append(user)
                    }
                } else {
                    guard let idx = reward.users?.firstIndex(where: { $0.id == user.id }) else { return }
                    reward.users?.remove(at: idx)
                }
            }
        )
    }

    private var stepTransition: AnyTransition {
        .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading).combined(with: .opacity))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SDReward.self, SDUser.self, configurations: config)
    return AddRewardView()
        .modelContainer(container)
}
