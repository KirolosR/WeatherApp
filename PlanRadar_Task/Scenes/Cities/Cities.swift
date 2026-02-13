//
//  Cities.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 21/10/2025.
//

import SwiftUI
import SwiftData

struct CitiesView: View {
    @ObservedObject var viewModel: CitiesViewModel
    @Environment(\.modelContext) private var context
    @Query var cities: [City]
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    VStack {
                        Spacer() // pushes the image to the bottom

                        Image("Bg")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height / 2) // ⬅️ half the screen height
                            .background(Color.black.opacity(0.018))
                            .clipped()
                           
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
                
                VStack(spacing: 20) {
                    // Title + Add button
                    HStack(alignment: .center , spacing: 10 ) {
                     
                       // Spacer()
                        Text("CITIES")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .tracking(2)
                            .offset(x: -60)
                            .foregroundColor(Color("textColor"))
                        
                        
                        ZStack {
                            Image("Button_right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding(.trailing , 0)
                            
                            Image(systemName: "plus")
                                .font(.title3)
                                .foregroundColor(Color("plusColor"))
                                .offset(x: 15 , y: -17)
                        }
                        .onTapGesture {
                            viewModel.state.showCitySearchSheet.toggle()
                        }
                        .offset(y: 15)
                        
                        
                    }
                    .frame(maxWidth: .infinity , alignment: .trailing)
                
                    
                    
                    // List of cities
                    List {
                        ForEach(cities) { city in
                            HStack {
                                Text("\(city.name.uppercased())")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("textColor"))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color("arrowColor"))
                                    .onTapGesture {
                                        viewModel.state.historicalWeatherViewModel = .init(city: city)
                                    }
                            }
                            .padding(.vertical, 8)
                            .onTapGesture {
                                viewModel.state.city = city
                                viewModel.trigger(.showWeatherDetails)
                            }
                        }
                        .onDelete { offsets in
                            for offset in offsets {
                                context.delete(cities[offset])
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    
                }
                .navigationBarHidden(true)
            }
            .gradientBackground()
            .sheet(isPresented: $viewModel.state.showDetailsSheet) {
                WeatherDetailView(viewModel: .init(city: viewModel.state.city ?? .init(name: "", weather: [])))
            }
            .sheet(isPresented: $viewModel.state.showCitySearchSheet) {
                CitySearchView(viewModel: .init())
            }
            .fullScreenCover(item: $viewModel.state.historicalWeatherViewModel) { viewModel in
                HistoricalWeatherView(viewModel: viewModel)
            }
        }

    }
      
    
}

//#Preview {
//    CitiesView(viewModel: .init(), _cities: [])
//}
