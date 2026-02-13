//
//  Weather.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 21/10/2025.
//

import Foundation
import SwiftData

@Model
class Weather: Identifiable, Codable {
    var weather: [WeatherElement]?
    var main: Main?
    var wind: Wind?
    var id: Int?
    var date: String?
    var city: City?

    init(weather: [WeatherElement]? = nil,
         main: Main? = nil,
         wind: Wind? = nil,
         id: Int? = nil,
         date: String? = nil,
         city: City) {
        self.weather = weather
        self.main = main
        self.wind = wind
        self.id = id
        self.date = date
        self.city = city
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case weather
        case main
        case wind
        case id
        case date = "dt_txt"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.weather = try container.decodeIfPresent([WeatherElement].self, forKey: .weather)
        self.main = try container.decodeIfPresent(Main.self, forKey: .main)
        self.wind = try container.decodeIfPresent(Wind.self, forKey: .wind)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(weather, forKey: .weather)
        try container.encodeIfPresent(main, forKey: .main)
        try container.encodeIfPresent(wind, forKey: .wind)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(date, forKey: .date)
    }
}





// MARK: - Main
struct Main : Codable {
    var temp : Double?
    var  humidity : Int?
  
}



// MARK: - WeatherElement
struct WeatherElement : Codable {
    var description, icon: String?
    
   
}

// MARK: - Wind
struct Wind : Codable {
    var speed: Double?
}


