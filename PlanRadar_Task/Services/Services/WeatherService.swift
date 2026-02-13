//
//  SearchService.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

struct WeatherService {
    
    static func getWeatherData(_ searchQuery: String) async -> Result<Weather?, NetworkError> {
        await APIFetcher.shared.fetch(request: WeatherRequests.WeatherRequest( searchQ: searchQuery))
    }
    
    
}
