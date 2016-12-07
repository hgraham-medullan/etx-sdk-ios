//
//  UserServiceTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/2/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import XCTest
@testable import EngaugeTx

class UserServiceTest: XCTestCase {
    var app: EngaugeTxApplication!
    var userSvc: ETXUserService!
    
    override func setUp() {
        super.setUp()
        self.app = EngaugeTxApplication(appId: "743f932a6fecf5cc30730c2385d6e7c7", clientKey: "b7fd395de3739fd6bc36d459ac47ec5e642a0331")
        self.userSvc = ETXUserService()
    }
    
    override func tearDown() {
        self.userSvc = nil
    }
    
    func testSuccessfulLoginWithUsername() {
        let username: String = "sean@medullan.com"
        let password: String = "P@ssw0rd"
        
        let successfulUserLoginExpectation = expectation(description: "User login is successsful")
        
        self.userSvc.loginUserWithUsername(username, password: password, rememberMe: false) {
            (user: ETXUser?, err: ETXError?) in
            successfulUserLoginExpectation.fulfill()
            XCTAssertEqual(user?.username, username)
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("User login call failed: \(error)")
            }
        }
    }
    
    func testSuccessfulLoginWithEmail() {
        let email: String = "sean@medullan.com"
        let password: String = "P@ssw0rd"
        
        let successfulUserLoginExpectation = expectation(description: "User login is successsful")
        self.userSvc.loginUserWithEmail(email, password: password, rememberMe: false) {
            (user: ETXUser?, err: ETXError?) in
            successfulUserLoginExpectation.fulfill()
            XCTAssertEqual(user?.email, email)
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("User login call failed: \(error)")
            }
        }
    }
    
    func testLoginWithInvalidEmailCredentials() {
        let email: String = "sean@medullan.com"
        let password: String = "badpwd"
        
        let successfulUserLoginExpectation = expectation(description: "User login is successsful")
        self.userSvc.loginUserWithEmail(email, password: password, rememberMe: false) {
            (user: ETXUser?, err: ETXError?) in
            XCTAssertNil(user, "User object should be nil on login failure")
            XCTAssertNotNil(err, "Error object should not be nil on login failure")
            XCTAssertTrue(err is ETXAuthenticationError?)
            
            if let authErr: ETXAuthenticationError = (err as? ETXAuthenticationError), let failureReason = authErr.reason {
                XCTAssertEqual(failureReason, ETXAuthenticationError.Reason.InvalidUsernameOrPassword)
            } else {
                XCTFail("Error should be of type 'ETXAuthenticationError'")
            }
            
            successfulUserLoginExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("User login call failed: \(error)")
            }
        }
    }

    
}
