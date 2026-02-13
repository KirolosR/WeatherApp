//
//  BaseRequest.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//


import Foundation

public typealias Parameters = [String:Any]

public protocol BaseRequestProtocol {
    //Request
    var host: String { get }
    var headers: [String: String] { get }
    var path: String { get }
    var baseHeaders : [String: String] { get }
    var requestTimeOut: Float { get }
    var httpMethod: HTTPMethod { get }
    var parameters: Parameters? { get }
    var sendAsParameters: Bool { get }
    //Request Response
    associatedtype Response: Codable
    var mockResponse: Response { get set }
    
}

public extension BaseRequestProtocol {
    var host: String {return kBaseURL}
    var headers: [String: String] { return [:] }
    var baseHeaders : [String:String] { return defaultHeaders }
    var requestTimeOut: Float { return 5 }
    var httpMethod: HTTPMethod { return .GET }
    var parameters: Parameters? { return [:] }
    var sendAsParameters: Bool { return false }

}

public extension BaseRequestProtocol {
   
    var requestURL : String {
        return host + path
    }
    
    var defaultHeaders: [String: String] {
        var baseHeaders = [
            KeyParameters.contentTypeKey: KeyParameters.applicationJson,
            KeyParameters.accept: KeyParameters.applicationJson
        ].compactMapValues{$0}
        
        baseHeaders += headers
        return baseHeaders
    }
}

public protocol MultipartRequestProtocol: BaseRequestProtocol {
    var multiPartParam: [String: MultipartFormDataValue] { get }
}
extension MultipartRequestProtocol {
    var multiPartParam: [String: MultipartFormDataValue] { return [:] }
}


