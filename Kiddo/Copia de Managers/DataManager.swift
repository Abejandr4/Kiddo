import Foundation
import SwiftData
import Combine

@MainActor
final class DataManager: ObservableObject {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - CRUD

    func addEntry(fatigue: Int, pain: Int, wellbeing: Wellbeing, at date: Date = .now) throws {
        let entry = DiaryEntry(fatigueLevel: fatigue, painLevel: pain, wellbeing: wellbeing, timestamp: date)
        modelContext.insert(entry)
        try modelContext.save()
    }

    func fetchAll() throws -> [DiaryEntry] {
        let descriptor = FetchDescriptor<DiaryEntry>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func fetchRecent(limit: Int = 30) throws -> [DiaryEntry] {
        var descriptor = FetchDescriptor<DiaryEntry>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return try modelContext.fetch(descriptor)
    }

    func delete(_ entry: DiaryEntry) throws {
        modelContext.delete(entry)
        try modelContext.save()
    }

    // MARK: - Helpers para ML

    /// Devuelve entradas agrupadas por hora del día (0–23)
    func entriesGroupedByHour() throws -> [Int: [DiaryEntry]] {
        let all = try fetchAll()
        return Dictionary(grouping: all) { entry in
            Calendar.current.component(.hour, from: entry.timestamp)
        }
    }

    /// Promedio de fatiga y dolor por hora (útil como fallback antes de tener modelo ML)
    func averagesByHour() throws -> [Int: (fatigue: Double, pain: Double, wellbeing: Double)] {
        let grouped = try entriesGroupedByHour()
        return grouped.mapValues { entries in
            let fatigue   = entries.map { Double($0.fatigueLevel) }.reduce(0, +) / Double(entries.count)
            let pain      = entries.map { Double($0.painLevel) }.reduce(0, +) / Double(entries.count)
            let wellbeing = entries.map { $0.wellbeingScore }.reduce(0, +) / Double(entries.count)
            return (fatigue, pain, wellbeing)
        }
    }

    /// ¿Hay suficientes datos para entrenar el modelo? (mínimo recomendado: 20)
    func hasEnoughDataForTraining(minimumEntries: Int = 20) throws -> Bool {
        let count = try modelContext.fetchCount(FetchDescriptor<DiaryEntry>())
        return count >= minimumEntries
    }
}
