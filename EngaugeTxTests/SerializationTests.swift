//
//  SerializationTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 6/29/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper
import XCTest
@testable import EngaugeTx

class SampleClass : ETXGenericDataObject {
    var firstName: String = "Sean"
    var middleName: String? = nil
    var lastName: String = "Hoilett"
    var ignoredWhenNull: String? = nil
    var savedWhenNull: String? = nil
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        firstName <- map["firstName"]
        lastName <- ignoreOnNull("lastName", map: map)
        savedWhenNull <- map["savedWhenNull"]
        ignoredWhenNull <- ignoreOnNull("ignoredWhenNull", map: map)
    }
}

class SerializationTests: ETXTestCase {
    
    func testThis() {
        let loginExpectation = expectation(description: "Successful Login")
        
        let sampleClass = SampleClass()
        sampleClass.ignoredWhenNull = nil
        sampleClass.savedWhenNull = nil
        
        sampleClass.save { (err) in
            XCTAssertNil(err, "No error should be present when a GDO")
            SampleClass.findById(sampleClass.id!) {
                (savedSampleClass, err) in
                let jsonResp: String = (savedSampleClass?.rawJson?.printJson())!
                XCTAssertTrue(jsonResp.contains("\"savedWhenNull\":null"), "The JSON from the platform should contain the 'savedWhenNull' property with a 'null' value")
                XCTAssertTrue(jsonResp.contains("\"lastName\":\"\(sampleClass.lastName)\""), "The JSON from the platform should contain the 'lastName' property")
                XCTAssertTrue(jsonResp.contains("\"firstName\":\"\(sampleClass.firstName)\""), "The JSON from the platform should contain the 'firstName' property")
                XCTAssertFalse(jsonResp.contains("ignoredWhenNull"), "The JSON response from the platform should not contain the 'ignoredWhenNull' property")
                loginExpectation.fulfill()
            }
            
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("Login expectation timeout \(String(describing: err))")
        }
    }
}
