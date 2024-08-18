//
//  IconView.swift
//  obey
//
//  Created by Jake Grant on 8/18/24.
//

import SwiftUI

struct IconView: View {
	
	let icon: String
	
	var body: some View {
		Image(systemName: icon)
			.padding(4)
			.frame(width: 58, height: 58)
			.background(
				RoundedRectangle(cornerRadius: 8)
					.opacity(0.2)
			)
			.symbolRenderingMode(.hierarchical)
	}
}

#Preview {
	IconView(icon: "figure.water.fitness")
}
