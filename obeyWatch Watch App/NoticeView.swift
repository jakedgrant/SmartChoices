//
//  NoticeView.swift
//  obey
//
//  Created by Jake Grant on 7/2/25.
//

import SwiftUI

struct NoticeView: View {
    
    @Environment(\.themeColor) private var themeColor
    
    let navigationTitle: String
    let message: String
    let imageName: String
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: imageName)
                .font(.largeTitle)
                .foregroundStyle(themeColor)
            Text(message)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
        .navigationTitle(navigationTitle)
    }
}


