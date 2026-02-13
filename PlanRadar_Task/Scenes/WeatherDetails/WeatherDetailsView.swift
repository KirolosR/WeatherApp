//
//  WeatherDetailsView.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 21/10/2025.
//

import SwiftUI
import Kingfisher

struct WeatherDetailView: View {
    @ObservedObject var viewModel: WeatherDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext)  var context
    
    var body: some View {
        WithViewState($viewModel.state.viewState, isRefreshable: false) {
                ZStack{
                    GeometryReader { geometry in
                        VStack {
                            Spacer() // pushes the image to the bottom

                            Image("Bg")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height / 2) // ⬅️ half the screen height
                                .background(Color.black.opacity(0.05))
                                .clipped()
                               
                        }
                        .edgesIgnoringSafeArea(.bottom)
                    }
                ZStack {
                    VStack(spacing: 30) {
                        
                        // Header
                        HStack {
                            ZStack {
                                // Centered title
                                Text("\(viewModel.state.searchQuery.uppercased())")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .tracking(2)
                                    .foregroundColor(Color("textColor"))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                // Left button
                                HStack {
                                    Button(action: { dismiss() }) {
                                        ZStack {
                                            Image("Button_modal")
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .offset(y: 20)
                                            
                                            Image(systemName: "xmark")
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
                        
                        
                        
                         Spacer()
                            
                        // Weather card
                        VStack(spacing: 20) {
                            KFImage(viewModel.getWeatherIconUrl(name: viewModel.state.weatherIconName ?? ""))
                                .placeholder {
                                    // Placeholder view while loading
                                    Image(systemName: "cloud.sun.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(.gray)
                                        .opacity(0.4)
                                }
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(10)
                                .clipped()
                                .foregroundColor(Color("arrowColor"))
                            
                            VStack(alignment: .leading, spacing: 12) {
                                weatherRow(title: "DESCRIPTION", value: viewModel.state.WeatherResponse?.weather?.first?.description ?? "Sunny")
                                weatherRow(title: "TEMPERATURE", value: viewModel.convertTemp(temp: viewModel.state.WeatherResponse?.main?.temp ?? 50))
                                weatherRow(title: "HUMIDITY", value:"\( viewModel.state.WeatherResponse?.main?.humidity ?? 10)%")
                                weatherRow(title: "WINDSPEED", value: "\(Int(viewModel.state.WeatherResponse?.wind?.speed ?? 10)) km/h")
                            }
                            .padding(.horizontal, 40)
                         //   .padding(.bottom, 20)
                        }
                        .frame(maxWidth: .infinity , maxHeight: 350 )
                        .background(Color.white)
                        .cornerRadius(45)
                        .shadow(color: .gray.opacity(0.9), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 50)
                        Spacer()
                    

                        Spacer()
                        
                        ZStack{
                            Spacer()
                            Text("WEATHER INFORMATION FOR \(viewModel.state.searchQuery.uppercased()) RECEIVED ON\n \(viewModel.state.requestime)")
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color("textColor"))
                                .padding(.horizontal, 20)
                        }
                    }
                    
                }

            }
            .gradientBackground()
        }
        .onChange(of: viewModel.state.responseRecived) {
            if viewModel.state.responseRecived {
                context.insert(viewModel.state.WeatherResponse ?? Weather(weather: [], main: nil, wind: nil, id: nil, date: nil, city: City( name: "", weather: [])))
            }
        }
    }
    
    // MARK: - Row View
    private func weatherRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color("textColor"))
                .tracking(2)
            Spacer()
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color("weatherDetails"))
        }
    }
}

//#Preview {
//    WeatherDetailView(viewModel: .init(cityName: ""))
//}
