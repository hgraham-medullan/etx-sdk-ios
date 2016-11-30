//
//  EngaugeTxTests.swift
//  EngaugeTxTests
//
//  Created by Sean Hoilett on 11/28/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import XCTest
@testable import EngaugeTx

class EngaugeTxTests: XCTestCase {
    
    var authSvc: AuthSvc!
    
    override func setUp() {
        super.setUp()
        self.authSvc = AuthSvc()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginWithUsername() {
        let username: String = "sean"
        let password: String = "P@ssw0rd"
        authSvc.loginUserWithUsername(username, password: password) { (data: TxModel, err: TxError) in
            // TODO: Assertions
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
