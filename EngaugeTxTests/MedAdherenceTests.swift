//
//  MedAdherenceTests.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/24/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
//import ObjectMapper

class MedAdherenceTests: AuthenticatedTestCase {
    
    let medicationId = "dulera_20"
    var prescription: ETXPrescription!
    
    override func setUp() {
        super.setUp()
        prescription = ETXPrescription();
        prescription.description = "100 mcg/5 mcg, 2 inhalations twice daily"
        prescription.medicationId = medicationId
        prescription.route = "oral"
        prescription.device = ETXMeasurementDevice(deviceId: "device-id")
        prescription.effectivePeriod = ETXEffectivePeriod(startDate: Date(), endDate: nil)
        
        let dosage1 = ETXPrescriptionDosage();
        dosage1.asNeeded = false
        dosage1.dose = ETXDose(value: 2, unit: "puff")
        
        dosage1.timing = ETXTiming()
        dosage1.timing!.repeat = ETXDosageFrequency(frequency: 2, period: 1, periodUnit: "d")
        dosage1.timing!.usages = [ETXUsage(label: "morning", doses: 1, tod: "9:00am"),
                                  ETXUsage(label: "evening", doses: 1, tod: "7:00pm")]
        
        prescription.dosage = [dosage1]
        
        let prescriptionDeletionExpectation = expectation(description: "Deletion of prescription")
        prescription.save {
            err in
            XCTAssertNil(err, "Prescription save should not fail")
            prescriptionDeletionExpectation.fulfill()
        }
        waitForExpectations(timeout: self.TIMEOUT_DEFAULT) {
            (err) in
            print("prescriptionDeletionExpectation expectation timeout \(err)")
        }
        // Create the prescription
    }
    
    override func tearDown() {
        super.tearDown()
        let prescriptionDeletionExpectation = expectation(description: "Deletion of prescription")
        prescription.delete {
            err in
            XCTAssertNil(err, "Prescription deletion should not fail")
            prescriptionDeletionExpectation.fulfill()
        }
        waitForExpectations(timeout: self.TIMEOUT_DEFAULT) {
            (err) in
            print("prescriptionDeletionExpectation expectation timeout \(err)")
        }
    }
    
    func testGetMedicationAdherence() {
        let testExpectation = expectation(description: "Successful testGetAdherenceforUnAffiliatedUser")
        
        ETXAdherenceService.getAdherence(trendTimeframe: ETXTrendTimeframe.TwoWeeks){
            (model, err) in
            XCTAssertNil(err)
            XCTAssertNotNil(model)
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 20) {
            (err) in
            print("testGetAdherenceforUnAffiliatedUser expectation timeout \(err)")
        }
    }
    
    func testGetAdherenceforUnAffiliatedUser(){
        let testExpectation = expectation(description: "Successful testGetAdherenceforUnAffiliatedUser")
        
        ETXAdherenceService.getAdherence(medicationId: "dulera_20", trendTimeframe: ETXTrendTimeframe.TwoWeeks){
            (model, err) in
            XCTAssertNil(err)
            XCTAssertNotNil(model)
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 20) {
            (err) in
            print("testGetAdherenceforUnAffiliatedUser expectation timeout \(err)")
        }
    }
    
    func xtestGetAdherenceforAffiliatedUser(){
        let testExpectation = expectation(description: "Successful testGetAdherenceforAffiliatedUser")
        let patientUser = ETXUser()
        patientUser.id = "12345"
        
        ETXAdherenceService.getAdherence(medicationId: "rescue_300", trendTimeframe: ETXTrendTimeframe.TwoWeeks, forUser: patientUser){
            (model, err) in
            XCTAssertNil(err)
            XCTAssertNotNil(model)
            print("\(model?[0].rawJson)")
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 20) {
            (err) in
            print("testGetAdherenceforUnAffiliatedUser expectation timeout \(err)")
        }
    }
    
}
