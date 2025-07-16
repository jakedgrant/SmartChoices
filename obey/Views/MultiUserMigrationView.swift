import SwiftData
import SwiftUI
import RevenueCatUI

struct MultiUserMigrationView: View {
    
    @AppStorage("userMigrationCompleted", store: UserDefaults(suiteName: Constants.suiteName))
    private var migrationCompleted: Bool = false
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.themeColor) private var themeColor
    
    @FocusState private var isNameFocused: Bool

    @ObservedObject private var selectedUserManager = SelectedUserManager.shared
    @ObservedObject private var userViewModel = UserViewModel.shared
    
    @Query(sort: \SDReward.name) private var rewards: [SDReward]
    
    @State private var user = SDUser()
    @State private var stepIndex: Int
    @State private var isUserInserted = false
    @State private var isCanceled = false
    @State private var showPaywall = false
    @State private var previousUser: SDUser?
    @State private var userWasAdded = false

    enum Step { case intro, welcome, name, color, rewards }

    enum Flow {
        case migration
        case addUser
        case onboarding

        var steps: [Step] {
            switch self {
            case .migration:
                return [.welcome, .name, .color, .rewards]
            case .addUser:
                return [.name, .color, .rewards]
            case .onboarding:
                return [.intro, .name, .color, .rewards]
            }
        }
    }

    private let flow: Flow
    private var steps: [Step] { flow.steps }
    private var step: Step { steps[stepIndex] }

    init(flow: Flow = .migration) {
        self.flow = flow
        _stepIndex = State(initialValue: 0)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                currentStepView
            }
            .toolbar {
                if flow == .addUser {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { cancelAdd() }
                    }
                }
            }
        }
        .fontDesign(.rounded)
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .animation(.easeIn, value: step)
        .onAppear { if step == .name { insertUserIfNeeded() } }
        .sheet(isPresented: $showPaywall, onDismiss: {
            dismiss()
            SwitchUserTip.didAddUserEvent.sendDonation()
        }) {
            PaywallView()
        }
        .sensoryFeedback(.increase, trigger: stepIndex)
        .sensoryFeedback(.success, trigger: userWasAdded) { _, new in new == true }
    }
    
    @ViewBuilder
    private var currentStepView: some View {
        switch step {
        case .intro:
            intro.transition(stepTransition)
        case .welcome:
            welcome.transition(stepTransition)
        case .name:
            nameEntry.transition(stepTransition)
        case .color:
            colorPicker.transition(stepTransition)
        case .rewards:
            rewardSelection.transition(stepTransition)
        }
    }

    private var intro: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "hands.and.sparkles.fill")
                .font(.system(size: 100))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(themeColor)
            Text("Welcome to Smart Choices! Rewards are more meaningful when earned. Roll the dice for a chance to win, and keep trying if you don't.")
                .font(.title)
                .bold()
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: {
                insertUserIfNeeded(force: true)
                advance()
            }) {
                Label("Continue", systemImage: "arrow.right")
            }
            .buttonStyle(SCButtonStyle())
        }
    }
    
    private var welcome: some View {
        VStack(spacing: 20) {
            Spacer()
            ReplacingImage(from: "person.fill", to: "person.3.fill")
                .foregroundStyle(themeColor)
            Text("We're adding support for multiple kids! Let's set up a profile and move your rewards.")
                .font(.title)
                .bold()
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: {
                insertUserIfNeeded(force: true)
                advance()
            }) {
                Label("Continue", systemImage: "arrow.right")
            }
            .buttonStyle(SCButtonStyle())
        }
    }
    
    private var nameEntry: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "person.crop.circle")
                .font(.system(size: 100))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(themeColor)
            Text("Who do we want to reward?")
                .font(.title)
                .bold()
            TextField("Name", text: $user.name)
                .textFieldStyle(.plain)
                .font(.largeTitle)
                .focused($isNameFocused)
                .onAppear { isNameFocused = true }
            Spacer()
            Button(action: advance) {
                Label("Continue", systemImage: "arrow.right")
            }
            .buttonStyle(SCButtonStyle())
            .disabled(user.name.isEmpty)
        }
    }
    
    private var colorPicker: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "paintpalette.fill")
                .font(.system(size: 100))
                .symbolRenderingMode(.multicolor)
            Text("What is \(user.name.possessive) favorite color?")
                .font(.title)
                .bold()
            StandardColorPicker(selection: $user.color)
                .frame(maxWidth: 300)
            Spacer()
            Button(action: advance) {
                Label("Continue", systemImage: "arrow.right")
            }
            .buttonStyle(SCButtonStyle())
        }
    }
    
    private var rewardSelection: some View {
        VStack(spacing: 20) {
            Spacer()
            VStack(alignment: .leading) {
                Text("How do we want to reward \(user.name)?")
                    .font(.title)
                    .bold()
                Text("You can add more rewards later")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            List(rewards) { reward in
                Toggle(isOn: binding(for: reward)) {
                    Label(reward.name, systemImage: reward.systemImage)
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
            insertUserIfNeeded()
            try modelContext.save()
            userWasAdded = true
            migrationCompleted = true
            if (flow == .onboarding || flow == .migration) && !userViewModel.unlockActive {
                showPaywall = true
            } else {
                dismiss()
                SwitchUserTip.didAddUserEvent.sendDonation()
            }
        } catch {
            print("Error saving user - \(error.localizedDescription)")
        }
    }

    private func advance() {
        if isNameFocused {
            isNameFocused = false
        }
        if stepIndex < steps.count - 1 {
            stepIndex += 1
        }
    }

    private func cancelAdd() {
        isCanceled = true
        isNameFocused = false
        removeInsertedUser()
        dismiss()
    }

    private func removeInsertedUser() {
        guard flow == .addUser else { return }
        guard isUserInserted else { return }
        modelContext.delete(user)
        selectedUserManager.selectedUser = previousUser
        isUserInserted = false
    }

    private func insertUserIfNeeded(force: Bool = false) {
        guard step == .name || force else { return }
        guard !isUserInserted else { return }
        modelContext.insert(user)
        previousUser = selectedUserManager.selectedUser
        selectedUserManager.selectedUser = user
        isUserInserted = true
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
    
    private var stepTransition: AnyTransition {
        .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading).combined(with: .opacity))
    }
}

struct ReplacingImage: View {
    let startImage: String
    let endImage: String
    
    @State private var showGroup = false
    
    init(from startImage: String, to endImage: String) {
        self.startImage = startImage
        self.endImage = endImage
    }
    
    var body: some View {
        Image(systemName: showGroup ? endImage : startImage)
            .font(.system(size: 100)).contentTransition(
                .symbolEffect(
                    .replace.magic(fallback: .replace)
                )
            )
            .symbolRenderingMode(.hierarchical)
            .onAppear {
                // trigger the swap after a brief delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        showGroup = true
                    }
                }
            }
    }
}

private extension String {
    /// Returns the possessive form of the string, appending
    /// just an apostrophe if it already ends in "s", otherwise "'s".
    var possessive: String {
        guard let last = lowercased().last else { return self }
        if last == "s" {
            return self + "'"
        } else {
            return self + "'s"
        }
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
