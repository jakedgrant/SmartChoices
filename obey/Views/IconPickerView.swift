//
//  IconPickerView.swift
//  obey
//
//  Created by Jake Grant on 7/23/24.
//

import SwiftUI

struct IconPickerView: View {
	@Binding var selectedImageName: String
	
	let columns = [
		GridItem(.adaptive(minimum: 60, maximum: 150))
	]
	
    var body: some View {
		ScrollView {
			
			ForEach(Icon.default.sets) { set in
			
				LazyVGrid(
					columns: columns,
					spacing: 8,
					pinnedViews: .sectionHeaders
				) {
					Section {
						ForEach(set.iconNames, id: \.self) { name in
							
							Button {
								selectedImageName = name
							} label: {
								IconView(icon: name)
									.overlay(
										RoundedRectangle(cornerRadius: 8)
											.stroke(.accent, lineWidth: selectedImageName == name ? 4 : 0)
									)
							}
							.padding(.bottom, 8)
						}
					} header: {
						
						VStack(spacing: 2) {
							HStack {
								Text(set.name)
									.fontWidth(.expanded)
									.foregroundStyle(.accent)
									.bold()
								Spacer()
							}
							.padding(.leading, 8)
							Divider()
						}
						.background(.gray.opacity(0.2))
						.background(.white)
					}
				}
			}
		}
    }
}

#Preview {
	IconPickerView(selectedImageName: .constant("figure.run"))
}
