// Utils/OncologyKnowledgeTool.swift
import FoundationModels
import Foundation

struct OncologyKnowledgeTool: Tool {
    let name = "lookupOncologyTopic"
    let description = "Look up verified information about a cancer type, drug, or treatment"

    @Generable
    struct Arguments {
        @Guide(description: "The oncology topic, e.g. 'chemotherapy', 'immunotherapy'")
        var topic: String
    }

    nonisolated func call(arguments: Arguments) async throws -> String {
        guard let url = Bundle.main.url(
            forResource: "OncologyKnowledge",
            withExtension: "json"
        ) else {
            return "Knowledge base not found."
        }

        let data = try Data(contentsOf: url)
        let db = try JSONDecoder().decode(OncologyDatabase.self, from: data)

        let match = db.topics.first {
            $0.id.lowercased() == arguments.topic.lowercased() ||
            $0.aliases.contains { $0.lowercased() == arguments.topic.lowercased() }
        }

        guard let entry = match else {
            return "No specific entry found for '\(arguments.topic)'. Provide general guidance."
        }

        return """
        Summary: \(entry.summary)
        How it works: \(entry.howItWorks)
        Common side effects: \(entry.commonSideEffects.joined(separator: ", "))
        Contact care team if: \(entry.contactCareTeamIf.joined(separator: ", "))
        Source: \(entry.source)
        """
    }
}
