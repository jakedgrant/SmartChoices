//
//  BigButtonTip.swift
//  obey
//
//  Created by Jake Grant on 9/16/24.
//

import TipKit

struct BigButtonTip: Tip {
	var title: Text {
		Text("Get started!")
	}
	
	var message: Text? {
		Text("Let your child tap the big button when they make a smart choice")
	}
}
