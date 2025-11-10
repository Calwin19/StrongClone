//
//  TemplateItem.swift
//  Strong
//
//  Created by Calwin QuickRide on 07/11/25.
//

import Foundation
import SwiftData

@Model
final class TemplateItem {
    @Attribute(.unique) var id: UUID
    var exercise: Exercise
    var targetSets: Int
    var targetReps: String
    var notes: String?
    
    init(id: UUID = UUID(), exercise: Exercise, targetSets: Int, targetReps: String, notes: String? = nil) {
        self.id = id
        self.exercise = exercise
        self.targetSets = targetSets
        self.targetReps = targetReps
        self.notes = notes
    }
}
