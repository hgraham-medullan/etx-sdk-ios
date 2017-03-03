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
    
    override func setUp() {
        super.setUp()
        self.app = EngaugeTxApplication(appId: "780407513adffc0936afc58919f83873", clientKey: "b7fd395de3739fd6bc36d459ac47ec5e642a0331", baseUrl: "https://api.migrate.eu1.engaugetx.com/v1")
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
