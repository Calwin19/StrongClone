//
//  ExerciseFormView.swift
//  Strong
//
//  Created by Calwin QuickRide on 07/11/25.
//

import SwiftUI

struct ExerciseFormView: View {
    var onSave: (_ name: String, _ muscle: String, _ equipment: String?, _ isBW: Bool, _ notes: String?) -> Void
    @Environment(\.dismiss) private var dismiss


    @State private var name = "Barbell Row"
    @State private var muscle = "Back"
    @State private var equipment: String = "Barbell"
    @State private var isBW = false
    @State private var notes: String = ""
    
    var body: some View {
        Form{
            TextField("Name", text: $name)
            TextField("Primary muscle", text: $muscle)
            TextField("Equipment (optional)", text: $equipment)
            Toggle("Bodyweight", isOn: $isBW)
            TextField("Notes (optional)", text: $notes)
        }
        .navigationTitle("New Exercise")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { Button("Cancel") { dismiss() } }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    onSave(name, muscle, equipment, isBW, notes)
                    dismiss()
                }
                .bold()
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
}

//#Preview {
//    ExerciseFormView()
//}
