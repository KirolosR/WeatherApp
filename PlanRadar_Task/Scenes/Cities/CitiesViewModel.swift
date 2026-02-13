//
//  CitiesViewModel.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 23/10/2025.
//

import SwiftUI
import Combine
import SwiftData

final class CitiesViewModel: BaseViewModel<CitiesViewModel.State, CitiesViewModel.Action>, NetworkHelper{

    struct State {
        // Variables
        
        var city: City?
        var showDetailsSheet = false
        var showCitySearchSheet = false
        //viewModels
        var historicalWeatherViewModel: HistoricalWeatherViewModel?
        var citySearchViewModel: CitySearchViewModel?
        var weatherDetailsViewModel: WeatherDetailsViewModel?
    }
    
    enum Action {
      case showWeatherDetails
    }
    
    init() {
        super.init(state: .init())
    }
    
    override func trigger(_ action: Action) {
        switch action {
        case .showWeatherDetails:
            state.showDetailsSheet = true
        default: break
         }
    }
    
    

}
