import SwiftUI

//
//  ImageSaver.swift
//  pothole
//
//  Created by Joshua Maza on 5/19/25.
//


class ImageSaver {
    // Completion returns saved filename
    func saveImageAsBase64(_ image: UIImage, completion: ((String) -> Void)? = nil) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let base64String = data.base64EncodedString()
        saveToDisk(base64String: base64String, completion: completion)
    }
    
    private func saveToDisk(base64String: String, completion: ((String) -> Void)? = nil) {
        let filename = "screenshot_\(Date().timeIntervalSince1970).txt"
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)
        
        do {
            try base64String.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Saved screenshot to \(fileURL.path)")
            completion?(filename)
        } catch {
            print("Failed to save screenshot: \(error)")
            completion?(filename)
        }
    }
}
