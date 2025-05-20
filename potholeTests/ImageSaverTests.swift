//
//  ImageSaverTests.swift
//  pothole
//
//  Created by Joshua Maza on 5/19/25.
//

import XCTest
@testable import pothole

class ImageSaverTests: XCTestCase {
    var imageSaver: ImageSaver!
    var savedFilename: String?
    
    override func setUp() {
        super.setUp()
        imageSaver = ImageSaver()
        savedFilename = nil
    }
    
    override func tearDown() {
        // Clean up saved file after test
        if let filename = savedFilename {
            let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = docsURL.appendingPathComponent(filename)
            try? FileManager.default.removeItem(at: fileURL)
        }
        
        imageSaver = nil
        super.tearDown()
    }
    
    func testSaveImageAsBase64_createsFile() {
        let expectation = XCTestExpectation(description: "Completion handler called with filename")
        
        let testImage = UIImage(systemName: "star.fill")!
        
        imageSaver.saveImageAsBase64(testImage) { filename in
            self.savedFilename = filename
            
            // Verify file exists
            let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = docsURL.appendingPathComponent(filename)
            let fileExists = FileManager.default.fileExists(atPath: fileURL.path)
            
            XCTAssertTrue(fileExists, "Saved file should exist at path \(fileURL.path)")
            
            // Read content and verify it's valid Base64 string
            if let content = try? String(contentsOf: fileURL, encoding: .utf8) {
                XCTAssertFalse(content.isEmpty, "Saved file content should not be empty")
                
                // Try to decode base64 to data
                let decodedData = Data(base64Encoded: content)
                XCTAssertNotNil(decodedData, "File content should be valid Base64")
                
                // Optional: Check if decoded data can create a UIImage
                if let data = decodedData {
                    let image = UIImage(data: data)
                    XCTAssertNotNil(image, "Decoded data should convert back to UIImage")
                }
            } else {
                XCTFail("Failed to read saved file content")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
