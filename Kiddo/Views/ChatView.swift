import SwiftUI

// --- MODELOS ---
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

// --- VISTA PRINCIPAL ---
struct AIChatView: View {
    @State private var messages: [Message] = [
        Message(text: "¡Hola! Soy tu asistente virtual de salud. Estoy aquí para ayudarte con dudas sobre medicamentos, nutrición, cuidados y efectos secundarios durante el tratamiento de leucemia. ¿En qué puedo ayudarte hoy?",
                sender: .ai,
                timestamp: Date())
    ]
    @State private var inputText: String = ""
    @State private var isTyping: Bool = false
    
    // Preguntas rápidas usando el componente ActionButton
    let quickQuestions = [
        QuickQuestion(icon: "pill.fill", text: "¿Efectos secundarios de Prednisona?"),
        QuickQuestion(icon: "fork.knife", text: "Alimentos recomendados"),
        QuickQuestion(icon: "heart.fill", text: "¿Cómo manejar las náuseas?"),
        QuickQuestion(icon: "exclamationmark.triangle.fill", text: "¿Cuándo llamar al doctor?")
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Disclaimer
            disclaimerView
            
            // Chat Messages
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
            
            // Quick Questions (Solo si hay pocos mensajes)
            if messages.count <= 2 {
                quickQuestionsSection
            }
            
            // Input Area
            inputArea
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
    }
}

// --- SUBVISTAS COMPONENTES ---

extension AIChatView {
    
    private var headerView: some View {
        HStack(spacing: 15) {
            Circle()
                .fill(LinearGradient(colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 45, height: 45)
                .overlay(Image(systemName: "bubble.left.and.bubble.right.fill").foregroundColor(.white))
            
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
                    // Integrando tu componente ActionButton (ajustado para SwiftUI nativo)
                    ActionButton(q.text) {
                        handleSendMessage(text: q.text)
                    }
                    .scaleEffect(0.7) // Ajuste de escala para que quepan como sugerencias
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
                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color(hex: "E2E8F0"), lineWidth: 1))
            
            Button(action: { handleSendMessage() }) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(12)
                    .background(LinearGradient(colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")], startPoint: .leading, endPoint: .trailing))
                    .clipShape(Circle())
            }
            .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding()
        .background(Color.white)
    }
    
    // --- LÓGICA ---
    
    func handleSendMessage(text: String? = nil) {
        let messageText = text ?? inputText
        guard !messageText.isEmpty else { return }
        
        let userMsg = Message(text: messageText, sender: .user, timestamp: Date())
        messages.append(userMsg)
        inputText = ""
        isTyping = true
        
        // Simular IA
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let aiResponse = getAIResponse(for: messageText)
            messages.append(Message(text: aiResponse, sender: .ai, timestamp: Date()))
            isTyping = false
        }
    }
    
    func getAIResponse(for text: String) -> String {
        let msg = text.lowercased()
        if msg.contains("prednisona") { return "La Prednisona es un corticosteroide común. Efectos: cambios de humor, hambre y retención de líquidos." }
        if msg.contains("náuseas") || msg.contains("nauseas") { return "El Ondansetrón ayuda mucho. Intenta comer porciones pequeñas y frías." }
        return "Entiendo. Puedo ayudarte con dudas sobre medicamentos, nutrición y signos de alerta. ¿Deseas más detalle?"
    }
}

// --- VISTAS DE APOYO ---

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

// --- PREVIEW ---
struct AIChatView_Previews: PreviewProvider {
    static var previews: some View {
        AIChatView()
    }
}
