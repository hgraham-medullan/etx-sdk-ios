//
//  StepsTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 4/4/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx

class StepsTests: AuthenticatedTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testCreatingAStepObject() {
        let stepSaveExpectation = expectation(description: "Save step obj")
        let steps: ETXSteps = ETXSteps()
        steps.stepCount = 120
        steps.date = Date()
        steps.source = ETXMeasurementSource(type: "the-type", measurementDevice: ETXMeasurementDevice(id: "the-id"))
        
        steps.save {
            (err: ETXError?) in
            XCTAssertNil(err, "Saving steps should not result in an error")
            XCTAssertNotNil(steps.id, "Saved step object should have an ID")
            stepSaveExpectation.fulfill()
        }
        
        waitForExpectations(timeout: ETXTestCase.TIMEOUT_DEFAULT) {
            err in
            print("\(err)")
        }
    }
}
