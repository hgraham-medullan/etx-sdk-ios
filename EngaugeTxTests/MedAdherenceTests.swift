//
//  MedAdherenceTests.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/24/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
//import ObjectMapper

class MedAdherenceTests: AuthenticatedTestCase {
    
    func xtestGetAdherenceforUnAffiliatedUser(){
        let testExpectation = expectation(description: "Successful testGetAdherenceforUnAffiliatedUser")
    
        ETXAdherenceService.getAdherence(medicationId: "rescue_300", trendTimeframe: ETXTrendTimeframe.TwoWeeks){
            (model, err) in
            XCTAssertNil(err)
            XCTAssertNotNil(model)
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 20) {
            (err) in
            print("testGetAdherenceforUnAffiliatedUser expectation timeout \(err)")
        }
    }
    
    func xtestGetAdherenceforAffiliatedUser(){
        let testExpectation = expectation(description: "Successful testGetAdherenceforAffiliatedUser")
        let patientUser = ETXUser()
        patientUser.id = "12345"
        
        ETXAdherenceService.getAdherence(medicationId: "rescue_300", trendTimeframe: ETXTrendTimeframe.TwoWeeks, forUser: patientUser){
            (model, err) in
            XCTAssertNil(err)
            XCTAssertNotNil(model)
            print("\(model?[0].rawJson)")
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 20) {
            (err) in
            print("testGetAdherenceforUnAffiliatedUser expectation timeout \(err)")
        }
    }
    
}
