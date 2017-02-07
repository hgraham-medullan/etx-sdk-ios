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
    
    override func setUp() {
        super.setUp()
        
        userSvc = ETXUserService()
        let loginExpectation = expectation(description: "Successful Login")
        userSvc.loginUserWithEmail("sean@medullan.com", password: "P@ssw0rd", rememberMe: false) {
            (user, err) in
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
            super.tearDown()
            logoutExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("Logout expectation timeout \(err)")
        }
        
    }
}
