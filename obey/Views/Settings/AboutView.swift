//
//  AboutView.swift
//  obey
//
//  Created by Jake Grant on 9/11/24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
		ScrollView {
			VStack {
				Button {
					
				} label: {
					Image(systemName: "hands.and.sparkles.fill")
						.scaleEffect(2.8)
						.symbolRenderingMode(.hierarchical)
						
				}
				.buttonStyle(SCCircleButtonStyle(padding: 40))
				.padding(.top, 40)
				
				VStack(alignment: .leading, spacing: 20) {
					Group {
						Text("Thanks for checking out Smart Choices!")
						
						Text("I owe the inspiration and direction of this app to my wife. She asked for an app to randomly reward our children when they made Smart Choices.")
						
						Text("This app has been a great tool for our family to help build good habits and behaviors in our children.")
						
						Text("I hope you find it useful too.")
						
						Text("- Jake")
					}
					.font(.title3)
				}
				.padding(40)
			}
		}
		.navigationTitle("About")
		.navigationBarTitleDisplayMode(.inline)
		.fontDesign(.rounded)
    }
}

#Preview {
    AboutView()
}
