//
//  EngaugeTxApplicationTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/1/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import XCTest
@testable import EngaugeTx
import Alamofire

class EngaugeTxApplicationTests: XCTestCase {
    
    var engaugeTxApllication: EngaugeTxApplication?
    let testAppId: String = "test-app-id"
    let testClientKey: String = "test-client-key"
    let testBaseUrl: String = "test-base-url"
    let defaultBaseUrl: String = "https://api.us1.engaugetx.com/v1"
    
    override func setUp() {
        super.setUp()
    }
    
    func testPrimaryInitializer() {
        self.engaugeTxApllication = EngaugeTxApplication()
        XCTAssertEqual(EngaugeTxApplication.baseUrl, defaultBaseUrl, "Default base URL mismatch")
    }
    
    func testInitializationWithAppIdAndClientKey() {
        self.engaugeTxApllication = EngaugeTxApplication(appId: testAppId, clientKey: testClientKey)
        XCTAssertEqual(testAppId, EngaugeTxApplication.appId)
        XCTAssertEqual(testClientKey, EngaugeTxApplication.clientKey)
    }
    
    func testInitializationWithAppIdClientKeyAndBaseUrl() {
        self.engaugeTxApllication = EngaugeTxApplication(appId: testAppId, clientKey: testClientKey, baseUrl: testBaseUrl)
    
        XCTAssertEqual(testAppId, EngaugeTxApplication.appId)
        XCTAssertEqual(testClientKey, EngaugeTxApplication.clientKey)
        XCTAssertEqual(testBaseUrl, EngaugeTxApplication.baseUrl)
        
    }
    
    override func tearDown() {
        super.tearDown()
        self.engaugeTxApllication = nil
    }
    
    
    func testTestCall() {
//        let exp = expectation(description: "bhgg h ")
        self.engaugeTxApllication = EngaugeTxApplication(appId: "743f932a6fecf5cc30730c2385d6e7c7", clientKey: "b7fd395de3739fd6bc36d459ac47ec5e642a0331")
//        self.engaugeTxApllication?.testCall() {
//            res in
//            print(res)
//            exp.fulfill()
//        }
//        testCall
        
//        waitForExpectations(timeout: 10) { error in
//            if let error = error {
//                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//            }
//        }
        
    }
}
