//
//  StrongApp.swift
//  Strong
//
//  Created by Calwin QuickRide on 06/11/25.
//

import SwiftUI
import SwiftData

@main
struct StrongApp: App {
    var body: some Scene {
        WindowGroup {
            StrongRootView()
        }
        .modelContainer(for: [Exercise.self, WorkoutTemplate.self, TemplateItem.self])
    }
}
