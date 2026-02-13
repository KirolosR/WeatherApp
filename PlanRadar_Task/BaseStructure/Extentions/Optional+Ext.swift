//
//  Optional+Ext.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import Foundation
public protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}

public extension Optional where Wrapped: Collection {
    var isEmptyOrNil: Bool { self?.isEmpty ?? true }
}
