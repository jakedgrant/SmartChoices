import SwiftData
import SwiftUI

struct SwitchUserView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SDUser.name) private var users: [SDUser]
    
    @ObservedObject private var selectedUserManager = SelectedUserManager.shared
    
    @Environment(\.themeColor) private var themeColor
    
    var body: some View {
        NavigationStack {
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
}

#Preview {
    SwitchUserView()
}
