//
//  GenericDataServiceTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/15/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper

class GenericDataServiceTests: ETXTestCase {
    
    class Vital: ETXGenericDataObject {
        var reading: Double?
    
        override func mapping(map: Map) {
            super.mapping(map: map)
            reading <- map["reading"]
        }
    }
    
    class VitalService: ETXGenericDataService<Vital> { }
    
    var sampleVital: Vital!
    var userSvc: ETXUserService<ETXUser>!
    var vitalSvc: VitalService!
    
    override func setUp() {
        super.setUp()
        
        vitalSvc = VitalService()
        sampleVital = Vital()
        sampleVital.reading = 173.4
        
        userSvc = ETXUserService()
        let loginExpectation = expectation(description: "Successful Login")
        userSvc.loginUserWithEmail("sean@medullan.com", password: "P@ssw0rd", rememberMe: false) {
            (user, err) in
            loginExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 20) {
            (err) in
            print("Login expectation timeout \(err)")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        userSvc.logout {
            print("logged user out")
        }
    }
    
    
    class GenericObjectWithDefaultModelName: ETXGenericDataObject { }
    
    func testGenericObjectWithDefaultModelName() {
        
        let expectedClassName = "GenericObjectWithDefaultClassName"
        XCTAssertEqual(expectedClassName, GenericObjectWithDefaultModelName.modelName)
    }
    
    class GenericObjectWithCustomModelName: ETXGenericDataObject {
        override class var modelName: String {
            return "CustomModel"
        }
    }
    
    func testGenericObjectWithCustomModelName() {
        let className = "CustomModel"
        XCTAssertEqual(className, GenericObjectWithCustomModelName.modelName)
    }
    
    func testGenericDataObjectCreation() {
        
        let vitalExpectation = expectation(description: "Successful vital")
        let v = Vital()
        v.reading = 200
        v.save(){
            (err) in
            XCTAssertNotNil(v.id)
            XCTAssertEqual(v.reading, 200)
            XCTAssertNil(err, "Should not result in an error")
            vitalExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("User login call failed: \(error)")
            }
        }
    }
    
    func testGetGenericDataObjectById() {
        let getVitalExpectation = expectation(description: "Get a vital by ID")
        let saveVitalExpectation = expectation(description: "Save a vital")
        
        let vitalReading: Double = 200
        let v = Vital()
        v.reading = vitalReading
        
        v.save {
            (err) in
            let vitalId = v.id
            saveVitalExpectation.fulfill()
            
            Vital.findById(vitalId!) {
                (vital, err) in
                XCTAssertNotNil(vital)
                XCTAssertEqual(vitalId, vital?.id)
                XCTAssertEqual(vitalReading, v.reading)
                getVitalExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Failed while retrieving the vital: \(error)")
            }
        }
    }
    
    
    func testUpdateGenericDataObject() {
        let updateVitalExpectation = expectation(description: "Update a vital by ID")
        let saveVitalExpectation = expectation(description: "Save a vital")
        
        let vitalReading: Double = 200
        let v = Vital()
        v.reading = vitalReading
        
        v.save {
            (err) in
            saveVitalExpectation.fulfill()
            XCTAssertEqual(vitalReading, v.reading)
            let newReading: Double = 240
            v.reading = newReading
            
            v.save {
                (err) in
                XCTAssertEqual(newReading, v.reading)
                updateVitalExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Failed while retrieving the vital: \(error)")
            }
        }
    }
    
    func testDeleteGenericDataObjectById() {
        let saveVitalExpectation = expectation(description: "Save a vital")
        let deleteVitalExpectation = expectation(description: "Delete a vital by ID")
        let findVitalExpectation = expectation(description: "Find a vital by ID")
        
        let v = Vital()
        
        v.save {
            (err) in
            let vitalId: String = v.id!
            
            saveVitalExpectation.fulfill()
            
            v.delete {
                (err) in
                XCTAssertNil(err, "Should not error when deleting a valid item")
                deleteVitalExpectation.fulfill()
                
                Vital.findById(vitalId) {
                    (vital, err) in
                    XCTAssertNil(vital)
                    XCTAssertNotNil(err)
                    XCTAssertEqual(404, err?.statusCode)
                    findVitalExpectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Failed while deleting the vital: \(error)")
            }
        }
    }
    
    func testDeleteGenericDataObjectByIdWhenTheObjectDoesNotExist() {
        let deleteVitalExpectation = expectation(description: "Delete a vital by ID")
        let vitalId = "non-existent-resource"
        
        let vital = Vital()
        vital.id = vitalId
        
        vital.delete {
            (err) in
            XCTAssertNotNil(err, "Should error when deleting a non-existent item")
            XCTAssertEqual(404, err?.statusCode)
            deleteVitalExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Failed while deleting the vital: \(error)")
            }
        }
    }

    func testGetAllGenericDataObject() {
        let getAllVitalsExpectation = expectation(description: "Get all vitals")
        let saveVitalExpectation = expectation(description: "Save a vital")
        
        vitalSvc.save(model: sampleVital) {
            (vital, err) in
            saveVitalExpectation.fulfill()
            
            self.vitalSvc.findAll {
                (vitals, err) in
                XCTAssertNil(err)
                XCTAssertNotNil(vitals)
                XCTAssertTrue((vitals?.count)!>=1, "Vitals collection should contain atleast 1 item")
                getAllVitalsExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Failed while deleting the vital: \(error)")
            }
        }
    }
    
    func testModelNameValidatorWhenClassNameIsValid() {
        XCTAssertTrue(ETXGenericDataService.isValidClassName("ValidClassName"))
        XCTAssertTrue(ETXGenericDataService.isValidClassName("ValidClassName1"))
        XCTAssertTrue(ETXGenericDataService.isValidClassName("validClassName"))
        XCTAssertTrue(ETXGenericDataService.isValidClassName("Valid_Class_Name"))
    }
    
    func testModelNameValidatorWhenClassNameIsInvalid() {
        XCTAssertFalse(ETXGenericDataService.isValidClassName("1InvalidClassName"))
        XCTAssertFalse(ETXGenericDataService.isValidClassName("Invalid-ClassName"))
        XCTAssertFalse(ETXGenericDataService.isValidClassName(""))
        XCTAssertFalse(ETXGenericDataService.isValidClassName(" "))
        XCTAssertFalse(ETXGenericDataService.isValidClassName(" Invalid-ClassName"))
        XCTAssertFalse(ETXGenericDataService.isValidClassName("Invalid.ClassName"))
    }
    
    func testX() {
        class Hgfj: ETXGenericDataObject {
        }
        //XCTAssertEqual("Hgfj", Hgfj.getModelName())
    }

    func testY() {
        //typealias FG = type(of: z())
        //print(type(of: z()))
        //XCTAssertEqual("z", z.modelName)
    }
}
    
