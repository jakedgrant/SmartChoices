import SwiftData
import SwiftUI

struct AddEditUserView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @Bindable var user: SDUser
    @State private var isConfirmingDelete = false

    var body: some View {
        Form {
            Section("Name") {
                TextField("Name", text: $user.name)
            }

            Section("Color") {
                ColorPicker("Color", selection: Binding(
                    get: { user.swiftUIColor },
                    set: { user.color = CodableColor($0) }
                ))
            }

            Section {
                Button(role: .destructive) {
                    isConfirmingDelete = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .foregroundStyle(.white)
                .alert(
                    "Delete user",
                    isPresented: $isConfirmingDelete
                ) {
                    Button(role: .destructive) {
                        modelContext.delete(user)
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
        .navigationTitle(Text(user.name.isEmpty ? "New User" : user.name))
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled()
        .fontDesign(.rounded)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: SDUser.self, configurations: config)
    let u = SDUser(name: "Preview")
    return AddEditUserView(user: u)
        .modelContainer(container)
}
