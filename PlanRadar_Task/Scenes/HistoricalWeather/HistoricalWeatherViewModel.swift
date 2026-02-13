//
//  HistoricalWeatherViewModel.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 23/10/2025.
//
import SwiftData
import SwiftUI

final class HistoricalWeatherViewModel: BaseViewModel<HistoricalWeatherViewModel.State, HistoricalWeatherViewModel.Action>, NetworkHelper{

    struct State {
        // Variables

        var city: City?
        var weatherDate : [String] = [ "23/10/2025 12:00"]
        //viewModels
    }
    
    enum Action {
       case fetchWeatherByCity
    }
    
    init(city : City) {
        super.init(state: .init())
        state.city = city
        print(city , state.city)

    }
    
    override func trigger(_ action: Action) {
        switch action {
           
            default: break
            }
        }
    
        func convertTemp(temp: Double) -> String {
          let celsius = Int(temp - 273)
          return "\(celsius)°C"
        }
    }
    
