// Models/ChatMessage.swift
import Foundation

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let sender: MessageSender
    let timestamp: Date
}

enum MessageSender {
    case user, ai
}

struct QuickQuestion: Identifiable {
    let id = UUID()
    let icon: String
    let text: String
}
