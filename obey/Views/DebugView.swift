//
//  DebugView.swift
//  obey
//
//  Created by Jake Grant on 6/26/24.
//

import SwiftUI

struct DebugView: View {
	@AppStorage("odds") var odds: Int = Constants.startingOdds
	
    var body: some View {
		VStack {
			Text("Odds are 1 in \(odds)")
			Button("Reset Odds") {
				odds = Constants.startingOdds
			}
		}
    }
}

#Preview {
    DebugView()
}
