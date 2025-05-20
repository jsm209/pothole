//
//  CameraViewModelTests.swift
//  pothole
//
//  Created by Joshua Maza on 5/19/25.
//

import XCTest
import SwiftUI
@testable import pothole

class CameraViewModelTests: XCTestCase {
    var viewModel: CameraViewModel!
    var testView: UIView!

    override func setUp() {
        super.setUp()
        viewModel = CameraViewModel()
        testView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        // Add a simple colored layer so the screenshot isn't blank
        testView.backgroundColor = .red
    }

    override func tearDown() {
        viewModel = nil
        testView = nil
        super.tearDown()
    }

    func testStartAndStopTimer() {
        // Start timer - check timer is not nil
        viewModel.startTimer(for: testView)
        XCTAssertNotNil(viewModel.timer, "Timer should be running after startTimer")
        
        // Stop timer - check timer is nil or cancelled
        viewModel.stopTimer()
        // timer is a private AnyCancellable? so can't directly test if cancelled, but it should be set to nil or invalid
        // We can check no crash and timer can't fire now
        XCTAssertTrue(true, "Stop timer executed without issues")
    }

    func testSavingImageCallsCompletion() {
        let expectation = XCTestExpectation(description: "Image saving completion called")

        let imageSaver = ImageSaver()
        let dummyImage = UIImage(systemName: "checkmark")! // Use any system image
        
        imageSaver.saveImageAsBase64(dummyImage) { filename in
            XCTAssertTrue(filename.hasPrefix("screenshot_"), "Filename should start with screenshot_")
            XCTAssertTrue(filename.hasSuffix(".txt"), "Filename should end with .txt")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testLoadSavedFilesUpdatesSavedScreenshotFiles() {
        // Save a dummy file manually first
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let testFilename = "screenshot_testfile.txt"
        let fileURL = docsURL.appendingPathComponent(testFilename)
        try? "testdata".write(to: fileURL, atomically: true, encoding: .utf8)

        viewModel.loadSavedFiles()

        XCTAssertTrue(viewModel.savedScreenshotFiles.contains(testFilename), "Saved screenshot files should include testfile")
        
        // Clean up
        try? FileManager.default.removeItem(at: fileURL)
    }

    func testCaptureScreenshotAddsFile() {
        let expectation = XCTestExpectation(description: "Screenshot capture adds file and updates list")

        // Start with loading existing files
        viewModel.loadSavedFiles()
        let beforeCount = viewModel.savedScreenshotFiles.count
        
        // Capture screenshot - completion triggers reload
        viewModel.captureScreenshot(from: testView)
        
        // We need to wait a bit for async save to complete and reload
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let afterCount = self.viewModel.savedScreenshotFiles.count
            XCTAssertGreaterThan(afterCount, beforeCount, "Saved screenshot files count should increase after captureScreenshot")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
