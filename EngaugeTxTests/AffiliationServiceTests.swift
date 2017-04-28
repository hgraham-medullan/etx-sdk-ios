//
//  AffiliationServiceTests.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/12/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper




class AffiliationServiceTestCase: AuthenticatedTestCase  {
    override func setUp() {
        super.setUp()
    }
    
    func testGetAffiliatedUsers() {
        let getAffiliatedUsersExpectation = expectation(description: "Successful get affiliated users")
        
        let service = ETXAffiliationService()
        service.getAffiliatedUsers(withRole: ETXRole.patient, forMyRole: ETXRole.caregiver){
            (user, err) in
            XCTAssertNotNil(user)
            getAffiliatedUsersExpectation.fulfill()
        }
        waitForExpectations(timeout: 20) {
            (err) in
            print("GetAffiliatedUsers expectation timeout \(err)")
        }
        
    }
    
    
    
}
