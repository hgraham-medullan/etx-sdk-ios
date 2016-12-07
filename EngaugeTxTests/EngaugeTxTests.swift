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
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetValueForKeyWhenTheKeyDoesNotExist() {
        let valueForNonExistentKey = EngaugeTxApplication.getValueForKey(key: "non-existent-key")
        XCTAssertEqual(valueForNonExistentKey, nil)
    }
    
    func testGetValueForKeyWhenFileDoesNotExist() {
        let valueForNonExistentKey = EngaugeTxApplication.getValueForKey(key: "non-existent-key", plistFileName: "Info")
        XCTAssertEqual(valueForNonExistentKey, nil)
    }
    
}
