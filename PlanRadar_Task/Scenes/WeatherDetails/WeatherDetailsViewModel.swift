//
//  WeatherDetailsViewModel.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import SwiftUI
import Combine
import SwiftData

final class WeatherDetailsViewModel: BaseViewModel<WeatherDetailsViewModel.State, WeatherDetailsViewModel.Action>, NetworkHelper{

    struct State {
        // Variables
        var city : City?
        var searchQuery: String = ""
        var WeatherResponse: Weather?
        var responseRecived: Bool = false
        var viewState: ViewState = .loaded
        var weatherIconName: String?
        var requestime : String = "22/10/2025 12:00"
        //viewModels
    }
    
    enum Action {
        case searchQueryChanged
        case WeatherResponse(Result<Weather?, NetworkError>)
       // case saveToCoreData
    }
    
    init(city: City) {
        super.init(state: .init())
        self.state.searchQuery = city.name
        debugPrint(self.state.searchQuery)
        trigger(.searchQueryChanged)
    }
    
    override func trigger(_ action: Action) {
        switch action {
            case .searchQueryChanged:
                 Task {
                     await trigger(.WeatherResponse(WeatherService.getWeatherData(state.searchQuery)))
                 }
             case let .WeatherResponse(.success(response)):
            print("success \(response ?? .init(weather: [], city: state.city ?? .init(name: "", weather: [])) )")
                 state.WeatherResponse = response
                 state.weatherIconName = response?.weather?.first?.icon
                 saveReqDate()
                 state.responseRecived = true
             case let .WeatherResponse(.failure(error)):
                 print("failure \(error)")
            default: break
            }
        }
    
      func convertTemp(temp: Double) -> String {
        let celsius = Int(temp - 273)
        return "\(celsius)°C"
     }
    
     func getWeatherIconUrl(name: String) -> URL {
        return URL(string: "\(KImageBaseURL)\(name).png")!
    }
    
    func saveReqDate() {
        let now = Date()
        print("🌐 Request started at: \(now.formatted(date: .abbreviated, time: .standard))")
 
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        print("📅 Request started at: \(timestamp)")
        
        state.requestime = timestamp
    }
}
