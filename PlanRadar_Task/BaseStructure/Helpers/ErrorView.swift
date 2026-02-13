//
//  ErrorView.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import SwiftUI

struct ErrorView: View {
    var viewBackgroundColor: Color = .white
    var statusImage: Image?
    var statusTitle: LocalizedStringKey?
    var statusDescription: LocalizedStringKey?
    var mainButtonTitle: LocalizedStringKey?
    var mainButtonBackgroundColor: Color = .blue
    var mainButtonAction: (() -> ())? = nil
    
    var secondaryButtonTitle: LocalizedStringKey?
    var secondaryButtonBackgroundColor = Color(.blue)
    var secondaryButtonAction: (() -> ())? = nil

    var infoErrorMessage: String? = nil
    
    var defaultSecondaryButtonWidth = UIScreen.main.bounds.width / 2
    @State private var showPopover: Bool = false
    
    var body: some View {
        ZStack {
            viewBackgroundColor.ignoresSafeArea()
            
            VStack(alignment: .center){
                
                Unwrap(statusImage) { image in
                    image
                        .frame(width: 150, height: 150, alignment: .center)
                        .aspectRatio(contentMode: .fill)
                        .padding(.bottom, 30)
                }
                
                Unwrap(statusTitle) { title in
                    HStack(alignment: .top){
                        if let infoErrorMessage = infoErrorMessage {
                            Image(systemName: "info.circle.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    showPopover.toggle()
                                }
                              
                        }
                        
                        Text(title)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 14)
                    }
                }
                
                Unwrap(statusDescription) { description in
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                        .padding([.leading,.trailing], 30)
                        .padding(.bottom, 31)
                }
                
                HStack(spacing: 5) {
                    Unwrap(secondaryButtonTitle) { title in
                        ZStack {
                            Rectangle()
                                .foregroundColor(secondaryButtonBackgroundColor)
                                .frame(maxWidth: defaultSecondaryButtonWidth , maxHeight: .infinity)
                                .onTapGesture {
                                    secondaryButtonAction?()
                                }
                                .cornerRadius(27)
                            
                            Text(title)
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
                    
                    Unwrap(mainButtonTitle) { title in
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(mainButtonBackgroundColor)
                                .frame(maxWidth: .infinity , maxHeight: .infinity)
                                .onTapGesture {
                                    mainButtonAction?()
                                }
                                .cornerRadius(27)
                            
                            Text(title)
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 53)
                .padding([.leading,.trailing], 30)
                
            }
        }
    }
}


struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        LocalePreview {
            ErrorView(statusImage: Image("server"),
                      statusTitle: "",
                      statusDescription: "description",
                      mainButtonTitle: "",
                      mainButtonAction: {},
                      secondaryButtonTitle: "dismiss",
                      secondaryButtonAction: {},
                      infoErrorMessage: "info error message"
            )
        }
    }
}
