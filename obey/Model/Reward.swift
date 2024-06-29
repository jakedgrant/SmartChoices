//
//  Reward.swift
//  obey
//
//  Created by Jake Grant on 6/28/24.
//

import Foundation

enum Reward: CaseIterable, Identifiable {
	case book
	case treat
	case tv
	
	var id: String {
		image
	}
	
	var image: String {
		switch self {
		case .book:  "book.pages.fill"
		case .treat: "birthday.cake.fill"
		case .tv:    "tv.inset.filled"
		}
	}
	
	var description: String {
		switch self {
		case .book:  "extra BOOK at bedtime"
		case .treat: "a TREAT"
		case .tv:    "extra TV time"
		}
	}
}
