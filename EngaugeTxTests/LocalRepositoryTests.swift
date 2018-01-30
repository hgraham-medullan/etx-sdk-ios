//
//  LocalRepositoryTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 10/17/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper

class LocalRepositoryTests: ETXTestCase {
    
    override func tearDown() {
        super.tearDown()
        EngaugeTxApplication.clearCustomRepositories()
        XCTAssertFalse(EngaugeTxApplication.isUsingCustomRepsoitories())
    }
    
    func testFindStepsById() {
        let findByIdExpectation = expectation(description: "findById Expectation")
        ETXDataService.useCustomDataRepository(LocalRepo.self, forModelType: ETXPersistedModel.self)
        ETXSteps.findById("local-id") {
            (steps, err) in
            XCTAssertNil(err, "The error object should be nil")
            XCTAssertNotNil(steps, "A steps object should be returned")
            XCTAssertEqual(10000, steps?.steps, "The steps count should match what is returned from the local repository")
            findByIdExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("findById Expectation \(String(describing: err))")
        }
        
    }
    
    func testSaveStep() {
        let saveStepExpectation = expectation(description: "saveStep Expectation")
        ETXDataService.useCustomDataRepository(LocalRepo.self, forModelType: ETXPersistedModel.self)
        
        let steps = ETXSteps()
        steps.duration = 20
        
        steps.save {
            (err) in
            XCTAssertNil(err, "The steps should be saved successfully")
            XCTAssertEqual(steps.id, "steps-id", "The steps object should be assigned an ID")
            XCTAssertEqual(steps.duration, 20, "The steps duration should be '20'")
            saveStepExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("saveStep Expectation \(String(describing: err))")
        }
        
    }
}




class MyGdo: ETXGenericDataObject {
    var foo: String = "Hello"
}

class LocalRepo<M:ETXSteps>: ETXCustomRepository<M> {
    override func findById(_ id: String, completion: @escaping (M?, ETXError?) -> Void) {
        super.findById(id, completion:completion)
        
        let localModel = ETXSteps()
        localModel.id = "local-model"
        localModel.steps = 10000
        completion(localModel as? M, nil)
        
    }
    
    override func save(model: M, completion: @escaping (M?, ETXError?) -> Void) {
        super.save(model: model, completion: completion)
        model.id = "steps-id"
        completion(model, nil)
    }
    
    override func provideInstance<T>(resourcePath: String) -> Repository<T>? where T : ETXSteps {
        return LocalRepo<T>(resourcePath: "/steps") as Repository<T>
    }
}






