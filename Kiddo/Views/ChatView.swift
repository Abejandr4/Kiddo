import SwiftUI

struct AIChatViewFF: View {
    @State private var messages: [Message] = [
        Message(text: "¡Hola! Soy tu asistente virtual de salud. Estoy aquí para ayudarte con dudas sobre medicamentos, nutrición, cuidados y efectos secundarios durante el tratamiento de leucemia. ¿En qué puedo ayudarte hoy?",
                sender: .ai,
                timestamp: Date())
    ]
    @State private var inputText: String = ""
    @State private var isTyping: Bool = false

    // Full Q&A dictionary for the faux AI
    let qaResponses: [String: String] = [
        "¿Efectos secundarios de Prednisona?": "La Prednisona es un corticosteroide común en tratamientos de leucemia. Sus efectos secundarios incluyen cambios de humor, aumento del apetito, retención de líquidos e insomnio. Es importante tomarla con alimentos y nunca suspenderla bruscamente.",
        "Alimentos recomendados": "Durante el tratamiento se recomienda priorizar proteínas magras (pollo, huevo, legumbres), frutas y verduras bien lavadas, y granos enteros. Evita alimentos crudos o sin pasteurizar si tu sistema inmune está comprometido.",
        "¿Cómo manejar las náuseas?": "El Ondansetrón (Zofran) es muy efectivo para las náuseas. También ayuda comer porciones pequeñas y frías, evitar olores fuertes, y descansar sentado después de comer. Infórmale a tu médico si persisten.",
        "¿Cuándo llamar al doctor?": "Llama de inmediato si presentas fiebre mayor a 38°C, sangrado inusual, dificultad para respirar, dolor de pecho, o signos de infección. Estos pueden ser señales de alerta importantes durante el tratamiento."
    ]

    // All available quick questions
    let allQuickQuestions = [
        QuickQuestion(icon: "pill.fill",                      text: "¿Efectos secundarios de Prednisona?"),
        QuickQuestion(icon: "fork.knife",                     text: "Alimentos recomendados"),
        QuickQuestion(icon: "heart.fill",                     text: "¿Cómo manejar las náuseas?"),
        QuickQuestion(icon: "exclamationmark.triangle.fill",  text: "¿Cuándo llamar al doctor?")
    ]

    // Pick 2 random questions once on init
    @State private var shownQuickQuestions: [QuickQuestion] = []

    var body: some View {
        VStack(spacing: 0) {
            headerView
            disclaimerView

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                        }

                        if isTyping {
                            TypingIndicator()
                        }

                        Color.clear
                            .frame(height: 1)
                            .id("bottom")
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _ in
                    withAnimation { proxy.scrollTo("bottom", anchor: .bottom) }
                }
            }
            .background(Color.white)
            .cornerRadius(30, corners: [.topLeft, .topRight])
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)

            if messages.count <= 2 {
                quickQuestionsSection
            }

            inputArea
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
        .onAppear {
            shownQuickQuestions = Array(allQuickQuestions.shuffled().prefix(2))
        }
    }
}

// MARK: - Subviews

extension AIChatViewFF {  // ✅ Name now matches the struct above

    private var headerView: some View {
        HStack(spacing: 15) {
            Circle()
                .fill(LinearGradient(
                    colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
                .frame(width: 45, height: 45)
                .overlay(
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading) {
                Text("Asistente Médico")
                    .font(.headline)
                    .foregroundColor(Color(hex: "2D3748"))
                Text("Respuestas rápidas a tus dudas")
                    .font(.caption)
                    .foregroundColor(Color(hex: "718096"))
            }
            Spacer()
        }
        .padding()
    }

    private var disclaimerView: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(Color(hex: "FFB366"))
            Text("**Importante:** Esta información es educativa. Siempre consulta con tu equipo médico.")
                .font(.caption)
                .foregroundColor(Color(hex: "4A5568"))
        }
        .padding(12)
        .background(Color(hex: "FFE6CC").opacity(0.5))
        .cornerRadius(15)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }

    private var quickQuestionsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(shownQuickQuestions) { q in
                    ActionButton(q.text) {
                        handleSendMessage(text: q.text)
                    }
                    .scaleEffect(0.7)
                    .frame(height: 80)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color.white)
    }

    private var inputArea: some View {
        HStack(spacing: 12) {
            TextField("Escribe tu pregunta aquí...", text: $inputText)
                .padding()
                .background(Color(hex: "F7FAFC"))
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color(hex: "E2E8F0"), lineWidth: 1)
                )

            Button(action: { handleSendMessage() }) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(12)
                    .background(LinearGradient(
                        colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")],
                        startPoint: .leading,
                        endPoint: .trailing))
                    .clipShape(Circle())
            }
            .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding()
        .background(Color.white)
    }
}

// MARK: - Logic

extension AIChatViewFF {

    func handleSendMessage(text: String? = nil) {
        let messageText = text ?? inputText
        guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        messages.append(Message(text: messageText, sender: .user, timestamp: Date()))
        inputText = ""
        isTyping = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            messages.append(Message(text: getAIResponse(for: messageText), sender: .ai, timestamp: Date()))
            isTyping = false
        }
    }

    func getAIResponse(for text: String) -> String {
        // 1. Try exact match from the Q&A dictionary first
        if let exactAnswer = qaResponses[text] {
            return exactAnswer
        }

        // 2. Fall back to keyword matching for free-text input
        let msg = text.lowercased()
        if msg.contains("prednisona") {
            return qaResponses["¿Efectos secundarios de Prednisona?"]!
        }
        if msg.contains("náuseas") || msg.contains("nauseas") {
            return qaResponses["¿Cómo manejar las náuseas?"]!
        }
        if msg.contains("alimento") || msg.contains("comer") || msg.contains("nutrici") {
            return qaResponses["Alimentos recomendados"]!
        }
        if msg.contains("doctor") || msg.contains("llamar") || msg.contains("emergencia") || msg.contains("alerta") {
            return qaResponses["¿Cuándo llamar al doctor?"]!
        }

        // 3. Generic fallback
        return "Entiendo tu pregunta. Puedo ayudarte con dudas sobre medicamentos, nutrición y signos de alerta. ¿Quieres que profundice en alguno de estos temas?"
    }
}

// MARK: - Preview

struct AIChatViewFF_Previews: PreviewProvider {
    static var previews: some View {
        AIChatViewFF()
    }
}
