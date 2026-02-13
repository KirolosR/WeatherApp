//
//  Publisher+Ext.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 23/10/2025.
//

import Combine

public extension Publisher {
    func mapToVoid() -> Publishers.Map<Self, Void> {
        map { _ in }
    }
}
