//
//  ManageRewardsSwipeActionsTip.swift
//  obey
//
//  Created by Jake Grant on 9/15/24.
//

import TipKit

struct ManageRewardsSwipeActionsTip: Tip {
	var title: Text {
		Text("Swipe Actions")
	}
	
	var message: Text? {
		Text("Swipe right-to-left to delete\nSwipe left-to-right to enable/disable (subscription required)")
	}
	
	var image: Image? {
		Image(systemName: "hand.draw")
	}
}
