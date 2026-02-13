//
//  CitySearchView.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 21/10/2025.
//

import SwiftUI

struct CitySearchView: View {
    @ObservedObject var viewModel: CitySearchViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack(spacing: 12) {
            
            // Title label
            Text("Enter city, postcode or airport location")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 20)
            
            // Search bar
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search", text: $viewModel.state.searchQuery)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.vertical, 8)
                }
                .padding(.horizontal, 10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Button("Cancel") {
                    viewModel.state.citiesViewModel = .init()
                    dismiss()
                }
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            VStack (alignment: .leading) {
                Button {
                    context.insert(City(name: viewModel.state.searchQuery, weather: []))
                }label: {
                    Text(viewModel.state.searchQuery)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(Color("weatherDetails"))
                }
            }
            .padding(.top , 30)
            
            Spacer()
        }
        .gradientBackground()
        
    }
}

#Preview {
    CitySearchView(viewModel: .init())
}
