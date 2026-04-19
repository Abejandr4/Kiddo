import SwiftUI
import Foundation

enum Mood: String, CaseIterable {
    case great, good, neutral, bad, terrible
    
    var emoji: String {
        switch self {
        case .great: return "😄"
        case .good: return "🙂"
        case .neutral: return "😐"
        case .bad: return "😟"
        case .terrible: return "😢"
        }
    }
    
    var label: String {
        switch self {
        case .great: return "Excelente"
        case .good: return "Bien"
        case .neutral: return "Normal"
        case .bad: return "Mal"
        case .terrible: return "Muy mal"
        }
    }
}

struct DiaryEntryy: Identifiable {
    let id = UUID()
    let date: Date
    let mood: Mood
    let energyLevel: Double
    let painLevel: Double
    let sideEffects: [String]
    let notes: String
}

struct DiaryView: View {
    @State private var entries: [DiaryEntryy] = [
        DiaryEntryy(date: Date(), mood: .great, energyLevel: 8, painLevel: 2, sideEffects: [], notes: "¡Me sentí muy bien hoy!"),
        DiaryEntryy(date: Date().addingTimeInterval(-86400), mood: .neutral, energyLevel: 5, painLevel: 4, sideEffects: ["Cansancio leve"], notes: "Día tranquilo.")
    ]
    
    @State private var showPrivacyNotice = true
    @State private var showNewEntry = false
    
    // Estados para el nuevo registro
    @State private var newMood: Mood = .good
    @State private var newEnergy = 5.0
    @State private var newPain = 2.0
    @State private var newNotes = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color(red: 0.71, green: 0.65, blue: 0.84))
                    Text("Mi Diario")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.18, green: 0.22, blue: 0.28))
                    Spacer()
                }
                .padding(.horizontal)

                // Privacy Notice
                if showPrivacyNotice {
                    PrivacyNoticeView(onClose: { showPrivacyNotice = false })
                }
                
                // Botón Nueva Batalla (Usando tu ActionButton)
                ActionButton("Registro de Batalla",
                             startColor: Color(red: 0.71, green: 0.65, blue: 0.84),
                             endColor: Color(red: 1.0, green: 0.7, blue: 0.4)) {
                    withAnimation(.spring()) {
                        showNewEntry.toggle()
                    }
                }
                .padding(.horizontal)
                
                // Formulario Nueva Entrada
                if showNewEntry {
                    NewEntryForm(
                        mood: $newMood,
                        energy: $newEnergy,
                        pain: $newPain,
                        notes: $newNotes,
                        onSave: saveEntry,
                        onCancel: { showNewEntry = false }
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Historial (Villanos de Hoy)
                VStack(alignment: .leading) {
                    Text("Villanos de Hoy")
                        .font(.headline)
                    Text("Registro de batallas y síntomas")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(red: 0.91, green: 0.96, blue: 0.91))
                .cornerRadius(20)
                .padding(.horizontal)
                
                // Lista de Entradas
                ForEach(entries) { entry in
                    DiaryEntryyCard(entry: entry)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
    }
    
    private func saveEntry() {
        let entry = DiaryEntryy(date: Date(), mood: newMood, energyLevel: newEnergy, painLevel: newPain, sideEffects: [], notes: newNotes)
        withAnimation {
            entries.insert(entry, at: 0)
            showNewEntry = false
            // Resetear campos
            newNotes = ""
        }
    }
}

// MARK: - Subcomponentes

struct PrivacyNoticeView: View {
    var onClose: () -> Void
    var body: some View {
        HStack(spacing: 15) {
            Text("🔒")
                .font(.system(size: 40))
            VStack(alignment: .leading, spacing: 4) {
                Text("Tu espacio privado")
                    .font(.headline)
                Text("Solo tú puedes ver lo que escribes aquí.")
                    .font(.caption)
                    .opacity(0.9)
            }
            Spacer()
            Button(action: onClose) {
                Image(systemName: "xmark").padding(5)
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(LinearGradient(colors: [Color.purple.opacity(0.6), Color.green.opacity(0.6)], startPoint: .leading, endPoint: .trailing))
        .cornerRadius(25)
        .padding(.horizontal)
    }
}

struct DiaryEntryyCard: View {
    let entry: DiaryEntryy
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .top) {
                Text(entry.mood.emoji).font(.system(size: 45))
                VStack(alignment: .leading) {
                    Text(entry.date.formatted(date: .complete, time: .omitted))
                        .font(.subheadline).bold()
                    Text(entry.date.formatted(date: .omitted, time: .shortened))
                        .font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                Text(entry.mood.label)
                    .font(.caption2).bold()
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Capsule())
            }
            
            HStack(spacing: 15) {
                LevelIndicator(label: "Energía", value: entry.energyLevel, icon: "battery.100", color: .green)
                LevelIndicator(label: "Dolor", value: entry.painLevel, icon: "heart.fill", color: .red)
            }
            
            if !entry.notes.isEmpty {
                Text(entry.notes)
                    .font(.callout)
                    .padding(.top, 5)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.05), radius: 10)
    }
}

struct LevelIndicator: View {
    let label: String; let value: Double; let icon: String; let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(label).font(.caption).foregroundColor(.secondary)
                Spacer()
                Image(systemName: icon).foregroundColor(color).font(.caption)
            }
            ProgressView(value: value, total: 10)
                .tint(color)
        }
        .padding(10)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

struct NewEntryForm: View {
    @Binding var mood: Mood
    @Binding var energy: Double
    @Binding var pain: Double
    @Binding var notes: String
    var onSave: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("¿Cómo te sientes hoy?").font(.headline)
            
            // Mood Picker
            HStack {
                ForEach(Mood.allCases, id: \.self) { m in
                    Button { mood = m } label: {
                        VStack {
                            Text(m.emoji).font(.system(size: 30))
                            Text(m.label).font(.system(size: 8))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(mood == m ? Color.green.opacity(0.1) : Color.clear)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(mood == m ? Color.green : Color.gray.opacity(0.2)))
                    }
                }
            }
            
            VStack {
                Text("Energía: \(Int(energy))/10").font(.subheadline)
                Slider(value: $energy, in: 1...10, step: 1)
            }
            
            VStack {
                Text("Dolor: \(Int(pain))/10").font(.subheadline)
                Slider(value: $pain, in: 0...10, step: 1)
            }
            
            TextField("Notas adicionales...", text: $notes, axis: .vertical)
                .lineLimit(3...5)
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(15)
            
            HStack {
                Button("Cancelar", action: onCancel)
                    .foregroundColor(.red)
                Spacer()
                Button("Guardar", action: onSave)
                    .bold()
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(25)
        .padding(.horizontal)
    }
}

// MARK: - Preview
struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView()
    }
}
