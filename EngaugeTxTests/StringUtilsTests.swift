//
//  StringUtilsTests.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import XCTest
@testable import EngaugeTx

class StringUtilsTests: XCTestCase {
    
    
    func testShouldReturnEmptyStringWhenArrayisEmpty(){
        let strings: [String]? = []
        let result = ETXStringUtils.join(strings: strings!)
        XCTAssertEqual(result, "")
    
    }
    
    func testShouldReturnJoinedyStringWhenArrayisNotEmpty(){
        let strings: [String]? = ["testing", "123"]
        let result = ETXStringUtils.join(strings: strings!)
        XCTAssertEqual(result, "testing123")
        
    }
    
    func testShouldReturnJoinedyStringWhenArrayisNotEmptyAndCustomDelimiterPassed(){
        let strings: [String]? = ["testing", "123"]
        let result = ETXStringUtils.join(strings: strings!, delimiter: ETXStringUtils.COMMA)
        XCTAssertEqual(result, "testing,123")
        
    }
    

}
