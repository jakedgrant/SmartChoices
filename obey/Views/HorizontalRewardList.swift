//
//  HorizontalRewardList.swift
//  obey
//
//  Created by Jake Grant on 7/12/24.
//

import Foundation
import SwiftUI

struct HorizontalRewardList<T>: View where T: Displayable {
	var items: ArraySlice<T>
	var showDescription: Bool
	
	let imageSize = 44.0
	
	var body: some View {
		HStack {
			ForEach(items) { item in
				VStack {
					Image(systemName: item.image)
						.symbolRenderingMode(.hierarchical)
						.frame(width: imageSize, height: imageSize)
					if showDescription {
						Text(item.description)
					}
				}
				.padding(20)
				.overlay(
					RoundedRectangle(cornerRadius: 25)
						.fill(Color.clear)
						.strokeBorder(style: StrokeStyle(lineWidth: 2))
				)
			}
		}
	}
}

#Preview {
	let rewards = Reward.allCases.shuffled().prefix(3)
	return HorizontalRewardList(items: rewards, showDescription: false)
}
