//
//  KeyView.swift
//  obey
//
//  Created by Jake Grant on 9/8/24.
//

import SwiftUI

struct KeyView: View {
    var body: some View {
		
		VStack(alignment: .leading) {
			BadgeLabel("Odds of being rewarded", systemImage: "dice")
			BadgeLabel("# of losses prior", systemImage: "star.slash")
			BadgeLabel("Odds were increased", systemImage: "arrow.up")
		}
		.font(.footnote)
    }
}

#Preview {
    KeyView()
}
