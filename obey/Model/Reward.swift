//
//  Reward.swift
//  obey
//
//  Created by Jake Grant on 6/28/24.
//

import Foundation

protocol Displayable: Identifiable {
	var image: String { get }
	var description: String { get }
}

enum Reward: CaseIterable, Identifiable, Displayable {
	case book
//	case treat
	case tv
	case game
	case parentPlay
//	case playDoh
//	case swim
	case blanketFort
//	case waterGunFight
//	case artSupplies
//	case iPad
	
	var id: String {
		image
	}
	
	var image: String {
		switch self {
		case .book:  "book.pages.fill"
//		case .treat: "birthday.cake.fill"
		case .tv:    "tv.inset.filled"
		case .game:  "dice.fill"
		case .parentPlay: "figure.and.child.holdinghands"
//		case .playDoh: "hand.wave.fill"
//		case .swim: "figure.pool.swim"
		case .blanketFort: "tent.fill"
//		case .waterGunFight: "figure.hunting"
//		case .artSupplies: "paintbrush.pointed.fill"
//		case .iPad: "ipad.gen1"
		}
	}
	
	var description: String {
		switch self {
		case .book:  "extra book at bedtime"
//		case .treat: "a TREAT"
		case .tv:    "extra screen time"
		case .game:  "play a game"
		case .parentPlay: "15 min play with mom or dad"
//		case .playDoh: "play with PLAYDOH"
//		case .swim: "go SWIMMING"
		case .blanketFort: "build a blanket fort"
//		case .waterGunFight: "WATER GUN FIGHT"
//		case .artSupplies: "new ART SUPPLIES"
//		case .iPad: "iPad time"
		}
	}
}
