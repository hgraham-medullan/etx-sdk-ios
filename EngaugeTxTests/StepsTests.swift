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
        steps.steps = 120
        steps.date = Date()
        steps.source = ETXMeasurementSource(type: "the-type", device: ETXMeasurementDevice(deviceId: "the-id"))
        
        steps.save {
            (err: ETXError?) in
            XCTAssertNil(err, "Saving steps should not result in an error")
            XCTAssertNotNil(steps.id, "Saved step object should have an ID")
            stepSaveExpectation.fulfill()
        }
        
        waitForExpectations(timeout: self.TIMEOUT_DEFAULT) {
            err in
            print("\(err)")
        }
    }
    
    func testGettingASavedStepObject() {
        let fetchSaveExpectation = expectation(description: "Save step obj")
        let steps: ETXSteps = ETXSteps()
        steps.steps = 120
        steps.date = Date()
        steps.source = ETXMeasurementSource(type: "the-type", device: ETXMeasurementDevice(deviceId: "the-id"))
        
        steps.save {
            (err: ETXError?) in
            XCTAssertNil(err, "Saving steps should not result in an error")
            ETXSteps.findById(steps.id!) {
                (savedSteps, err) in
                XCTAssertNil(err, "Getting a saved steps object should not result in an eror")
                XCTAssertEqual(steps.steps, savedSteps?.steps, "Step count sent to the server should be returned when fetched")
                fetchSaveExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) {
            err in
            print("\(err)")
        }
    }
    
    func testGetAllSteps() {
        let getAllExpectation = expectation(description: "Save step obj")
        ETXSteps.findWhere(filter: ETXSearchFilter()) {
            (allSteps:[ETXSteps]?, err: ETXError?) in
            XCTAssertNil(err, "Getting all steps should not result in an error")
            XCTAssertTrue((allSteps?.count)!>0)
            getAllExpectation.fulfill()
        }
        
        waitForExpectations(timeout: self.TIMEOUT_DEFAULT) {
            err in
            print("\(err)")
        }
    }
}
