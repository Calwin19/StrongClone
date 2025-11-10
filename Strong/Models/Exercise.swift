//
//  Exercise.swift
//  Strong
//
//  Created by Calwin QuickRide on 06/11/25.
//

import Foundation
import SwiftData

@Model
final class Exercise {
    @Attribute(.unique) var id: UUID
    var name: String
    var primaryMuscle: String
    var equipment: String?
    var isBodyweight: Bool
    var notes: String?
    
    init(id: UUID = UUID(), name: String, primaryMuscle: String, equipment: String? = nil, isBodyweight: Bool = false, notes: String? = nil) {
        self.id = id
        self.name = name
        self.primaryMuscle = primaryMuscle
        self.equipment = equipment
        self.isBodyweight = isBodyweight
        self.notes = notes
    }
}
