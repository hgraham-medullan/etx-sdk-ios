//
//  CaregiverTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 4/28/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx

class CaregiverTests: AffiliationTestCase {
    
    var affiliatedPatient: ETXUser!
    
    override func setUp() {
        super.setUp()
        self.loginAsCaregiver()
        getAffiliatedPatient()
    }
    
    func getAffiliatedPatient() {
        let getAffiliatedUsersExpectation = expectation(description: "Successful get affiliated users")
        
        let service = ETXAffiliationService()
        service.getAffiliatedUsers(withRole: ETXRole.patient, forMyRole: ETXRole.caregiver){
            (affiliatedUsers, err) in
            if let affiliatedUsers = affiliatedUsers {
                XCTAssertTrue(affiliatedUsers.count > 0, "The user is not affiliated with any users")
                self.affiliatedPatient = affiliatedUsers[0]
            } else {
                XCTFail("The user is not affiliated with any users")
            }
            getAffiliatedUsersExpectation.fulfill()
        }
        waitForExpectations(timeout: 20) {
            (err) in
            print("GetAffiliatedUsers expectation timeout \(err)")
        }
    }
    
    func testGetAffiliatedUsers() {
        let getAffiliatedUsersExpectation = expectation(description: "Successful get affiliated users")
        
        let service = ETXAffiliationService()
        service.getAffiliatedUsers(withRole: ETXRole.patient, forMyRole: ETXRole.caregiver){
            (affiliatedUsers, err) in
            if let affiliatedUsers = affiliatedUsers {
                XCTAssertTrue(affiliatedUsers.count > 0, "The user is not affiliated with any users")
                let patient = affiliatedUsers[0]
                XCTAssertNotNil(patient)
            } else {
                XCTFail("The user is not affiliated with any users")
            }
            getAffiliatedUsersExpectation.fulfill()
        }
        waitForExpectations(timeout: 20) {
            (err) in
            print("GetAffiliatedUsers expectation timeout \(err)")
        }
    }
    
    func testGetTrendDataForPatient() {
        let getAffiliatedUsersExpectation = expectation(description: "Trend result for patient")
        ETXTrendService.getTrend(trendTimeframe: .TwoWeeks, classes: [ETXSteps.self], forUser: self.affiliatedPatient) {
            (resultSet, err) in
            XCTAssertNil(err)
            getAffiliatedUsersExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("GetAffiliatedUsers expectation timeout \(err)")
        }
    }
}
