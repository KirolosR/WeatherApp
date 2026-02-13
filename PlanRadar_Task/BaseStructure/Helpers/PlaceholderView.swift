//
//  PlacholderView.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import SwiftUI

public struct Placeholder: View {
    
    private let radius: CGFloat
    
    public init(
        radius: CGFloat = 8
    ) {
        self.radius = radius
    }
    
    public var body: some View {
        Rectangle()
            .cornerRadius(radius)
    }
}
