//
//  EngaugeTxApplicationTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/1/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import XCTest
@testable import EngaugeTx

class EngaugeTxApplicationTests: XCTestCase {
    
    var engaugeTxApllication: EngaugeTxApplication?
    let testAppId: String = "test-app-id"
    let testClientKey: String = "test-client-key"
    let testBaseUrl: String = "test-base-url"
    let defaultBaseUrl: String = "https://api.eu1.engaugetx.com/v1"
    
    override func setUp() {
        super.setUp()
    }
    
    func testPrimaryInitializer() {
        self.engaugeTxApllication = EngaugeTxApplication()
        XCTAssertEqual(self.engaugeTxApllication?.baseUrl, defaultBaseUrl, "Default base URL mismatch")
    }
    
    func testInitializationWithAppIdAndClientKey() {
        self.engaugeTxApllication = EngaugeTxApplication(appId: testAppId, clientKey: testClientKey)
        XCTAssertEqual(testAppId, self.engaugeTxApllication?.appId)
        XCTAssertEqual(testClientKey, self.engaugeTxApllication?.clientKey)
    }
    
    func testInitializationWithAppIdClientKeyAndBaseUrl() {
        self.engaugeTxApllication = EngaugeTxApplication(appId: testAppId, clientKey: testClientKey, baseUrl: testBaseUrl)
    
        XCTAssertEqual(testAppId, self.engaugeTxApllication?.appId)
        XCTAssertEqual(testClientKey, self.engaugeTxApllication?.clientKey)
        XCTAssertEqual(testBaseUrl, self.engaugeTxApllication?.baseUrl)
        
    }
    
    override func tearDown() {
        super.tearDown()
        self.engaugeTxApllication = nil
    }
}
