//
//  NetworkConstants.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import Foundation

let kAppEnvironment: AppEnvironment = .production

// MARK: - kBaseURLComponents
var kBaseURLComponents: URLComponents {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.openweathermap.org"
   
    return urlComponents
}


// MARK: - kBaseURL
var kBaseURL: String {
    return kBaseURLComponents.url?.absoluteString ?? ""
}

var KImageBaseURLComponent: URLComponents {
    var urlComponents = URLComponents()
    urlComponents.scheme = "http"
    urlComponents.host = "openweathermap.org/img/w/"
   
    return urlComponents
}

var KImageBaseURL: String {
    return KImageBaseURLComponent.url?.absoluteString ?? ""
}

// MARK: - all requests key parameters
struct KeyParameters {
    static var contentTypeKey = "Content-Type"
    static var accept = "Accept"
    static var applicationJson = "application/json"
    static var acceptLanguage = "Accept-Language"
    static var userAgent = "User-Agent"
}

