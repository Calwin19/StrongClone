//
//  ContentView.swift
//  Strong
//
//  Created by Calwin QuickRide on 06/11/25.
//

import SwiftUI

struct StrongRootView: View {
    @Environment(\.modelContext) private var context
    var body: some View {
        TabView {
            NavigationStack { ExerciseListView(context: context) }
                .tabItem { Label("Exercises", systemImage: "dumbbell") }
            NavigationStack { TemplatesListView(context: context) }
                .tabItem { Label("Templates", systemImage: "list.bullet.rectangle") }
        }
    }
}

//#Preview {
//    ContentView()
//}
