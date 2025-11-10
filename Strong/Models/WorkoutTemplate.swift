//
//  WorkoutTemplate.swift
//  Strong
//
//  Created by Calwin QuickRide on 07/11/25.
//

import Foundation
import SwiftData

@Model
final class WorkoutTemplate {
    @Attribute(.unique) var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade) var items: [TemplateItem]
    
    init(id: UUID = UUID(), name: String, items: [TemplateItem] = []){
        self.id = id
        self.name = name
        self.items = items
    }
}
