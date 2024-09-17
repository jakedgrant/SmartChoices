//
//  LogRewardTip.swift
//  obey
//
//  Created by Jake Grant on 9/15/24.
//

import TipKit

struct LogRewardTip: Tip {
	var title: Text {
		Text("Select a reward")
	}
	
	var message: Text? {
		Text("Tap a reward to select it and add it to the reward log.")
	}
	
	var image: Image? {
		Image(systemName: "hand.tap")
	}
}
