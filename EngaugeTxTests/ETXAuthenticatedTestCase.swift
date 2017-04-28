//
//  ETXAuthenticatedTestCase.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 2/4/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx

class AuthenticatedTestCase: ETXTestCase {
    
    var userSvc: ETXUserService<ETXUser>!
    var currentUser: ETXUser!
    let defaultTestUser:ETXUser = ETXUser(email: "sean@medullan.com", username: "sean@medullan.com", password: "P@ssw0rd")
    var testUserUnverified:ETXUser = ETXUser(email: "sean+unverified@medullan.com", username: "sean+unverified@medullan.com", password: "P@ssw0rd")
    var caregiverUser = ETXUser(email: "sean@medullan.com", username: "sean@medullan.com", password: "P@ssw0rd")
    var patientUser = ETXUser(email: "sean+patient@medullan.com", username: "sean+patient@medullan.com", password: "P@ssw0rd")
    
    
    
    override func setUp() {
        super.setUp()

        userSvc = ETXUserService()
        let loginExpectation = expectation(description: "Successful Login")
        userSvc.loginUserWithEmail(self.defaultTestUser.email,
                                   password: self.defaultTestUser.password,
                                   rememberMe: false) {
                                    (user, err) in
                                    XCTAssertNotNil(user, "User should be successfully logged in")
                                    self.currentUser = user!
                                    loginExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("Login expectation timeout \(err)")
        }
    }
    
    func loginUser(_ user: ETXUser) {
        userSvc = ETXUserService()
        let loginExpectation = expectation(description: "Successful Login")
        userSvc.loginUserWithEmail(user.email,
                                   password: user.password,
                                   rememberMe: false) {
                                    (user, err) in
                                    XCTAssertNotNil(user, "User should be successfully logged in")
                                    self.currentUser = user!
                                    loginExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("Login expectation timeout \(err)")
        }
    }
    
    override func tearDown() {
        let logoutExpectation = expectation(description: "Successful logout")
        userSvc.logout {
            err in
            super.tearDown()
            logoutExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("Logout expectation timeout \(err)")
        }
        
    }
}
