//
//  Search.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

struct WeatherRequests {
    static var appPath = "/data/2.5/weather/?"
    
    struct WeatherRequest: BaseRequestProtocol {
        
        typealias Response = Weather?
        var searchQ: String
        var host: String {
            return kBaseURL
        }
        var path: String { appPath  }
        var httpMethod: HTTPMethod { .GET }
        var parameters: Parameters? {
            [
                "q": searchQ
            ].compactMapValues({$0})
        }
        var headers: [String : String] {
            [
                "x-api-key": "f5cb0b965ea1564c50c6f1b74534d823"
            ]
        }
        
        var mockResponse: Weather? = .init(weather: [], main: nil, wind: nil, id: 1, date: nil, city: .init(name: "", weather: []))
    }
}
