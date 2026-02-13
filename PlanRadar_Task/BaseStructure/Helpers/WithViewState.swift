//
//  WithViewState.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import SwiftUI
import LoaderUI

struct WithViewState<Content: View>: View {
    @Binding var viewState: ViewState
    let content: Content
    var retryHandler: (() -> ())?
    var onDismissAction: (() -> ())?

    var isRefreshable: Bool
    
    @State private var showErrorSheet = false
    
    init(
        _ viewState: Binding<ViewState>,
        isRefreshable: Bool,
        @ViewBuilder content: () -> Content,
        retryHandler: (() -> ())? = nil,
        onDismissAction: (() -> ())? = nil

    ) {
        self._viewState = viewState
        self.isRefreshable = isRefreshable
        self.content = content()
        self.retryHandler = retryHandler
        self.onDismissAction = onDismissAction
    }
    
    var body: some View {
        switch viewState {
            case .loaded:
                content
                    .if(isRefreshable) { view in
                        view.refreshable {
                            retryHandler?()
                        }
                    }
                
            case .loading:
                content
                    .overlay(
                        ZStack {
                            Color.blue.opacity(0.5).ignoresSafeArea()
                            CircleStrokeSpinView()
                                .frame(width: 50, height: 100, alignment: .center)
                                .foregroundStyle(Color.blue)
                        }
                    )
                    .if(isRefreshable) { view in
                        view.refreshable {
                            retryHandler?()
                        }
                    }
                
            case let .inViewError(
                icon: icon,
                title: title,
                description: description,
                retryable: retryable
            ):
                content
                    .overlay(
                        ZStack {
                            if !retryable.isNil {
                                ErrorView(
                                    statusImage: icon,
                                    statusTitle: title,
                                    statusDescription: description,
                                    mainButtonTitle: "OK",
                                    mainButtonAction: retryable
                                )
                            } else {
                                ErrorView(
                                    statusImage: icon,
                                    statusTitle: title,
                                    statusDescription: description
                                )
                            }
                        }
                    )
            
            default:
                content
                    .onAppear {
                        showErrorSheet = true
                    }
                    .sheet(isPresented: $showErrorSheet) {
                        errorSheetView()
                    }
        }
    }
    
    
    private func errorSheetView() -> some View {
        switch viewState {
            case let .infoError(description: description , isForgetPass : isForgetPass , forgetAction: forgetAction):
                return ErrorView(
                    statusImage: Image("server"),
                    statusTitle: "InfoError",
                    statusDescription: description,
                    secondaryButtonTitle: "OK" ,
                    secondaryButtonAction: {
                        if retryHandler.isNil {
                            Helpers.wait(0) {
                                viewState = .loaded
                                showErrorSheet = false
                            }
                        } else {
                            viewState = .loaded
                            retryHandler?()
                        }
                       })
                    
            case .noData(let description):
                return ErrorView(
                    statusImage: Image("server"),
                    statusTitle: "NoData",
                    statusDescription: description
                )
                
            case .offline(let description):
                return ErrorView(
                    statusImage: Image("server"),
                    statusTitle: "Offline",
                    statusDescription: description,
                    mainButtonTitle: "OK",
                    mainButtonAction: retryHandler
                )
            case .serverError(let description):
                return ErrorView(
                    statusImage: Image("server"),
                    statusTitle: "ServerError",
                    statusDescription: description,
                    mainButtonTitle: "OK",
                    mainButtonAction: retryHandler
                )
            case .unexpected(let description):
                return ErrorView(
                    statusImage: Image("server"),
                    statusTitle: "UnExpected",
                    statusDescription: description,
                    mainButtonTitle: "OK",
                    mainButtonAction: retryHandler
                )
            case .custom(let icon, let title, let description,let infoError ,let retryable):
                if retryable {
                    return ErrorView(
                        statusImage: icon,
                        statusTitle: title,
                        statusDescription: description,
                        mainButtonTitle: "CustomError",
                        mainButtonAction: retryHandler,
                        infoErrorMessage: infoError
                    )
                } else {
                    return ErrorView(
                        statusImage: icon,
                        statusTitle: title,
                        statusDescription: description,
                        secondaryButtonTitle: "Error",
                        secondaryButtonAction: onDismissAction,
                        infoErrorMessage: infoError
                    )
                }
            default:
                return ErrorView(
                    statusImage: Image("server"),
                    statusTitle: "Error",
                    statusDescription: "Error",
                    mainButtonTitle: "OK",
                    mainButtonAction: retryHandler
                )
        }
    }
}


#Preview {
    @State var viewState: ViewState = .custom(
        icon: Image("server"),
        title: "Error 429",
        description: "Das Einlösen der E-Rezepte per Gesundheitskarte ist leider aktuell nicht möglich",
        infoErrorMessage: "asdasd",
        retryable: false
    )
    
    WithViewState(
        $viewState,
        isRefreshable: true
    ) {
        ScrollView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
                
                Spacer()
            }
            .padding()
        }
    } retryHandler: {
        sleep(3_000_000_000)
    }
}
