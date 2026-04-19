import Foundation
import Observation
import FoundationModels

@Observable
class OncologyChatService {
    
    private var session: LanguageModelSession?
    
    var isAvailable: Bool {
        SystemLanguageModel.default.isAvailable
    }
    
    private let instructions = """
    You are a compassionate oncology information assistant. Your role is to help
    users understand cancer-related topics: diagnoses, treatment options, side
    effects, and lifestyle guidance. You are NOT a doctor and do NOT provide
    personalized medical advice or diagnosis.

    Guidelines:
    - Provide clear, compassionate, evidence-based information
    - Always recommend consulting an oncologist for personal medical decisions
    - Use plain language, avoiding unnecessary jargon
    - If asked about diagnoses or treatments, explain concepts without replacing clinical advice
    - Do not speculate on a specific patient's prognosis
    """
    
    func startSession() {
        session = LanguageModelSession(instructions: instructions)
    }
    
    // ① Simple one-shot response
    func respond(to message: String) async throws -> String {
        guard let session else { throw ChatError.noSession }
        return try await session.respond(to: message).content
    }
    
    // ② Streaming response — lives HERE, same file
    func streamResponse(to message: String) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    guard let session else { throw ChatError.noSession }
                    let stream = session.streamResponse(to: message)
                    for try await partial in stream {
                        continuation.yield(partial.content)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    // ③ Structured output
    // Managers/OncologyChatService.swift
    func explainTopic(_ topic: String) async throws -> OncologyExplanation {
        guard let session else { throw ChatError.noSession }
        let response = try await session.respond(
            to: topic,
            generating: OncologyExplanation.self
        )
        return response.content
    }
}
