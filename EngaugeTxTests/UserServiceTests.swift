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
    var userSvc: UserService!
    
    override func setUp() {
        super.setUp()
        self.userSvc = UserService()
    }
    
    override func tearDown() {
        self.userSvc = nil
    }
    
    func testLoginWithUsername() {
        let username: String = "sean"
        let password: String = "P@ssw0rd"
        
        let successfulUserLoginExpectation = expectation(description: "User login is successsful")
        
        self.userSvc.loginUserWithUsername(username, password: password) {
            (user: User?, err: TxError?) in
            successfulUserLoginExpectation.fulfill()
            XCTAssertEqual(user?.username, username)
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("User login call failed: \(error)")
            }
        }
    }
    
    func testSuccessfulLoginWithUsername() {
        let username: String = "sean"
        let password: String = "P@ssw0rd"
        
        let successfulUserLoginExpectation = expectation(description: "User login is successsful")
        
        self.userSvc.loginUserWithUsername(username, password: password) {
            (user: User?, err: TxError?) in
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
        self.userSvc.loginUserWithEmail(email, password: password) {
            (user: User?, err: TxError?) in
            successfulUserLoginExpectation.fulfill()
            XCTAssertEqual(user?.email, email)
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("User login call failed: \(error)")
            }
        }
    }
    
}
