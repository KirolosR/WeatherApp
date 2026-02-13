//
//  PlanRadar_TaskApp.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 21/10/2025.
//

import SwiftUI
import SwiftData

@main
struct PlanRadar_TaskApp: App {
    var body: some Scene {
        WindowGroup {
            CitiesView(viewModel: .init())
        }
        .modelContainer(for: [City.self , Weather.self])
    }
}
