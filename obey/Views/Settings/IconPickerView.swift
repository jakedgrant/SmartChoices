//
//  IconPickerView.swift
//  obey
//
//  Created by Jake Grant on 7/23/24.
//

import SwiftUI

struct IconPickerView: View {
	@Binding var selectedImageName: String
    
    @Environment(\.dismiss) var dismiss
    
    var tintColor: Color
	
	let columns = [
		GridItem(.adaptive(minimum: 60, maximum: 150))
	]
	
    var body: some View {
            ScrollView {
                
                ForEach(Icon.default.sets) { set in
                    
                    LazyVGrid(
                        columns: columns,
                        spacing: 8,
                    ) {
                        
                        Section {
                            ForEach(set.iconNames, id: \.self) { name in
                                
                                Button {
                                    
                                    withAnimation {
                                        selectedImageName = name
                                    }
                                } label: {
                                    
                                    Image(systemName: name)
                                        .frame(width: 58, height: 58)
                                        .symbolRenderingMode(.hierarchical)
                                        .background {
                                            RoundedRectangle(cornerRadius: 8)
                                                .opacity(selectedImageName == name ? 0.2 : 0.0)
                                        }
                                }
                                .tint(selectedImageName == name ? tintColor : .primary)
                                .sensoryFeedback(.selection, trigger: selectedImageName)
                            }
                        } header: {
                            
                            VStack(spacing: 2) {
                                HStack {
                                    Text(set.name)
                                        .fontDesign(.rounded)
                                        .foregroundStyle(.gray)
                                        .bold()
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 12)
    }
}

struct NavigationWrappedIconPickerView: View {
    @Binding var selectedImageName: String
    
    @Environment(\.dismiss) var dismiss
    
    var tintColor: Color
    
    var body: some View {
        NavigationView {
            IconPickerView(selectedImageName: $selectedImageName, tintColor: tintColor)
                .navigationTitle("Icons")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        CloseButton { dismiss() }
                    }
                }
        }
    }
}

struct IconPickerView_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var selected = Icon.default.sets.first?.iconNames.first ?? "plane"
        
        var body: some View {
            IconPickerView(selectedImageName: $selected, tintColor: .blue)
        }
    }
    
    static var previews: some View {
        Wrapper()
    }
}
