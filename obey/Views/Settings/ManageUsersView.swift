import SwiftData
import SwiftUI

struct ManageUsersView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var nav: NavigationStateManager

    @Query(sort: \SDUser.name) private var users: [SDUser]

    var body: some View {
        List {
            ForEach(users) { user in
                NavigationLink(value: user) {
                    HStack {
                        Circle()
                            .fill(user.swiftUIColor)
                            .frame(width: 20, height: 20)
                        Text(user.name)
                    }
                }
            }
        }
        .navigationTitle(Text("Manage Users"))
        .navigationDestination(for: SDUser.self) { AddEditUserView(user: $0) }
        .safeAreaInset(edge: .bottom) {
            Button(action: addUser) {
                Label("Add new user", systemImage: "plus")
            }
            .buttonStyle(SCButtonStyle())
            .frame(maxWidth: .infinity)
        }
        .fontDesign(.rounded)
    }

    private func addUser() {
        let newUser = SDUser(name: "")
        modelContext.insert(newUser)
        nav.path.append(newUser)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SDUser.self, configurations: config)

    return ManageUsersView()
        .modelContainer(container)
        .environmentObject(NavigationStateManager())
}
