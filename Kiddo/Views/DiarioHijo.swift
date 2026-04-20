import SwiftUI
import SwiftData

struct DiarioHijo: View {
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        DiaryView()  
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DiaryEntry.self, configurations: config)
    
    DiarioHijo()
        .environmentObject(DataManager(modelContext: container.mainContext))
        .modelContainer(container)
}
