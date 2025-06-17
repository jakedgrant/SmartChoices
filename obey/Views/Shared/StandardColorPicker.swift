import SwiftUI

struct StandardColorPicker: View {
        @Binding var selection: StandardColor

        private let columns = [GridItem(.adaptive(minimum: 44))]

        var body: some View {
                LazyVGrid(columns: columns) {
                        ForEach(StandardColor.allCases, id: \.self) { color in
                                Button {
                                        selection = color
                                } label: {
                                        Circle()
                                                .fill(color.color)
                                                .frame(width: 40, height: 40)
                                                .overlay {
                                                        if selection == color {
                                                                Circle()
                                                                        .stroke(Color.primary, lineWidth: 3)
                                                        }
                                                }
                                }
                        }
                }
        }
}

struct StandardColorPicker_Previews: PreviewProvider {
        struct Wrapper: View {
                @State var selected = StandardColor.allCases.first!

                var body: some View {
                        StandardColorPicker(selection: $selected)
                }
        }

        static var previews: some View {
                Wrapper()
        }
}
