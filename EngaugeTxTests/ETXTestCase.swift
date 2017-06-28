//
//  ETXTestCase.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/16/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx

class ETXTestCase: XCTestCase {
    var app: EngaugeTxApplication!
    let TIMEOUT_DEFAULT: TimeInterval = 10
    
    var currentUser: ETXUser!
    static let defaultPassword = "P@ssw0rd"
    let defaultTestUser:ETXUser = ETXUser(email: "sean@medullan.com", username: "sean@medullan.com", password: defaultPassword)
    var testUserUnverified:ETXUser = ETXUser(email: "sean+unverified@medullan.com", username: "sean+unverified@medullan.com", password: defaultPassword)
    var caregiverUser = ETXUser(email: "sean@medullan.com", username: "sean@medullan.com", password: defaultPassword)
    var patientUser = ETXUser(email: "sean+patient@medullan.com", username: "sean+patient@medullan.com", password: defaultPassword)
    var softDeletedUser = ETXUser(email: "sean+softDelete@medullan.com", username: "sean+softDelete@medullan.com", password: defaultPassword)
    var hardDeletedUser = ETXUser(email: "sean+hardDelete@medullan.com", username: "sean+hardDelete@medullan.com", password: defaultPassword)
    
    let stagingApp = EngaugeTxApplication(
        appId: "e8b836cd6d20f3431e0fbcb54196360b",
        clientKey: "7c2759273aaf770093f92e0accca965255fac0d1",
        baseUrl: "https://api.staging.us1.engaugetx.com/v1"
    )
    
    let biApp = EngaugeTxApplication(
        appId: "e8b836cd6d20f3431e0fbcb54196360b",
        clientKey: "7c2759273aaf770093f92e0accca965255fac0d1",
        baseUrl: "https://api.us1.engaugetx.com/v1"
    )
    
    let dokkuStagingApp = EngaugeTxApplication(
        appId: "743f932a6fecf5cc30730c2385d6e7c7",
        clientKey: "b7fd395de3739fd6bc36d459ac47ec5e642a0331",
        baseUrl: "https://api.staging.eu1.engaugetx.com/v1"
    )
    
    override func setUp() {
        super.setUp()
        self.app = EngaugeTxApplication(
            appId: "e8b836cd6d20f3431e0fbcb54196360b",
            clientKey: "7c2759273aaf770093f92e0accca965255fac0d1",
            baseUrl: "https://api.us1.engaugetx.com/v1"
        )
    }
    
    override func tearDown() {
        super.tearDown()
        self.app = nil
    }
    
    func getUniqueId() -> String {
        return "tx_\(NSUUID().uuidString.lowercased().replacingOccurrences(of: "-", with: ""))"
    }
    
    func testGetUniqueId() {
        let uniqueId = getUniqueId()
        XCTAssertTrue(uniqueId.characters.count>0)
    }
}
