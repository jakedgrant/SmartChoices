import SwiftData
import SwiftUI

struct AddRewardFlowView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.themeColor) private var themeColor

    @Query(sort: \SDUser.name) private var users: [SDUser]

    @State private var reward = SDReward()
    @State private var stepIndex: Int = 0
    @State private var isRewardInserted = false
    @FocusState private var isNameFocused: Bool
    @FocusState private var isIconFocused: Bool

    enum Step: CaseIterable { case name, icon, users }

    private var step: Step { Step.allCases[stepIndex] }

    var body: some View {
        NavigationStack {
            VStack {
                currentStepView
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { cancelAdd() }
                }
            }
        }
        .fontDesign(.rounded)
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .animation(.easeIn, value: step)
        .onAppear { if step == .name { insertRewardIfNeeded() } }
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
            Image(systemName: reward.systemImage)
                .font(.system(size: 100))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(themeColor)
            Text("Pick an icon")
                .font(.title)
                .bold()
            TextField("Icon name", text: $reward.systemImage)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .font(.title)
                .focused($isIconFocused)
                .onAppear { isIconFocused = true }
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
                .multilineTextAlignment(.center)
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
        do {
            insertRewardIfNeeded(force: true)
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving reward - \(error.localizedDescription)")
        }
    }

    private func advance() {
        if isNameFocused { isNameFocused = false }
        if isIconFocused { isIconFocused = false }
        if stepIndex < Step.allCases.count - 1 {
            stepIndex += 1
        }
    }

    private func cancelAdd() {
        isNameFocused = false
        isIconFocused = false
        removeInsertedReward()
        dismiss()
    }

    private func removeInsertedReward() {
        guard isRewardInserted else { return }
        modelContext.delete(reward)
        isRewardInserted = false
    }

    private func insertRewardIfNeeded(force: Bool = false) {
        guard step == .name || force else { return }
        guard !isRewardInserted else { return }
        modelContext.insert(reward)
        isRewardInserted = true
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
                    guard let idx = reward.users?.firstIndex(where: { $0.id == user.id }),
                          (reward.users?.count ?? 0) > 1 else { return }
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
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SDReward.self, SDUser.self, configurations: config)
        for i in 1...3 {
            let u = SDUser(name: "User \(i)")
            container.mainContext.insert(u)
        }
        let view = AddRewardFlowView()
        return view.modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
