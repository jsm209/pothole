import SwiftUI

//
//  InfoView.swift
//  pothole
//
//  Created by Joshua Maza on 5/19/25.
//


struct InfoView: View {
    @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.infoText)
                .font(.headline)
            
            Divider()
            
            Text("Saved Screenshots:")
                .font(.subheadline)
                .bold()
            
            if viewModel.savedScreenshotFiles.isEmpty {
                Text("No screenshots taken yet.")
                    .italic()
                    .foregroundColor(.secondary)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(viewModel.savedScreenshotFiles, id: \.self) { filename in
                            Text(filename)
                                .font(.caption)
                                .foregroundColor(.blue)
                                .lineLimit(1)
                        }
                    }
                }
                .frame(maxHeight: 150)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
    }
}
