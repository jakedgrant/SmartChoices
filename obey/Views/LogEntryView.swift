//
//  LogEntryView.swift
//  obey
//
//  Created by Jake Grant on 9/8/24.
//

import SwiftUI

struct LogEntryView: View {

    let timestamp: Date?
    let name: String?
    let systemImage: String?

    let odds: Int?
    let losses: Int?
    let increasedOdds: Bool?
    let userName: String?
    let userColor: Color?

    var starsSpent: Int? = nil

    var body: some View {

        Label {

            VStack(alignment: .leading, spacing: 4) {

                Text(name ?? "A reward")
                    .bold()
                    .font(.headline)

                if let timestamp {
                    Text(timestamp.formatted(date: .numeric, time: .shortened))
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }

                if let starsSpent {
                    StarsView(userName: userName, userColor: userColor, starsSpent: starsSpent)
                } else if let odds, let losses {
                    OddsView(userName: userName, userColor: userColor, odds: odds, losses: losses, increasedOdds: increasedOdds)
                }
            }

        } icon: {
            Image(systemName: systemImage ?? Constants.defaultImageName)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(userColor ?? .accentColor)
        }
        .fontDesign(.rounded)
    }
    
    
    private struct OddsView: View {
        let userName: String?
        let userColor: Color?
        let odds: Int
        let losses: Int
        let increasedOdds: Bool?

        var body: some View {
            HStack(spacing: 4) {
                UserBadge(userName: userName, userColor: userColor)
                BadgeLabel("1 : \(odds)", systemImage: "dice")
                BadgeLabel("\(losses)", systemImage: "star.slash")

                if increasedOdds == true {
                    BadgeLabel(nil, systemImage: "arrow.up")
                }
            }
            .font(.footnote)
        }
    }

    private struct StarsView: View {
        let userName: String?
        let userColor: Color?
        let starsSpent: Int

        var body: some View {
            HStack(spacing: 4) {
                UserBadge(userName: userName, userColor: userColor)
                BadgeLabel("\(starsSpent)", systemImage: "star.fill")
            }
            .font(.footnote)
        }
    }

    private struct UserBadge: View {
        let userName: String?
        let userColor: Color?

        var body: some View {
            if let userName {
                HStack(spacing: 4) {
                    Text(userName)
                }
                .foregroundStyle(userColor ?? .primary)
                .padding(.horizontal, 3)
                .padding(.vertical, 3)
                .background(
                    RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                        .fill((userColor ?? .primary).opacity(0.2))
                )
            }
        }
    }
}

#Preview {
    List {
        LogEntryView(
            timestamp: .now.addingTimeInterval(-60),
            name: "Pillow fight",
            systemImage: "figure.boxing",
            odds: 5,
            losses: 2,
            increasedOdds: true,
            userName: "Kid",
            userColor: .red
        )
        
        LogEntryView(
            timestamp: .now.addingTimeInterval(-60),
            name: "Pillow fight",
            systemImage: "figure.boxing",
            odds: 5,
            losses: 2,
            increasedOdds: true,
            userName: "Kid",
            userColor: .blue
        )
        
        LogEntryView(
            timestamp: .now.addingTimeInterval(-60),
            name: "Pillow fight",
            systemImage: "figure.boxing",
            odds: 5,
            losses: 2,
            increasedOdds: false,
            userName: "Kid",
            userColor: .green
        )
    }
}
