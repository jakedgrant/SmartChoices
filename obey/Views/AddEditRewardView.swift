//
//  AddEditRewardView.swift
//  obey
//
//  Created by Jake Grant on 7/26/24.
//

import SwiftData
import SwiftUI

struct AddEditRewardView: View {
	
	@Bindable var reward: SDReward
	
	@State private var isShowingIconPicker = false
	
    var body: some View {
		Form {
			
			Section("Name") {
				TextField("Reward description", text: $reward.name)
			}
			
			Section("Icon") {
				Button {
					isShowingIconPicker = true
				} label: {
					IconView(icon: reward.systemImage)
				}
				.sheet(isPresented: $isShowingIconPicker) {
					IconPickerView(selectedImageName: $reward.systemImage)
						.presentationDetents([.medium])
				}
				
			} footer: {
				HStack {
					Spacer()
					Button {
						// this kinda looks like it's for showing more icons...
					} label: {
						Text("More...")
					}
				}
			}
		}
		.fontWidth(.expanded)
    }
}

extension Section where Parent == Text, Content: View, Footer: View{
	
	init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content, @ViewBuilder footer: () -> Footer) {
		
		self.init(content: content, header: { Text(titleKey) }, footer: footer)
	}
	
	init<S>(_ title: S, @ViewBuilder content: () -> Content, @ViewBuilder footer: () -> Footer) where S : StringProtocol {
		
		self.init(content: content, header: { Text(title) }, footer: footer)
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: SDReward.self, configurations: config)
		
		let r = SDReward(name: "Preview reward")
		return AddEditRewardView(reward: r)
			.modelContainer(container)
	} catch {
		fatalError("Failed to create model container.")
	}
}
