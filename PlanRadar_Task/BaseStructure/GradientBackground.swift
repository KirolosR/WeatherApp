//
//  GradientBackground.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 07/11/2025.
//

import SwiftUI

struct GradientBackground: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: backgroundColors),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            content
        }
    }

    private var backgroundColors: [Color] {
        if colorScheme == .dark {
            return [Color(hex: "#262627"), Color(hex: "#242325")]
        } else {
            return [Color(hex: "#FFFFFF"), Color(hex: "#D6D3DE")]
        }
    }
}
