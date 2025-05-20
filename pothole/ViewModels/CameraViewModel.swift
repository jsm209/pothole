import SwiftUI
import Combine

//
//  CameraViewModel.swift
//  pothole
//
//  Created by Joshua Maza on 5/19/25.
//


class CameraViewModel: ObservableObject {
    @Published var infoText: String = "Back Camera Active"
    @Published var savedScreenshotFiles: [String] = []
    
    private var cancellables = Set<AnyCancellable>()
    var timer: AnyCancellable?
    private let imageSaver = ImageSaver()
    
    func startTimer(for cameraView: UIView) {
        loadSavedFiles()
        
        timer = Timer
            .publish(every: 5.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.captureScreenshot(from: cameraView)
            }
    }
    
    func stopTimer() {
        timer?.cancel()
    }
    
    func captureScreenshot(from view: UIView) {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { context in
            view.layer.render(in: context.cgContext)
        }
        imageSaver.saveImageAsBase64(image) { [weak self] filename in
            DispatchQueue.main.async {
                self?.loadSavedFiles()
            }
        }
    }
    
    func loadSavedFiles() {
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: docsURL.path)
            // Filter only the screenshot .txt files sorted newest first
            let screenshotFiles = files.filter { $0.hasPrefix("screenshot_") && $0.hasSuffix(".txt") }
                .sorted(by: >)
            self.savedScreenshotFiles = screenshotFiles
        } catch {
            print("Error loading saved files: \(error)")
            savedScreenshotFiles = []
        }
    }
}
