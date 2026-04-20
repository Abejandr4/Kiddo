import SwiftUI
import Foundation

// Mantenemos tu Enum y Struct de prueba
enum Mood: String, CaseIterable {
    case great, good, neutral, bad, terrible
    
    // Nueva propiedad para las imágenes de tus Assets
    var imageName: String {
        switch self {
        case .great: return "Muy_bien"       // Reemplaza con tus nombres reales
        case .good: return "Bien"
        case .neutral: return "Meh"
        case .bad: return "Mal"
        case .terrible: return "Muy_mal"
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
        DiaryEntryy(date: Date(), mood: .great, energyLevel: 8, painLevel: 2, sideEffects: ["Cansancio leve"], notes: "¡Me sentí muy bien hoy!"),
        DiaryEntryy(date: Date().addingTimeInterval(-86400), mood: .neutral, energyLevel: 5, painLevel: 4, sideEffects: ["Mareos", "Náuseas"], notes: "Día tranquilo.")
    ]
    
    @State private var showPrivacyNotice = true
    @State private var showNewEntrySheet = false
    @State private var showHistorySheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color(red: 0.71, green: 0.65, blue: 0.84))
                    Text("Mi Diario Secreto")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.18, green: 0.22, blue: 0.28))
                    Spacer()
                }
                .padding(.horizontal)

                if showPrivacyNotice {
                    PrivacyNoticeView(onClose: { showPrivacyNotice = false })
                }
                
                // Sección de Tips Estática
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.orange)
                            .padding(8)
                            .background(Color.orange.opacity(0.2))
                            .clipShape(Circle())
                        Text("Tips de Héroe")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        HeroTipCard(emoji: "🧘‍♂️", title: "Yoga suave", description: "Practica yoga entre 2-3 PM para mantener energía", timeText: "Después de comer")
                        HeroTipCard(emoji: "😴", title: "Siesta reparadora", description: "Una siesta de 20-30 minutos puede ayudar", timeText: "3:00 PM")
                        HeroTipCard(emoji: "🚶‍♂️", title: "Paseo ligero", description: "Caminar 10 minutos al aire libre revitaliza", timeText: "Por la tarde")
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)
                
                // Botones de Acción
                VStack(spacing: 15) {
                    Button(action: { showNewEntrySheet = true }) {
                        Text("Registro de batalla")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [Color(red: 0.71, green: 0.65, blue: 0.84), Color(red: 1.0, green: 0.7, blue: 0.4)], startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(20)
                    }
                    
                    Button(action: { showHistorySheet = true }) {
                            Text("Historial de batallas")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(colors: [Color(red: 0.48, green: 0.78, blue: 0.49), Color(red: 0.53, green: 0.81, blue: 0.92)], startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(20)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
            }
            .padding(.vertical)
        }
        .background(Color(red: 0.96, green: 0.98, blue: 0.96).ignoresSafeArea())
        
        // Modal de Registro de Batalla
        .sheet(isPresented: $showNewEntrySheet) {
            NavigationStack {
                NewEntryForm(onSave: saveEntry, onCancel: { showNewEntrySheet = false })
            }
        }
        // Modal de Historial
        .sheet(isPresented: $showHistorySheet) {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(entries) { entry in
                            DiaryEntryyCard(entry: entry)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Historial de batallas")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(red: 0.96, green: 0.98, blue: 0.96).ignoresSafeArea())
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Cerrar") { showHistorySheet = false }
                    }
                }
            }
        }
    }
    
    private func saveEntry(mood: Mood, energy: Double, pain: Double, notes: String, villains: [String]) {
        let entry = DiaryEntryy(date: Date(), mood: mood, energyLevel: energy, painLevel: pain, sideEffects: villains, notes: notes)
        entries.insert(entry, at: 0)
        showNewEntrySheet = false
    }
}

// MARK: - Subcomponentes

struct HeroTipCard: View {
    let emoji: String
    let title: String
    let description: String
    let timeText: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Text(emoji)
                .font(.largeTitle)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(red: 0.18, green: 0.22, blue: 0.28))
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack {
                    Image(systemName: "clock")
                    Text(timeText)
                }
                .font(.caption)
                .foregroundColor(.green)
                .padding(.top, 2)
            }
            Spacer()
        }
        .padding()
        .background(Color(red: 0.91, green: 0.96, blue: 0.91))
        .cornerRadius(20)
    }
}

struct PrivacyNoticeView: View {
    var onClose: () -> Void
    var body: some View {
        HStack(spacing: 15) {
            Image("Candado")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
            VStack(alignment: .leading, spacing: 4) {
                Text("Tu espacio privado")
                    .font(.headline)
                Text("Solo tú puedes ver lo que escribes aquí. Es tu diario secreto para expresar cómo se siente ser superhéroe.")
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

// MARK: - Formulario de Nueva Entrada
struct NewEntryForm: View {
    @State private var mood: Mood = .good
    @State private var energy: Double = 5.0
    @State private var pain: Double = 2.0
    @State private var notes: String = ""
    @State private var selectedVillains: Set<String> = []
    
    var onSave: (Mood, Double, Double, String, [String]) -> Void
    var onCancel: () -> Void
    
    let availableVillains = [
        "Cansancio leve", "Cansancio moderado",
        "Cansancio extremo", "Náuseas",
        "Dolor de cabeza", "Mareos",
        "Falta de apetito", "Dolor de estómago",
        "Dificultad para dormir", "Irritabilidad",
        "Ninguno"
    ]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Estado de ánimo").font(.headline)
                    HStack {
                        ForEach(Mood.allCases, id: \.self) { m in
                            Button { mood = m } label: {
                                VStack {
                                    // AQUI CAMBIAMOS EL EMOJI POR LA IMAGEN
                                    Image(m.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60) // Ajusta el tamaño según necesites
                                    
                                    Text(m.label).font(.system(size: 10))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(mood == m ? Color(red: 0.71, green: 0.65, blue: 0.84) : Color.clear)
                                .cornerRadius(15)
                                .overlay(RoundedRectangle(cornerRadius: 15).stroke(mood == m ? Color(red: 0.71, green: 0.65, blue: 0.84).opacity(0.2) : Color.gray.opacity(0.2)))
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Nivel de energía: \(Int(energy))/10").font(.headline)
                    HStack {
                        Image(systemName: "battery.25").foregroundColor(.gray)
                        Slider(value: $energy, in: 1...10, step: 1)
                            .tint(.orange)
                        Image(systemName: "bolt.fill").foregroundColor(.orange)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Nivel de dolor: \(Int(pain))/10").font(.headline)
                    HStack {
                        Image(systemName: "heart").foregroundColor(.gray)
                        Slider(value: $pain, in: 0...10, step: 1)
                            .tint(.red)
                        Image(systemName: "heart.slash").foregroundColor(.red)
                    }
                }
                
                // SECCIÓN VILLANOS DE HOY
                VStack(alignment: .leading, spacing: 10) {
                    Text("Villanos de hoy")
                        .font(.headline)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(availableVillains, id: \.self) { villain in
                            let isSelected = selectedVillains.contains(villain)
                            
                            Button(action: {
                                if villain == "Ninguno" {
                                    selectedVillains.removeAll()
                                    selectedVillains.insert("Ninguno")
                                } else {
                                    selectedVillains.remove("Ninguno")
                                    if isSelected {
                                        selectedVillains.remove(villain)
                                    } else {
                                        selectedVillains.insert(villain)
                                    }
                                }
                            }) {
                                Text(villain)
                                    .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                                    .foregroundColor(isSelected ? Color(red: 0.71, green: 0.65, blue: 0.84): .secondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(isSelected ? Color(red: 0.71, green: 0.65, blue: 0.84).opacity(0.15) : Color.clear)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(isSelected ? Color(red: 0.71, green: 0.65, blue: 0.84) : Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Notas adicionales").font(.headline)
                    TextField("¿Qué hiciste hoy? ¿Cómo te sentiste?...", text: $notes, axis: .vertical)
                        .lineLimit(4...6)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.2)))
                }
            }
            .padding()
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
        .navigationTitle("Registro de Batalla")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancelar", action: onCancel)
                    
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Guardar") {
                    onSave(mood, energy, pain, notes, Array(selectedVillains))
                }
                .bold()
            }
        }
    }
}

// MARK: - Tarjeta de Historial
struct DiaryEntryyCard: View {
    let entry: DiaryEntryy
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .top) {
                // AQUI CAMBIAMOS EL EMOJI POR LA IMAGEN PARA EL HISTORIAL
                Image(entry.mood.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75) // Mismo tamaño visual que el emoji anterior
                
                VStack(alignment: .leading) {
                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
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
                LevelIndicator(label: "Energía", value: entry.energyLevel, icon: "bolt.fill", color: .orange)
                LevelIndicator(label: "Dolor", value: entry.painLevel, icon: "heart.slash.fill", color: .red)
            }
            
            // Mostrar Villanos en el historial
            if !entry.sideEffects.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Villanos enfrentados:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ViewThatFits {
                        HStack {
                            ForEach(entry.sideEffects, id: \.self) { villain in
                                VillainTag(text: villain)
                            }
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(entry.sideEffects, id: \.self) { villain in
                                    VillainTag(text: villain)
                                }
                            }
                        }
                    }
                }
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

struct VillainTag: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(red: 0.71, green: 0.65, blue: 0.84).opacity(0.15))
            .foregroundColor(Color(red: 0.71, green: 0.65, blue: 0.84))
            .cornerRadius(10)
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

#Preview {
    DiaryView()
}
