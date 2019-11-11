//
//  CaregiverTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 4/28/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx

class CaregiverTests: AffiliationTestCase {
    
    var affiliatedPatient: ETXUser!
    
    override func setUp() {
        super.setUp()
        self.loginAsCaregiver()
        getAffiliatedPatient()
    }
    
    func getAffiliatedPatient() {
        let getAffiliatedUsersExpectation = expectation(description: "Successful get affiliated users")
        
        let service = ETXAffiliationService()
        service.getAffiliatedUsers(withRole: ETXRole.patient, forMyRole: ETXRole.caregiver){
            (affiliatedUsers, err) in
            if let affiliatedUsers = affiliatedUsers {
                XCTAssertTrue(affiliatedUsers.count > 0, "The user is not affiliated with any users")
                self.affiliatedPatient = affiliatedUsers[0]
            } else {
                XCTFail("The user is not affiliated with any users")
            }
            getAffiliatedUsersExpectation.fulfill()
        }
        waitForExpectations(timeout: 20) {
            (err) in
            print("GetAffiliatedUsers expectation timeout \(err)")
        }
    }
    
    func testGetAffiliatedUsers() {
        let getAffiliatedUsersExpectation = expectation(description: "Successful get affiliated users")
        
        let service = ETXAffiliationService()
        service.getAffiliatedUsers(withRole: ETXRole.patient, forMyRole: ETXRole.caregiver){
            (affiliatedUsers, err) in
            if let affiliatedUsers = affiliatedUsers {
                XCTAssertTrue(affiliatedUsers.count > 0, "The user is not affiliated with any users")
                let patient = affiliatedUsers[0]
                XCTAssertNotNil(patient)
            } else {
                XCTFail("The user is not affiliated with any users")
            }
            getAffiliatedUsersExpectation.fulfill()
        }
        waitForExpectations(timeout: 20) {
            (err) in
            print("GetAffiliatedUsers expectation timeout \(err)")
        }
    }
    
    func testGetTrendDataForPatient() {
        let getAffiliatedUsersExpectation = expectation(description: "Trend result for patient")
        ETXTrendService.getTrend(trendTimeframe: .TwoWeeks, classes: [ETXSteps.self], forUser: self.affiliatedPatient) {
            (resultSet, err) in
            XCTAssertNil(err)
            getAffiliatedUsersExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("GetAffiliatedUsers expectation timeout \(err)")
        }
    }
    
    func testFindStepsForPatientUsingCustomWhereFilter() {
        let steps = ETXSteps(owner: self.affiliatedPatient)
        steps.steps = 500
        steps.date = Date()
        let source = ETXMeasurementSource()
        source.device = ETXMeasurementDevice(deviceId: "device-001")
        steps.source = source
        let saveReqExpectation = expectation(description: "Save steps for patient")
        steps.save {
            (err) in
            XCTAssertNil(err, "The steps should be saved successfully")
            XCTAssertNotNil(steps.id, "The saved steps should be assigned an id")
            XCTAssertEqual(self.affiliatedPatient.id, steps.ownerId, "The saved steps should belong to the patient")
            
            let stepCountFilter = ETXSearchFilter(customFilter: "{\"where\":{\"steps\":500}}")
            
            ETXSteps.findWhere(filter: stepCountFilter, onBehalfOfUser: self.affiliatedPatient) {
                (queriedSteps, err) in
                XCTAssertNotNil(queriedSteps, "The steps should be returned")
                XCTAssertTrue(queriedSteps!.count > 1, "There should be atleast one returned result")
                XCTAssertEqual(queriedSteps?.first!.ownerId, self.affiliatedPatient.id, "The steps should belong to the patient")
                XCTAssertNil(err, "The steps belonging to the patient should be returned successfully")
                saveReqExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("GetAffiliatedUsers expectation timeout \(err)")
        }
    }
    
    func testFindStepsForPatient() {
        let steps = ETXSteps(owner: self.affiliatedPatient)
        steps.steps = 500
        steps.date = Date()
        let source = ETXMeasurementSource()
        source.device = ETXMeasurementDevice(deviceId: "device-001")
        steps.source = source
        let saveReqExpectation = expectation(description: "Save steps for patient")
        steps.save {
            (err) in
            XCTAssertNil(err, "The steps should be saved successfully")
            XCTAssertNotNil(steps.id, "The saved steps should be assigned an id")
            XCTAssertEqual(self.affiliatedPatient.id, steps.ownerId, "The saved steps should belong to the patient")
            
            let stepsCondition = ETXWhereCondition(property: "steps", comparator: .eq, value: 500)
            let stepCountFilter = ETXSearchFilter(condition: stepsCondition)
            
            ETXSteps.findWhere(filter: stepCountFilter, onBehalfOfUser: self.affiliatedPatient) {
                (queriedSteps, err) in
                XCTAssertNotNil(queriedSteps, "The steps should be returned")
                XCTAssertTrue(queriedSteps!.count > 1, "There should be atleast one returned result")
                XCTAssertEqual(queriedSteps?.first!.ownerId, self.affiliatedPatient.id, "The steps should belong to the patient")
                XCTAssertNil(err, "The steps belonging to the patient should be returned successfully")
                saveReqExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("GetAffiliatedUsers expectation timeout \(err)")
        }
    }
    
    func testFindStepsByIdForPatient() {
        let steps = ETXSteps(owner: self.affiliatedPatient)
        steps.steps = 500
        steps.date = Date()
        let source = ETXMeasurementSource()
        source.device = ETXMeasurementDevice(deviceId: "device-001")
        steps.source = source
        let saveReqExpectation = expectation(description: "Save steps for patient")
        steps.save {
            (err) in
            XCTAssertNil(err, "The steps should be saved successfully")
            XCTAssertNotNil(steps.id, "The saved steps should be assigned an id")
            XCTAssertEqual(self.affiliatedPatient.id, steps.ownerId, "The saved steps should belong to the patient")
            
            ETXSteps.findById(steps.id!, onBehalfOfUser: self.affiliatedPatient) {
                (queriedStep, err) in
                XCTAssertNotNil(queriedStep, "The steps should be returned")
                XCTAssertEqual(queriedStep?.ownerId, self.affiliatedPatient.id, "The steps should belong to the patient")
                XCTAssertNil(err, "The steps belonging to the patient should be returned successfully")
                saveReqExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("GetAffiliatedUsers expectation timeout \(err)")
        }
    }
    
    func testSaveStepsForPatient() {
        let steps = ETXSteps(owner: self.affiliatedPatient)
        steps.steps = 500
        steps.date = Date()
        let source = ETXMeasurementSource()
        source.device = ETXMeasurementDevice(deviceId: "device-001")
        steps.source = source
        let saveReqExpectation = expectation(description: "Save steps for patient")
        steps.save {
            (err) in
            XCTAssertNil(err, "The steps should be saved successfully")
            XCTAssertNotNil(steps.id, "The saved steps should be assigned an id")
            XCTAssertEqual(self.affiliatedPatient.id, steps.ownerId, "The saved steps should belong to the patient")
            
            ETXSteps.findById(steps.id!) {
                (queriedStep, err) in
                XCTAssertNil(queriedStep, "The steps should not returned when searching for steps that belong to the caregiver")
                XCTAssertNotNil(err, "The steps should not be found as an item owned by the caregiver")
                XCTAssertEqual(err?.statusCode, 404, "The resource should not be found")
                saveReqExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("GetAffiliatedUsers expectation timeout \(err)")
        }
    }
    
    func testSaveGdoForPatient() {
        let saveReqExpectation = expectation(description: "Save vital for patient")
        let vital = Vital(owner: self.affiliatedPatient)
        vital.level = 3.6
        
        vital.save {
            (err) in
            XCTAssertNil(err, "The vital should be saved successfully")
            XCTAssertNotNil(vital.id, "The saved vital should be assigned an id")
            XCTAssertEqual(self.affiliatedPatient.id, vital.ownerId, "The saved vital should belong to the patient")
            
            Vital.findById(vital.id!) {
                (queriedVital, err) in
                XCTAssertNil(queriedVital, "The vital should not returned when searching for steps that belong to the caregiver")
                XCTAssertNotNil(err, "The vital should not be found as an item owned by the caregiver")
                XCTAssertEqual(err?.statusCode, 404, "The resource should not be found")
                saveReqExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("saveReqExpectation expectation timeout \(err)")
        }
    }
    
    func testSaveIndoorAirQualityForPatient() {
        let saveReqExpectation = expectation(description: "Save steps for patient")
        let indoorAQ = ETXIndoorAirQuality(owner: self.affiliatedPatient)
        let source = ETXMeasurementSource()
        source.device = ETXMeasurementDevice(deviceId: "device-001")
        indoorAQ.source = source
        indoorAQ.location = ETXCoords(lat: 12.11, lon: 10.12)
        indoorAQ.humidity = 20.4
        indoorAQ.voc = 20
        indoorAQ.pm25 = 25
        indoorAQ.aqi = 34.3
        indoorAQ.temp = 32
        indoorAQ.date = Date()
        indoorAQ.save {
            (err) in
            XCTAssertNil(err)
            XCTAssertEqual(indoorAQ.ownerId, self.affiliatedPatient.id, "The savedobject should belong to the affiliated user")
            
            ETXIndoorAirQuality.findById(indoorAQ.id!) {
                (queriedStep, err) in
                XCTAssertNil(queriedStep, "The indoor air quality should not returned when searching for steps that belong to the caregiver")
                XCTAssertNotNil(err, "The indoor air quality should not be found as an item owned by the caregiver")
                XCTAssertEqual(err?.statusCode, 404, "The resource should not be found")
                saveReqExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("GetAffiliatedUsers expectation timeout \(err)")
        }
    }
}

class Vital: ETXGenericDataObject {
    var level: Float = 2.5
}
