//
//  ViewState.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import SwiftUI

public enum ViewState {
    case loaded
    case loading
    case infoError(description: LocalizedStringKey , isForgetPass: Bool , forgetAction: (() -> ())?)
    case noData(description: LocalizedStringKey)
    case offline(description: LocalizedStringKey)
    case serverError(description: LocalizedStringKey)
    case unexpected(description: LocalizedStringKey)
    case custom(
        icon: Image,
        title: LocalizedStringKey,
        description: LocalizedStringKey,
        infoErrorMessage: String?,
        retryable: Bool
    )
    case inViewError(icon: Image, title: LocalizedStringKey, description: LocalizedStringKey, retryable: (() -> Void)?)
}
