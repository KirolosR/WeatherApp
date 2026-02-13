//
//  Prefrences.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 23/10/2025.
//

import SwiftUI
import Combine

@propertyWrapper
struct Preference<Value>: DynamicProperty {
    
    @ObservedObject var preferencesObserver: PublisherObservableObject
    let keyPath: ReferenceWritableKeyPath<Preferences, Value>
    let preferences: Preferences = .shared
    
    init(
        _ keyPath: ReferenceWritableKeyPath<Preferences, Value>
    ) {
        self.keyPath = keyPath
        let publisher = preferences
            .preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == keyPath
            }
            .mapToVoid()
            .eraseToAnyPublisher()
        self.preferencesObserver = .init(publisher: publisher)
    }
    
    var wrappedValue: Value {
        get {
            preferences[keyPath: keyPath]
        }
        nonmutating set {
            preferences[keyPath: keyPath] = newValue
            preferences.preferencesChangedSubject.send(keyPath)
        }
    }
    
    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

final class Preferences {
    
    static let shared = Preferences()
    private init() {}
    
    /// Sends through the changed key path whenever a change occurs.
    var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()
    
    var cityEntityUpdate: Bool = false
    
}
