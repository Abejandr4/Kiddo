//
//  MessageBubble.swift
//  Kiddo
//
//  Created by Dev Jr.1 on 19/04/26.
//

import SwiftUI


struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.sender == .user { Spacer() }
            
            VStack(alignment: message.sender == .user ? .trailing : .leading, spacing: 4) {
                if message.sender == .ai {
                    HStack {
                        Image(systemName: "sparkles").foregroundColor(Color(hex: "7BC67E"))
                        Text("Asistente IA").font(.caption2).bold().foregroundColor(Color(hex: "7BC67E"))
                    }
                }
                
                Text(message.text)
                    .font(.subheadline)
                    .padding(12)
                    .background(message.sender == .user ?
                                LinearGradient(colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")], startPoint: .leading, endPoint: .trailing) :
                                LinearGradient(colors: [Color(hex: "F7FAFC")], startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(message.sender == .user ? .white : Color(hex: "2D3748"))
                    .cornerRadius(18)
                
                Text(message.timestamp, style: .time)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: message.sender == .user ? .trailing : .leading)
            
            if message.sender == .ai { Spacer() }
        }
    }
}
