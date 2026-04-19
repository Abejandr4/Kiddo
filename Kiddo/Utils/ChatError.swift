// Utils/ChatError.swift
import Foundation

enum ChatError: Error, LocalizedError {
    case noSession
    case modelUnavailable
    case generationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .noSession:
            return "Chat session has not been started. Please restart the app."
        case .modelUnavailable:
            return "Apple Intelligence is not available on this device or is not enabled."
        case .generationFailed(let reason):
            return "Failed to generate a response: \(reason)"
        }
    }
}
