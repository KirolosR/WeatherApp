//
//  PlanRadar_TaskApp.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 21/10/2025.
//

import SwiftUI

@main
struct PlanRadar_TaskApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
