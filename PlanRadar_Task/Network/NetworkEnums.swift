//
//  NetworkEnums.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import Foundation

public enum AppEnvironment: String,  CaseIterable {
    case development = "Development"
    case staging = "Staging"
    case preproduction = "Preproduction"
    case production = "Production"
}

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

public enum NetworkError: Error, Equatable {
    case nonHTTPResponse
    case noData
    case fileNotFound
    case incorrectStatusCode(_ statusCode : Int)
    case badURL(_ error: String)
    case apiError(code: Int, error: String)
    case invalidJSON(_ error: String)
    case unauthorized(code: Int, error: String)
    case badRequest(code: Int, error: String)
    case serverError(code: Int, error: String)
    case noResponse(_ error: String)
    case decodingError(_ error: String)
    case unknown(code: Int, error: String)
    case tooManyRequests(code: Int, error: String)
}

public enum HTTPStatusCode: Int {
    case information
    case success
    case redirection
    case clientError
    case serverError
    case unknown
    
    public init?(rawValue: Int) {
        switch rawValue {
        case 100..<200:
            self = .information
        case 200..<300:
            self = .success
        case 300..<400:
            self = .redirection
        case 400..<500:
            self = .clientError
        case 500..<600:
            self = .serverError
        default:
            self = .unknown
        }
    }
}

public enum MultipartFormDataValue {
    case data(Data, fileName: String, mimeType: String)
    case text(Any)
}
