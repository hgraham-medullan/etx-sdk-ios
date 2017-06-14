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
    let fileMimeType: String = "application/json"
    let nameToSaveAs: String = "testFile"
    
    override func setUp() {
        super.setUp();
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "test-upload-file", ofType: "json")!
        data = try! NSData(contentsOfFile: path) as Data
    }
    
    func testSaveFileToPlatformWhenTheFileObjectIsValid() {
        let blobSaveExpectation = expectation(description: "Successful Login")
        
        let blob = ETXBlob(fileData: self.data, fileName: nameToSaveAs, mimeType: fileMimeType)
        blob.save {
            (err) in
            XCTAssertNil(err, "The blob shoud save sucessfully")
            XCTAssertNotNil(blob.id, "The blob should have an ID")
            XCTAssertEqual(4, blob.size!, "The size of the file should be 4 bytes")
            blobSaveExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("blob save expectation timeout \(String(describing: err))")
        }
    }
    
    func testShouldNotBeAbleToGetTheUrlToAFileWhenItIsNotSaved() {
        let blob = ETXBlob(fileData: self.data, fileName: nameToSaveAs, mimeType: fileMimeType)
        XCTAssertNil(blob.url, "Blob url should be nil when the blob is not yet saved")
    }
    
    func testSaveFileToPlatformWhenTheFileObjectIsValid2() {
        let blobSaveExpectation = expectation(description: "Successful Login")
        
        let blob = ETXBlob(fileData: self.data, fileName: nameToSaveAs, mimeType: fileMimeType)
        blob.save {
            (err) in
            XCTAssertNil(err, "The blob shoud save sucessfully")
            
            let repo = Repository<ETXModel>(resourcePath: "/");
            
            let expectedUrl: String = "\(EngaugeTxApplication.baseUrl!)/blobs/\(blob.id!)?" +
                "accessToken=\(repo.getAccessToken()!)&appId=\(EngaugeTxApplication.appId!)&clientKey=\(EngaugeTxApplication.clientKey!)"
            XCTAssertEqual(expectedUrl, blob.url?.absoluteString)
            blobSaveExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            XCTAssertNil(err, "The blob shoud save sucessfully")
            print("blob save expectation timeout \(String(describing: err))")
        }
    }
    
}
