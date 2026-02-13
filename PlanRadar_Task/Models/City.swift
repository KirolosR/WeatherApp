//
//  Cities.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import Foundation
import SwiftData

@Model
class City: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String = ""
    var weather: [Weather] = []
    // Custom initializer for normal usage
    init(id: UUID = UUID(), name: String , weather: [Weather]) {
        self.id = id
        self.name = name
        self.weather = weather
    }


}
