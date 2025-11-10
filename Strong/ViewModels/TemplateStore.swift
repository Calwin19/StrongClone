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
    
    private let context: ModelContext
    
    init(context: ModelContext){
        self.context = context
        Task { await refresh() }
    }
    
    func refresh() async {
        let descriptor = FetchDescriptor<WorkoutTemplate>(sortBy: [SortDescriptor(\.name, order: .forward)])
        do { templates = try context.fetch(descriptor) } catch { print("Fetch templates error: \(error)") }
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

    func deleteTemplate(at indexSet: IndexSet){
        for idx in indexSet{ context.delete(templates[idx])}
        try? context.save()
        Task { await refresh()}
    }
    
    func removeItem(in template: WorkoutTemplate, at indexSet: IndexSet){
        for index in indexSet { template.items.remove(at: index)}
        try? context.save()
        Task { await refresh()}
    }
    
    func moveItem(in template: WorkoutTemplate, from source: IndexSet, to destination: Int) {
        template.items.move(fromOffsets: source, toOffset: destination)
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
