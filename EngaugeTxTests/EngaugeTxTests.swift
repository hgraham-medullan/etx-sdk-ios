//
//  EngaugeTxTests.swift
//  EngaugeTxTests
//
//  Created by Sean Hoilett on 11/28/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import XCTest
@testable import EngaugeTx

class EngaugeTxTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetValueForKeyWhenTheKeyDoesNotExist() {
        let valueForNonExistentKey: String? = EngaugeTxApplication.getValueForKey(key: "non-existent-key")
        XCTAssertEqual(valueForNonExistentKey, nil)
    }
    
    func testGetValueForKeyWhenFileDoesNotExist() {
        let valueForNonExistentKey: String? = EngaugeTxApplication.getValueForKey(key: "non-existent-key", plistFileName: "Info")
        XCTAssertEqual(valueForNonExistentKey, nil)
    }
    
}
