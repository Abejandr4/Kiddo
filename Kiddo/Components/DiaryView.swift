import SwiftUI
import SwiftData
import Foundation

enum Mood: String, CaseIterable {
    case great, good, neutral, bad, terrible
    
    var imageName: String {
        switch self {
        case .great: return "Muy_bien"
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
    @EnvironmentObject var dataManager: DataManager
    
    // --- NUEVO: Leemos el avatar guardado ---
    @AppStorage("avatarCapa") private var avatarCapa: String = ""
    @AppStorage("avatarAccesorio") private var avatarAccesorio: String = ""
    
    var currentAvatar: Avatar {
        Avatar(
            capa: avatarCapa.isEmpty ? nil : avatarCapa,
            cuerpo: "kiddo_principal",
            accesorio: avatarAccesorio.isEmpty ? nil : avatarAccesorio
        )
    }
    // ----------------------------------------

    @State private var entries: [DiaryEntryy] = [
        DiaryEntryy(date: Date(), mood: .great, energyLevel: 8, painLevel: 2, sideEffects: ["Cansancio leve"], notes: "¡Me sentí muy bien hoy!"),
        DiaryEntryy(date: Date().addingTimeInterval(-86400), mood: .neutral, energyLevel: 5, painLevel: 4, sideEffects: ["Mareos", "Náuseas"], notes: "Día tranquilo.")
    ]
    
    @State private var suggestions: [Suggestion] = []
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
                
                // ── Sección de Tips ──────────────────────────────────────
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        // --- AQUÍ ESTÁ EL CAMBIO: Avatar en lugar de la imagen estática ---
                        AvatarView(avatar: currentAvatar)
                            .scaleEffect(0.28) // (70 / 250 = 0.28) para que encaje
                            .frame(width: 70, height: 70)
                            .background(Circle().fill(Color.white.opacity(0.6)))
                            .clipShape(Circle())
                        
                        Text("Tips de Héroe")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        if suggestions.isEmpty {
                            // Placeholder mientras cargan o no hay entradas aún
                            HeroTipCard(
                                emoji: "⭐️",
                                title: "¡Registra tu primera batalla!",
                                description: "Agrega entradas al diario para recibir tips personalizados según cómo te sientes.",
                                timeText: "Cuando quieras"
                            )
                        } else {
                            // Tips generados por el modelo
                            ForEach(suggestions) { suggestion in
                                HeroTipCard(
                                    emoji: suggestion.emoji,
                                    title: suggestion.title,
                                    description: suggestion.detail,
                                    timeText: suggestion.urgencyLabel
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)
                // ─────────────────────────────────────────────────────────
                
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
        .task {
            await loadSuggestions()
        }
        .sheet(isPresented: $showNewEntrySheet) {
            NavigationStack {
                NewEntryForm(onSave: saveEntry, onCancel: { showNewEntrySheet = false })
            }
        }
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
    
    // MARK: - Cargar sugerencias del modelo
    
    private func loadSuggestions() async {
        do {
            let entries = try dataManager.fetchAll()
            guard !entries.isEmpty else { return }

            let insight: DailyInsight

            if PredictionEngine.shared.modelsLoaded {
                insight = try PredictionEngine.shared.generateDailyInsight(recentEntries: entries)
            } else {
                let averages = try dataManager.averagesByHour()
                insight = PredictionEngine.shared.generateHeuristicInsight(averagesByHour: averages)
            }

            guard let context = SuggestionEngine.shared.buildContext(
                recentEntries: entries,
                insight: insight
            ) else { return }

            await MainActor.run {
                suggestions = SuggestionEngine.shared.suggestions(for: context)
            }

        } catch {
            print("Error cargando sugerencias: \(error.localizedDescription)")
        }
    }
    
    private func saveEntry(mood: Mood, energy: Double, pain: Double, notes: String, villains: [String]) {
        let entry = DiaryEntryy(date: Date(), mood: mood, energyLevel: energy, painLevel: pain, sideEffects: villains, notes: notes)
        entries.insert(entry, at: 0)
        showNewEntrySheet = false
        
        let wellbeing: Wellbeing
        switch mood {
        case .great:    wellbeing = .veryGood
        case .good:     wellbeing = .good
        case .neutral:  wellbeing = .neutral
        case .bad:      wellbeing = .bad
        case .terrible: wellbeing = .veryBad
        }

        let fatigue = max(1, min(5, Int((energy / 10.0) * 5)))
        let painML  = max(1, min(5, Int((pain   / 10.0) * 5)))

        try? dataManager.addEntry(fatigue: fatigue, pain: painML, wellbeing: wellbeing)
        
        Task { await loadSuggestions() }
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
                                    Image(m.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                    
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
                Image(entry.mood.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DiaryEntry.self, configurations: config)
    
    DiaryView()
        .environmentObject(DataManager(modelContext: container.mainContext))
        .modelContainer(container)
}
