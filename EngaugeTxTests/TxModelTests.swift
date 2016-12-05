//
//  TxModelTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/2/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import XCTest
@testable import EngaugeTx
import Alamofire

class TxModelTests: XCTestCase {
    
    func testGetPropertyNames() {
        let m: TxModel = TxModel()
        print(m.propertyNames());
        
        let u: User = User()
        print(u.propertyNames());
        
    }
    
}
