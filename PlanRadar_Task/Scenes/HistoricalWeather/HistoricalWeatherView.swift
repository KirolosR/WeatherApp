//
//  HistoricalWeatherView.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import SwiftUI
import SwiftData

let cityFilter = #Predicate<Weather> { weather in weather.city?.name == "Cairo"  }

struct HistoricalWeatherView: View {
    @ObservedObject var viewModel: HistoricalWeatherViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query(filter: cityFilter) var weatherArr: [Weather]
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    Spacer() // pushes the image to the bottom

                    Image("Bg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height / 2) // ⬅️ half the screen height
                        .background(Color.black.opacity(0.01))
                        .clipped()
                       
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            
            
            ZStack{
               VStack{
                    VStack(spacing: 30) {
                        
                        // Header
                        HStack {
                            ZStack {
                                // Centered title
                                VStack {
                                    Text(viewModel.state.city?.name ?? "")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .tracking(2)
                                        .foregroundColor(Color("textColor"))
                                    
                                    Text("Historical".uppercased())
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .tracking(2)
                                        .foregroundColor(Color("textColor"))
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                
                                // Left button
                                HStack {
                                    Button(action: { dismiss() }) {
                                        ZStack {
                                            Image("Button_left")
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .offset(y: 20)
                                            
                                            Image(systemName: "arrow.left")
                                                .foregroundColor(Color("plusColor"))
                                                .font(.headline)
                                                .offset(x: -5)
                                        }
                                    }
                                    .frame(width: 60, height: 60)
                                    
                                    Spacer()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                        List {
                            ForEach(weatherArr) { weather in
                                VStack (alignment: .leading) {
                                    Text(weather.date ?? "")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color("textColor"))
                                    
                                    Text("\(weather.weather?.first?.description ?? "") , \(viewModel.convertTemp(temp: weather.main?.temp ?? 100))")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color("weatherDetails"))
                                    
                                }
                                .padding(.vertical, 8)
                            }
                            .onDelete { offsets in
                                for offset in offsets {
                                    context.delete(weatherArr[offset])
                                }
                            }
                            .listRowBackground(Color.clear)
                           
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .listRowBackground(Color.clear)
                        .background(Color.clear)
                        
                    }
                }
            }
        }
        .gradientBackground()
    }
}

//#Preview {
//    HistoricalWeatherView(viewModel: .init(city: City.init(name: "London", weather: [])), weatherArr: [])
//}
