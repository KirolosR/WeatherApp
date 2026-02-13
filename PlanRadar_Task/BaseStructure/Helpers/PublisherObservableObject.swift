//
//  publichedObservalObject.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 23/10/2025.
//

import SwiftUI
import Combine

public final class PublisherObservableObject: ObservableObject {
    
    var subscriber: AnyCancellable?
    
    public init(publisher: AnyPublisher<Void, Never>) {
        subscriber = publisher
            .sink(receiveValue: { _ in
                // Send the objectWillChange notification after the view update has happened.
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            })
    }
}
