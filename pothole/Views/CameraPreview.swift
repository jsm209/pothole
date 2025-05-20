import SwiftUI
import AVFoundation

//
//  CameraPreview.swift
//  pothole
//
//  Created by Joshua Maza on 5/19/25.
//


struct CameraPreview: UIViewRepresentable {
    class CameraPreviewView: UIView {
        private var previewLayer: AVCaptureVideoPreviewLayer?
        private let session = AVCaptureSession()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupCamera()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupCamera()
        }
        
        private func setupCamera() {
            session.sessionPreset = .photo
            
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let input = try? AVCaptureDeviceInput(device: device),
                  session.canAddInput(input) else {
                print("Failed to setup back camera")
                return
            }
            
            session.addInput(input)
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            self.layer.addSublayer(previewLayer)
            self.previewLayer = previewLayer
            
            session.startRunning()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer?.frame = bounds
        }
    }

    @Binding var viewReference: UIView?

    func makeUIView(context: Context) -> CameraPreviewView {
        let cameraView = CameraPreviewView()
        DispatchQueue.main.async {
            viewReference = cameraView
        }
        return cameraView
    }

    func updateUIView(_ uiView: CameraPreviewView, context: Context) {}
}
