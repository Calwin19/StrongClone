//
//  TemplateDetailView.swift
//  Strong
//
//  Created by Calwin QuickRide on 07/11/25.
//

import SwiftUI

struct TemplateDetailView: View {
    let template: WorkoutTemplate
    @ObservedObject var store: TemplateStore
    
    
    var body: some View {
        List {
            if template.items.isEmpty {
                Text("No items yet. Use the + button from the list to add.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(template.items) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.exercise.name).font(.headline)
                        Text("\(item.targetSets)x \(item.targetReps)")
                            .font(.subheadline).foregroundStyle(.secondary)
                        if let n = item.notes, !n.isEmpty { Text(n).font(.footnote).foregroundStyle(.secondary) }
                    }
                }
                .onDelete { store.removeItem(in: template, at: $0) }
                .onMove { store.moveItem(in: template, from: $0, to: $1) }
            }
        }
        .navigationTitle(template.name)
        .toolbar { EditButton() }
    }
}
