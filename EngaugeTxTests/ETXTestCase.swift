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
    
    let stagingApp = EngaugeTxApplication(
        appId: "e8b836cd6d20f3431e0fbcb54196360b",
        clientKey: "7c2759273aaf770093f92e0accca965255fac0d1",
        baseUrl: "https://api.staging.us1.engaugetx.com/v1"
    )
    
    let biApp = EngaugeTxApplication(
        appId: "e8b836cd6d20f3431e0fbcb54196360b",
        clientKey: "7c2759273aaf770093f92e0accca965255fac0d1",
        baseUrl: "https://api.staging.us1.engaugetx.com/v1"
    )
    
    override func setUp() {
        super.setUp()
        self.app = stagingApp
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
