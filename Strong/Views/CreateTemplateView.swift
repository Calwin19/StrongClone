//
//  CreateTemplateView.swift
//  Strong
//
//  Created by Calwin QuickRide on 07/11/25.
//

import SwiftUI

struct CreateTemplateView: View {
    var allExercises: [Exercise]
    var onSave: (_ name: String, _ staged: [StagedItem]) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = "Upper A"
    @State private var staged: [StagedItem] = []
    @State private var selectedExerciseId: UUID?
    @State private var targetSets = 3
    @State private var targetReps = "8-12"
    @State private var notes: String = ""
    var body: some View {
        Form{
            Section("Template name"){
                TextField("Template name", text: $name)
            }
            Section("Add exercise"){
                Picker("Exercise", selection: $selectedExerciseId){
                    Text("Select").tag(Optional<UUID>.none)
                    ForEach(allExercises){ ex in Text(ex.name).tag(Optional(ex.id))}
                }
                Stepper("Target sets: \(targetSets)", value: $targetSets, in: 1...10)
                TextField("Target reps (free text)", text: $targetReps)
                TextField("Notes (optional)", text: $notes)
                Button("Add to template") { addStaged() }.disabled(selectedExerciseId == nil)
            }
            if !staged.isEmpty {
                Section("Items in template") {
                    ForEach(staged) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.exerciseName).font(.headline)
                                Text("\(item.targetSets)x \(item.targetReps)").font(.subheadline).foregroundStyle(.secondary)
                                if !item.notes.isEmpty { Text(item.notes).font(.footnote).foregroundStyle(.secondary) }
                            }
                            Spacer()
                        }
                    }
                    .onDelete { staged.remove(atOffsets: $0) }
                    .onMove { staged.move(fromOffsets: $0, toOffset: $1) }
                }
            }
        }
        .navigationTitle("New Template")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { Button("Cancel") { dismiss() } }
            ToolbarItem(placement: .topBarLeading) { EditButton() }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    onSave(name, staged)
                    dismiss()
                }
                .bold()
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || staged.isEmpty)
            }
        }
    }
    private func addStaged() {
        guard let id = selectedExerciseId, let ex = allExercises.first(where: { $0.id == id }) else { return }
        staged.append(StagedItem(exerciseID: id, exerciseName: ex.name, targetSets: targetSets, targetReps: targetReps, notes: notes))
        selectedExerciseId = nil
        notes = ""
    }
}

