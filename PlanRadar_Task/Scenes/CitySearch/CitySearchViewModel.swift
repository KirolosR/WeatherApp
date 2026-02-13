//
//  CitySearchViewModel.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import SwiftUI
import Combine
import SwiftData

final class CitySearchViewModel: BaseViewModel<CitySearchViewModel.State, CitySearchViewModel.Action>, NetworkHelper{

    struct State {
        // Variables
        var searchQuery: String = ""
     //   @Query var cities: [City]
        //viewModels
        var citiesViewModel: CitiesViewModel?
    }
    
    enum Action {
    }
    
    init() {
        super.init(state: .init())
    }
    
    override func trigger(_ action: Action) {
        switch action {
            default: break
            }
        }
    }
    

