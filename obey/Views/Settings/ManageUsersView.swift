import SwiftData
import SwiftUI

struct ManageUsersView: View {
	@Environment(\.modelContext) private var modelContext
	@EnvironmentObject private var nav: NavigationStateManager
	
	@ObservedObject private var userViewModel = UserViewModel.shared
	private let selectedUserManager = SelectedUserManager.shared
	
    @Query(sort: \SDUser.name) private var users: [SDUser]
    @State private var userToDelete: SDUser?
    @State private var isShowingAddFlow = false
	
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
					.padding(10)
				}
				.swipeActions(edge: .trailing) {
					Button(role: .destructive) {
						userToDelete = user
					} label: {
						Label("Delete", systemImage: "trash")
					}
				}
			}
		}
		.navigationTitle(Text("Manage Users"))
        .navigationBarTitleDisplayMode(.inline)
		.navigationDestination(for: SDUser.self) { AddEditUserView(user: $0) }
		.alert("Delete user", isPresented: Binding(
			get: { userToDelete != nil },
			set: { if !$0 { userToDelete = nil } }
		)) {
			Button(role: .destructive) {
				if let user = userToDelete {
					deleteUser(user)
				}
			} label: {
				Text("Delete")
			}
			Button("Cancel", role: .cancel) {}
		} message: {
			Text("Are you sure?")
		}
                .safeAreaInset(edge: .bottom) {
                        Button(action: addUser) {
                                Label(
                                        allowsAddUser() ? "Add new user" : "Unlock to add multiple users",
                                        systemImage: allowsAddUser() ? "plus" : "lock"
                                )
                        }
                        .buttonStyle(SCButtonStyle())
                        .frame(maxWidth: .infinity)
                        .animation(.default, value: users.count)
                }
                .sheet(isPresented: $isShowingAddFlow) {
                        MultiUserMigrationView(flow: .addUser)
                }
                .fontDesign(.rounded)
        }
	
	private func deleteUser(_ user: SDUser) {
		modelContext.delete(user)
		userToDelete = nil
		
		if selectedUserManager.selectedUser == user {
			selectedUserManager.selectedUser = users.first { $0.id != user.id }
		}
	}
	
        private func addUser() {
                guard allowsAddUser() else {
                        nav.path.append(Route.paywall)
                        return
                }

                isShowingAddFlow = true
        }
	
	private func allowsAddUser() -> Bool {
		if userViewModel.unlockActive {
			return true
		}
		
		return users.count < 1
	}
}

#Preview {
	let config = ModelConfiguration(isStoredInMemoryOnly: true)
	let container = try! ModelContainer(for: SDUser.self, configurations: config)
	for i in 1...3 {
		let u = SDUser(name: "User \(i)")
		container.mainContext.insert(u)
	}
	return ManageUsersView()
		.modelContainer(container)
		.environmentObject(NavigationStateManager())
}
