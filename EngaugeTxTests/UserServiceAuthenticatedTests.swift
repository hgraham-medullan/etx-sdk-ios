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
        self.currentUser.updateEmailAddress(self.currentUser.email, currentPassword: self.defaultTestUser.password!) {
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
        let emailUpdatedExpectation = expectation(description: "User email updated successsfully")
        let oldEmail:String = self.defaultTestUser.email
        let newEmail = "sean+updatedEmail@medullan.com"
        
        self.currentUser.updateEmailAddress(
        newEmail, currentPassword: self.defaultTestUser.password!) {
            
            (err: ETXError?) in
            XCTAssertNil(err)
            
            // Set back to the old email
            self.currentUser.updateEmailAddress(oldEmail, currentPassword: self.defaultTestUser.password!) {
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
    
    func testUpdateUserLocale() {
        let localeUpdateExpectation = expectation(description: "User updated successsfully")
        let userLocale: String = "en-US"
        let newUserLocale: String = "en"
        self.currentUser.locale = newUserLocale
        self.currentUser.save {
            (err: ETXError?) in
            XCTAssertNil(err, "The user should be updated successfully with the new locale")
            ETXUser.findById(self.currentUser.id!) {
                (user, err) in
                XCTAssertNil(err, "The user should be fetched successfully")
                XCTAssertEqual(user?.locale!, newUserLocale, "The user should be updated with the new locale")
                
                // Reset the locale back to it's original value
                self.currentUser.locale = userLocale
                self.currentUser.save {
                    (err: ETXError?) in
                    XCTAssertNil(err, "The user should be updated successfully with the new locale")
                    localeUpdateExpectation.fulfill()
                }
            }
        }
    
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("User update failed: \(error)")
            }
        }
        
    }
}
