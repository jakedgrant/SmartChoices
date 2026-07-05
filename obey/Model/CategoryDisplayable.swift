//
//  CategoryDisplayable.swift
//  obey
//
//  Created by Jake Grant on 6/29/25.
//

import Foundation

protocol CategoryDisplayable {
    
    static var displayName: String { get }
    static var sectionName: String { get }
}

extension SDUser: CategoryDisplayable {

    static var displayName: String { "Child" }
    static var sectionName: String { "Children" }
}

extension SDLog: CategoryDisplayable {

    static var displayName: String { "Log" }
    static var sectionName: String { "Reward History" }
}

extension SDReward: CategoryDisplayable {
    
    static var displayName: String { "Reward" }
    static var sectionName: String { "Rewards" }
}

