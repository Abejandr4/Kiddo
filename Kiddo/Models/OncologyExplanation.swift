import FoundationModels

@Generable
struct OncologyExplanation {
    @Guide(description: "Plain-language explanation of the topic")
    var explanation: String
    
    @Guide(description: "Common questions patients ask about this")
    var commonQuestions: [String]
    
    @Guide(description: "When to consult a specialist")
    var whenToSeeDoctor: String
}

