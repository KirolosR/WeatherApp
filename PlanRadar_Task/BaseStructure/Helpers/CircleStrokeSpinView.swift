//
//  CircleStrokeSpinView.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import SwiftUI
import NVActivityIndicatorView

struct CircleStrokeSpinView: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<CircleStrokeSpinView>) -> NVActivityIndicatorView {
        let activityIndicatorView = NVActivityIndicatorView(
            frame: CGRect(x: 0, y: 0, width: 50, height: 50),
            type: .circleStrokeSpin,
            color: .blue,
            padding: nil
        )
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    func updateUIView(_ uiView: NVActivityIndicatorView, context: Context) {
        uiView.startAnimating()
    }
}

struct CircleStrokeSpinView_Previews: PreviewProvider {
    static var previews: some View {
            CircleStrokeSpinView()
    }
}
