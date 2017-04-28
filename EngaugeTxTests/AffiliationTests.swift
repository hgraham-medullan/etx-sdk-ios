//
//  AffiliationTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 4/28/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx

class AffiliationTestCase: AuthenticatedTestCase {
    
    let affiliationService = ETXAffiliationService()
    
    override func setUp() {
        
    }
    
    func loginAsPatient() {
        self.loginUser(self.patientUser)
    }
    
    func loginAsCaregiver() {
        self.loginUser(self.caregiverUser)
    }
    
}
