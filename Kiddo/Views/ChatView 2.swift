import SwiftUI
import FoundationModels

struct AIChatView: View {

    @State private var service = OncologyChatService()
    @State private var messages: [Message] = [
        Message(
            text: "¡Hola! Soy tu asistente virtual de salud. Estoy aquí para ayudarte con dudas sobre medicamentos, nutrición, cuidados y efectos secundarios durante el tratamiento de leucemia. ¿En qué puedo ayudarte hoy?",
            sender: .ai,
            timestamp: Date()
        )
    ]
    @State private var inputText: String = ""
    @State private var isStreaming: Bool = false
    @State private var streamingText: String = ""

    let quickQuestions = [
        QuickQuestion(icon: "pill.fill", text: "¿Efectos secundarios de Prednisona?"),
        QuickQuestion(icon: "fork.knife", text: "Como puedo hacer que mi hijo coma más?"),
        QuickQuestion(icon: "heart.fill", text: "¿Cómo manejar las náuseas?"),
        QuickQuestion(icon: "exclamationmark.triangle.fill", text: "¿Cuándo llamar al doctor?")
    ]

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

                        // Live streaming bubble
                        if isStreaming {
                            MessageBubble(message: Message(
                                text: streamingText.isEmpty ? "..." : streamingText,
                                sender: .ai,
                                timestamp: Date()
                            ))
                            .id("streaming")
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
                .onChange(of: streamingText) { _ in
                    withAnimation { proxy.scrollTo("streaming", anchor: .bottom) }
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
            service.startSession()
        }
    }
}

// --- SUBVISTAS ---

extension AIChatView {

    private var headerView: some View {
        HStack(spacing: 15) {
            Circle()
                .fill(LinearGradient(
                    colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
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
                ForEach(quickQuestions) { q in
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
                        endPoint: .trailing
                    ))
                    .clipShape(Circle())
            }
            // Disabled while streaming so user can't double-send
            .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty || isStreaming)
        }
        .padding()
        .background(Color.white)
    }

    // --- LÓGICA ---

    func handleSendMessage(text: String? = nil) {
        let messageText = text ?? inputText
        guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        messages.append(Message(text: messageText, sender: .user, timestamp: Date()))
        inputText = ""
        isStreaming = true
        streamingText = ""

        Task {
            do {
                for try await partial in service.streamResponse(to: messageText) {
                    streamingText = partial
                }
                // Stream finished — commit to message list
                messages.append(Message(text: streamingText, sender: .ai, timestamp: Date()))
            } catch {
                messages.append(Message(
                    text: "Lo siento, ocurrió un error. Por favor intenta de nuevo.",
                    sender: .ai,
                    timestamp: Date()
                ))
            }
            isStreaming = false
            streamingText = ""
        }
    }
}

// --- VISTAS DE APOYO ---

struct TypingIndicator: View {
    var body: some View {
        HStack {
            Image(systemName: "sparkles").foregroundColor(Color(hex: "7BC67E"))
            Text("Escribiendo...")
                .font(.caption)
                .italic()
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct AIChatView_Previews: PreviewProvider {
    static var previews: some View {
        AIChatView()
    }
}
