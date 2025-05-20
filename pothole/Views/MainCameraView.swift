import SwiftUI

//
//  MainCameraView.swift
//  pothole
//
//  Created by Joshua Maza on 5/19/25.
//


struct MainCameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var cameraUIView: UIView?

    var body: some View {
        VStack(spacing: 0) {
            CameraPreview(viewReference: $cameraUIView)
                .frame(height: 400)
                .clipped()
                .onAppear {
                    if let cameraView = cameraUIView {
                        viewModel.startTimer(for: cameraView)
                    }
                }
                .onChange(of: cameraUIView) { newView in
                    if let cameraView = newView {
                        viewModel.startTimer(for: cameraView)
                    }
                }
            
            InfoView(viewModel: viewModel)
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }
}

struct MainCameraView_Previews: PreviewProvider {
    static var previews: some View {
        MainCameraView()
    }
}
