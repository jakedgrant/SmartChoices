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
