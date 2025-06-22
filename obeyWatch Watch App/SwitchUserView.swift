import SwiftData
import SwiftUI

struct SwitchUserView: View {
        @Environment(\.modelContext) private var modelContext
        @Query(sort: \SDUser.name) private var users: [SDUser]

        @ObservedObject private var selectedUserManager = SelectedUserManager.shared
        @ObservedObject private var userViewModel = UserViewModel.shared
        @Environment(\.themeColor) private var themeColor

        var body: some View {
                if userViewModel.unlockActive {
                        List(users) { user in
                                Button(action: { selectedUserManager.selectedUser = user }) {
                                        HStack {
                                                Text(user.name)
                                                if selectedUserManager.selectedUser == user {
                                                        Spacer()
                                                        Image(systemName: "checkmark")
                                                                .foregroundStyle(themeColor)
                                                }
                                        }
                                }
                                .tint(themeColor)
                        }
                        .listStyle(.carousel)
                } else {
                        VStack {
                                Spacer()
                                Image(systemName: "lock.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(themeColor)
                                Text("Subscribe to unlock multiple users")
                                        .multilineTextAlignment(.center)
                                        .padding()
                                Spacer()
                        }
                }
        }
}

#Preview {
        SwitchUserView()
}
