//
//  TemplatesListView.swift
//  Strong
//
//  Created by Calwin QuickRide on 07/11/25.
//

import SwiftUI
import SwiftData

struct TemplatesListView: View {
    @StateObject private var store: TemplateStore
    @Query(sort: \Exercise.name) private var exercises: [Exercise]
    @State private var showingCreate = false
    
    init(context: ModelContext) {
    _store = StateObject(wrappedValue: TemplateStore(context: context))
    }
    
    var body: some View {
        List {
            ForEach(store.templates) { template in
                NavigationLink(value: template.id) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(template.name).font(.headline)
                        Text(summary(template)).font(.subheadline).foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete(perform: store.deleteTemplate)
        }
        .navigationTitle("Templates")
        .toolbar { Button("", systemImage: "plus") { showingCreate = true } }
        .sheet(isPresented: $showingCreate) {
            NavigationStack {
                CreateTemplateView(allExercises: exercises) { name, staged in
                    store.addTemplate(name: name, stagedItems: staged)
                }
            }
        }
        .task { store.seedIfNeeded(using: exercises) }
        .navigationDestination(for: UUID.self) { id in
            if let t = store.templates.first(where: { $0.id == id }) {
                TemplateDetailView(template: t, store: store)
            } else {
                Text("Template not found")
            }
        }
    }
    
    private func summary(_ t: WorkoutTemplate) -> String {
        if t.items.isEmpty { return "No items yet" }
        return t.items.map { "\($0.exercise.name) \($0.targetSets)x \($0.targetReps)" }.joined(separator: " • ")
    }
}

//#Preview {
//    TemplatesListView()
//}
