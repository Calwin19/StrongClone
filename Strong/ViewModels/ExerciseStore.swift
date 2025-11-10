//
//  ExerciseStore.swift
//  Strong
//
//  Created by Calwin QuickRide on 07/11/25.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class ExerciseStore: ObservableObject {
    @Published private(set) var exercises: [Exercise] = []
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        Task {await refresh()}
    }
    
    func refresh() async {
        let descriptor = FetchDescriptor<Exercise>(sortBy: [SortDescriptor(\.name, order: .forward)])
        do {
            exercises = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch exercises: \(error)")
        }
    }
    
    func add(name: String, primaryMuscle: String, equipment: String?, isBodyWeight: Bool, notes: String?){
        let ex = Exercise(name: name, primaryMuscle: primaryMuscle, equipment: equipment?.nilIfBlank(), isBodyweight: isBodyWeight, notes: notes?.nilIfBlank())
        context.insert(ex)
        try? context.save()
        Task {await refresh()}
    }
    
    func delete( _ indexSet: IndexSet){
        for index in indexSet{ context.delete(exercises[index])}
        try? context.save()
        Task {await refresh()}
    }
    
    func seedIfNeeded() {
        if exercises.isEmpty {
            let starter = [
                Exercise(name: "Barbell Back Squat", primaryMuscle: "Quads", equipment: "Barbell"),
                Exercise(name: "Barbell Bench Press", primaryMuscle: "Chest", equipment: "Barbell"),
                Exercise(name: "Conventional Deadlift", primaryMuscle: "Back", equipment: "Barbell"),
                Exercise(name: "Overhead Press", primaryMuscle: "Shoulders", equipment: "Barbell"),
                Exercise(name: "Pull-Up", primaryMuscle: "Back", isBodyweight: true)
            ]
            starter.forEach{context.insert($0)}
            try? context.save()
            Task {await refresh()}
        }
    }
}

private extension String { func nilIfBlank() -> String? { let t = trimmingCharacters(in: .whitespacesAndNewlines); return t.isEmpty ? nil : t } }
