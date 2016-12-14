//
//  RegistrationErrorTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/13/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper

class RegistrationErrorTests: XCTestCase {
    
    override func setUp() {
        
    }
    override func tearDown() {
        
    }
    
    func testGetValidationErrorsWhenThereAreFieldValidationErrorsPresentFromLoopBack() {
        
        let jsonError  = "{\"error\":{\"name\":\"ModelValidationError\",\"message\":\"The Model instance is not valid. See error object `details` property for more info.\",\"statusCode\":400,\"details\":{\"context\":\"EtxUser\",\"codes\":{\"username\":[\"uniqueness\"],\"email\":[\"uniqueness\"]},\"messages\":{\"username\":[\"User already exists\"],\"email\":[\"Email already exists\"]}}}}"
        
        let expected:[String: [String:String]] = [
            "username": ["uniqueness": "User already exists"],
            "email": ["uniqueness":"Email already exists"]
        ]
        let err = ETXRegistrationError(JSONString: jsonError)
        XCTAssertEqual(expected.description, err?.validationErrors?.description)
    }
    
    func testGetValidationErrorsWhenThereAreFieldValidationErrorsPresent() {
        let jsonError  = "{\"error\":{\"name\":\"ModelValidationError\",\"message\":\"The Model instance is notid. See error object `details` property for more info.\",\"code\":\"\",\"statusCode\":400,\"details\":{\"firstName\":{\"minLength\":\"First Name must be at least 2 characters long\"},\"lastName\":{\"minLength\":\"Last Name must be at least 2 characters long\"},\"username\":{\"required\":\"property is invalid, does not meet criteria specified, i.e required: true\"},\"password\":{\"minLength\":\"Password must be at least 8 characters long\"}}}}"
        
        let expected:[String: [String:String]] = [
            "firstName": ["minLength": "First Name must be at least 2 characters long"],
            "lastName": ["minLength": "Last Name must be at least 2 characters long"],
            "username": ["required": "property is invalid, does not meet criteria specified, i.e required: true"],
            "password": ["minLength": "Password must be at least 8 characters long"]
        ]
        let err = ETXRegistrationError(JSONString: jsonError)
        XCTAssertEqual(expected.description, err?.validationErrors?.description)
    }
}
