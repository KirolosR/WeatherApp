//
//  BaseViewModel.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import SwiftUI
import Combine

@MainActor
protocol BaseViewModelProtocol: ObservableObject, CancelableStore where ObjectWillChangePublisher.Output == Void {
    
    associatedtype State
    associatedtype Action
    
    var state: State { get set }
    func trigger(_ action: Action) async
}

@MainActor
class BaseViewModel<State, Action>: NSObject, BaseViewModelProtocol {
    @Published var state: State
    var bindings: [AnyCancellable] { [] }
    
    init(
        state: State
    ) {
        self.state = state
        super.init()
        bind()
    }
    
    final func bind() {
        bindings.forEach { $0.store(in: &cancelables) }
    }
    
    func trigger(
        _ action: Action
    ) {
        fatalError("Override!")
    }
}

extension BaseViewModel: Identifiable  {
    var id: UUID {
        UUID()
    }
}
