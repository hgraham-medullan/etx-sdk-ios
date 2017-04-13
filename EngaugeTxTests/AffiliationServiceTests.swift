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
    //        self.currentUser.id
    //        let email: String = "sean@medullan.com"
    //        let password: String = "P@ssw0rd"
    //        let expected: [String:String] = ["email": email, "password": password]
    
            let service = AffiliationService()
            service.getAffiliatedUsers(withRole: ETXRole.Patient, forMyRole: ETXRole.Caregiver){
                (user, err) in
                print(user ?? [ETXUser]())
                print(err ?? ETXError())
            }
    
    //        XCTAssertEqual(expected, userEmailCredentials.toJSON() as! [String: String])
        }
    
    
}
