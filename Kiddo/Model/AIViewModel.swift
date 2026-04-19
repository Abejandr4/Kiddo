import AppIntents

// 1. Define your data so Apple Intelligence can "see" it
struct DiaryEntryEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Diary Entry"
    let id: UUID
    var content: String
    
    static var defaultQuery = DiaryEntryQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(content)")
    }
}

// 2. Create a Query so the system can find the entries
struct DiaryEntryQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [DiaryEntryEntity] {
        // Fetch your real data here
        return []
    }
}
