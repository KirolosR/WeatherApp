//
//  NetworkHelper.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import Foundation
import SwiftUICore

protocol NetworkHelper: InternetConnectionChecker {
    func failHandler(_ error: Error) -> ViewState
}

extension NetworkHelper {
    func failHandler(_ error: Error) -> ViewState {
        
        guard let error = error as? NetworkError else {
            return .unexpected(description: "UnExpected")
        }
        
        switch error {
            case .nonHTTPResponse,
                    .incorrectStatusCode(_),
                    .badURL(_),
                    .apiError(_,_),
                    .badRequest(_,_),
                    .serverError(_,_),
                    .noResponse(_):
                return .serverError(description: "Server Error")
            case .noData:
                return.noData(description: "No Data")
            case .invalidJSON(_),
                    .decodingError(_),
                    .unknown(_,_),
                    .fileNotFound:
                return .unexpected(description: "UnExpected")
            case .unauthorized(_,_):
                //Should be Custom error
                return .custom(
                    icon: Image("server"),
                    title: "unauthorized",
                    description: "unauthorized",
                    infoErrorMessage: nil,
                    retryable: false
                )
            case .tooManyRequests(code: let code, error: let error):
                return .custom(
                    icon: Image("server"),
                    title: "Error: \(code)",
                    description: error.localizedStringKey,
                    infoErrorMessage: nil,
                    retryable: false
                )
        }
    }
}
