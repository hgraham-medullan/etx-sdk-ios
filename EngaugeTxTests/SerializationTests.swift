//
//  SerializationTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 6/29/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper
import XCTest
@testable import EngaugeTx

class SampleClass : ETXGenericDataObject {
    var firstName: String = "Sean"
    var middleName: String?
    var lastName: String = "Hoilett"
    var k: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        firstName <- map["firstName"]
//        lastName <- ignoreOnNull(jsonPropertyName: "lastName", map: map)
//        middleName <- ignoreOnNull(jsonPropertyName:"middleName", map: map)
//        k <- ignoreOnNull(jsonPropertyName: "extra.k", map: map)
    }
}

class SerializationTests: ETXTestCase {
    
    func testThis() {
        let loginExpectation = expectation(description: "Successful Login")
        let sc = SampleClass()
        let j = sc.toJSON()
        print(j);
        print("\n\n")
        print((sc as ETXModel).toJSON())
        print((sc as ETXModel).toJSONString())
        sc.save { (err) in
            guard err == nil else {
                print("\(err)")
                return
            }
            print("\(sc.rawJson)")
            loginExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10000) {
            (err) in
            print("Login expectation timeout \(err)")
        }
    }
    
}
