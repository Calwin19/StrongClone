//
//  TemplateStore.swift
//  Strong
//
//  Created by Calwin QuickRide on 07/11/25.
//

import Foundation
import SwiftData
import Combine
import SwiftUI

@MainActor
final class TemplateStore: ObservableObject {
    @Published private(set) var templates: [WorkoutTemplate] = []
    @Published private(set) var summaries: [UUID: TemplateSummary] = [:]
    private let context: ModelContext
    
    init(context: ModelContext){
        self.context = context
        Task { await refresh() }
    }
    
    func refresh() async {
        let fd = FetchDescriptor<WorkoutTemplate>(sortBy: [SortDescriptor(\.name)])
        do {
            let ts = try context.fetch(fd)
            templates = ts
            summaries = Dictionary(uniqueKeysWithValues: ts.map { t in
                let items = t.items
                let total = items.reduce(0) { $0 + $1.targetSets }
                return (t.id, TemplateSummary(itemCount: items.count, totalSets: total))
            })
        } catch { print("fetch error:", error) }
    }
    
    func addTemplate(name: String, stagedItems: [StagedItem]) {
        let items: [TemplateItem] = stagedItems.compactMap { staged in
            let targetID = staged.exerciseID
            let fd = FetchDescriptor<Exercise>(
                predicate: #Predicate { $0.id == targetID }
            )
            guard let exercise = try? context.fetch(fd).first else { return nil }
            return TemplateItem(exercise: exercise, targetSets: staged.targetSets, targetReps: staged.targetReps, notes: staged.notes.nilIfBlank())
        }

        let t = WorkoutTemplate(name: name, items: items)
        context.insert(t)
        try? context.save()
        Task { await refresh() }
    }

    func removeItem(in t: WorkoutTemplate, at indexSet: IndexSet) {
        for i in indexSet { t.items.remove(at: i) }
        try? context.save()
        let items = t.items
        summaries[t.id] = .init(itemCount: items.count, totalSets: items.reduce(0) { $0 + $1.targetSets })
    }
    func moveItem(in t: WorkoutTemplate, from s: IndexSet, to d: Int) {
        t.items.move(fromOffsets: s, toOffset: d)
        try? context.save()
        let items = t.items
        summaries[t.id] = .init(itemCount: items.count, totalSets: items.reduce(0) { $0 + $1.targetSets })
    }

    func deleteTemplate(at indexSet: IndexSet) {
        for idx in indexSet { context.delete(templates[idx]) }
        try? context.save()
        Task { await refresh() }
    }
    
    func seedIfNeeded(using exercises: [Exercise]) {
        guard templates.isEmpty, exercises.count >= 3 else { return }
        let demo = WorkoutTemplate(name: "Upper A", items: [
        TemplateItem(exercise: exercises[0], targetSets: 3, targetReps: "6–8"),
        TemplateItem(exercise: exercises[1], targetSets: 3, targetReps: "8–12"),
        TemplateItem(exercise: exercises[2], targetSets: 3, targetReps: "10–15")
        ])
        context.insert(demo)
        try? context.save()
        Task { await refresh() }
    }
}

struct StagedItem: Identifiable, Hashable {
    let id = UUID()
    let exerciseID: UUID
    let exerciseName: String
    var targetSets: Int
    var targetReps: String
    var notes: String = ""
}

private extension String { func nilIfBlank() -> String? { let t = trimmingCharacters(in: .whitespacesAndNewlines); return t.isEmpty ? nil : t } }

struct TemplateSummary { let itemCount: Int; let totalSets: Int }
