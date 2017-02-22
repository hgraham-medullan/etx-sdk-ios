//
//  UserServiceAuthenticatedTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 2/22/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx


class UserServiceAuthenticatedTests: AuthenticatedTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testChangeEmailAddressWhenTheNewEmailIsTheSameAsTheCurrent() {
        let emailUpdatedExpectation = expectation(description: "User email updated successsful")
        self.currentUser.updateEmailAddress(self.currentUser.email, currentPassword: self.defaultTestUser.password) {
            (err: ETXError?) in
            XCTAssertNil(err)
            emailUpdatedExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("User login call failed: \(error)")
            }
        }
    }
    
    func testChangeEmailAddressWhenTheNewEmailIsNotTheSameAsTheCurrent() {
        let emailUpdatedExpectation = expectation(description: "User email updated successsful")
        let oldEmail:String = self.defaultTestUser.email
        let newEmail = "sean+updatedEmail@medullan.com"
        
        self.currentUser.updateEmailAddress(
        newEmail, currentPassword: self.defaultTestUser.password) {
            
            (err: ETXError?) in
            XCTAssertNil(err)
            
            // Set back to the old email
            self.currentUser.updateEmailAddress(oldEmail, currentPassword: self.defaultTestUser.password) {
                (err: ETXError?) in
                XCTAssertNil(err)
                emailUpdatedExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("User login call failed: \(error)")
            }
        }
    }
    
    // TODO: Update with failure cases when integrated with the API
}
