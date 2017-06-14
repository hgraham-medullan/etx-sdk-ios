//
//  BlobRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 6/14/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//


import XCTest
@testable import EngaugeTx
class BlobRepositoryTest: AuthenticatedTestCase {
    
    var data: Data!
    
    override func setUp() {
        super.setUp();
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "test-upload-file", ofType: "json")!
        data = try! NSData(contentsOfFile: path) as Data
    }
    
    func testSaveFileToPlatformWhenTheFileObjectIsValid() {
        let blobSaveExpectation = expectation(description: "Successful Login")
        
        let blob = ETXBlob(fileData: self.data, fileName: "testFile", mimeType: "application/json")
        blob.save {
            (err) in
            XCTAssertNotNil(blob.id, "The blob should have an ID")
            XCTAssertEqual(4, blob.size!, "The size of the file should be 4 bytes")
            blobSaveExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("blob save expectation timeout \(String(describing: err))")
        }
    }
    
}
