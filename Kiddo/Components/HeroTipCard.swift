//
//  HeroTipCard.swift
//  Kiddo
//
//  Created by Dev Jr.1 on 19/04/26.
//

import SwiftUI

struct HeroTipCard: View {
    let emoji: String
    let title: String
    let description: String
    let timeText: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Text(emoji)
                .font(.largeTitle)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(red: 0.18, green: 0.22, blue: 0.28))
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack {
                    Image(systemName: "clock")
                    Text(timeText)
                }
                .font(.caption)
                .foregroundColor(.green)
                .padding(.top, 2)
            }
            Spacer()
        }
        .padding()
        .background(Color(red: 0.91, green: 0.96, blue: 0.91))
        .cornerRadius(20)
    }
}
