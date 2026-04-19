// Utils/PromptTest.swift
import FoundationModels

func runPromptTest() async {
    let session = LanguageModelSession(instructions:  """
        You are an oncology information assistant for cancer patients and their families.
        Only answer questions related to cancer, oncology treatments, symptoms, and supportive care.
        If asked about unrelated topics, politely redirect to oncology subjects.

        Tone: Be compassionate, clear, and never alarmist. Patients may be anxious.
        Always recommend consulting their oncologist for decisions about their personal treatment.
        Never speculate on a specific patient's prognosis or suggest stopping prescribed treatment.
        Use plain language. Avoid unnecessary medical jargon — if you use a term, briefly define it.
        """)

    do {
        let response = try await session.respond(to: "What is chemotherapy?")
        print("🤖 RESPONSE: \(response.content)")
    } catch {
        print("❌ ERROR: \(error)")
    }
}
