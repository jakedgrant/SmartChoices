import SwiftData
import SwiftUI

struct AddEditUserView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var user: SDUser

    @State private var isConfirmingDelete = false

    var body: some View {
        Form {
            Section("Name") {
                TextField("Child name", text: $user.name)
            }

            Section("Color") {
                StandardColorPicker(selection: $user.color)
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
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SDUser.self, configurations: config)
    let u = SDUser(name: "Preview")
    return AddEditUserView(user: u)
        .modelContainer(container)
}
