//
//  ExerciseListView.swift
//  Strong
//
//  Created by Calwin QuickRide on 07/11/25.
//

import SwiftUI
import SwiftData

struct ExerciseListView: View {
    
    @StateObject var store: ExerciseStore
    @State private var showingCreate = false
    @State private var search = ""
    
    init(context: ModelContext) {
        _store = StateObject(wrappedValue: ExerciseStore(context: context))
    }
    var body: some View {
        List {
            ForEach(filtered) { ex in
                VStack(alignment: .leading, spacing: 2){
                    Text(ex.name).font(.headline)
                    HStack(spacing: 8){
                        Text(ex.primaryMuscle)
                        if let equipment = ex.equipment { Text(" · \(equipment)")}
                        if ex.isBodyweight { Text(" · Bodyweight") }
                    }
                    .font(.subheadline).foregroundStyle(.secondary)
                }
            }
            .onDelete(perform: store.delete)
        }
        .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle("Exercies")
        .toolbar { Button("", systemImage: "plus") { showingCreate = true } }
        .task { store.seedIfNeeded() }
        .sheet(isPresented: $showingCreate){
            NavigationStack{
                ExerciseFormView { name, muscle, equipment, isBW, notes in
                    store.add(name: name, primaryMuscle: muscle, equipment: equipment, isBodyWeight: isBW, notes: notes)
                }
            }
        }
    }
    private var filtered: [Exercise] {
        guard !search.isEmpty else {return store.exercises}
        let query = search.lowercased()
        return store.exercises.filter{ $0.name.lowercased().contains(query) || $0.primaryMuscle.lowercased().contains(query) || $0.equipment?.lowercased().contains(query) ?? false}
    }
}

//#Preview {
//    ExerciseListView()
//}
