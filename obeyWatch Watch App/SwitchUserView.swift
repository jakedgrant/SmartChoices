import SwiftData
import SwiftUI

struct SwitchUserView: View {
    
    @ObservedObject private var userViewModel = UserViewModel.shared
    
    var body: some View {
        NavigationStack {
            if userViewModel.unlockActive {
                SelectUserListView()
            } else {
                UnlockView()
            }
        }
    }
}

struct SelectUserListView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SDUser.name) private var users: [SDUser]
    
    @ObservedObject private var selectedUserManager = SelectedUserManager.shared
    
    @Environment(\.themeColor) private var themeColor
    
    var body: some View {
        List(users) { user in
            Button {
                selectedUserManager.selectedUser = user
                dismiss()
            } label: {
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
        .navigationTitle("Select child")
    }
}

struct UnlockView: View {
    
    @Environment(\.themeColor) private var themeColor
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "lock.fill")
                .font(.largeTitle)
                .foregroundStyle(themeColor)
            Text("Subscribe to unlock multiple children")
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
        .navigationTitle("Unlock")
    }
}

#Preview {
    SwitchUserView()
}
