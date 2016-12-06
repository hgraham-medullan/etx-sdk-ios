//
//  UserEmailCredentialsTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/6/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import XCTest
@testable import EngaugeTx
import ObjectMapper

class UserEmailCredentialsTests: XCTestCase {
    
    func testToJsonMapping() {
        let email: String = "sean@medullan.com"
        let password: String = "P@ssw0rd"
        let expected: [String:String] = ["email": email, "password": password]
        
        let userEmailCredentials = UserEmailCredentials(email, password: password)
        XCTAssertEqual(expected, userEmailCredentials.toJSON() as! [String: String])
    }
    
    func testFromJsonMapping() {
        let email: String = "sean@medullan.com"
        let password: String = "P@ssw0rd"
        
        let expected: [String:String] = ["email": email, "password": password]
        
        let m: Map = Map(mappingType: .fromJSON, JSON: expected)
        let userEmailCredentials = UserEmailCredentials(map: m)
        print(userEmailCredentials)
        
        //XCTAssertEqual(expected, userEmailCredentials.toJSON() as! [String: String])
    }
}
