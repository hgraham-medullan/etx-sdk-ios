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

    func testFindStepsById() {
        let findByIdExpectation = expectation(description: "findById Expectation")
        ETXDataService.useCustomDataRepository(LocalRepo.self, forModelType: ETXPersistedModel.self)
        
        
        ETXSteps.findById("xcvbnm") {
            (res, err) in
            print(res)
            findByIdExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("findById Expectation \(String(describing: err))")
        }
        
    }
    
    func testFindGdoId() {
        let findByIdExpectation = expectation(description: "findById Expectation")
        ETXDataService.useCustomDataRepository(LocalRepo.self, forModelType: ETXPersistedModel.self)
        
        
        ETXIndoorAirQuality.findById("xcvbnm") {
            (res, err) in
            print(res)
            findByIdExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("findById Expectation \(String(describing: err))")
        }
        
    }
    
    
    
}

public class LocalUserRepository<M: ETXUser>: ETXCustomUserRepository<M> {
    override public func findWhere(_ filter: ETXSearchFilter, completion: @escaping ([M]?, ETXError?) -> Void) {
        super.findWhere(filter, completion: completion)
        let path = self.getHttpPath()
        var users = [ETXUser]()
        users.append(ETXUser(email: "blag", username: "user", password: "pwd"))
        completion(users as! [M], nil)
        print("this is it")
    }
    
}



class MyGdo: ETXGenericDataObject {
    var foo: String = "Hello"
}

class LocalRepo<M:ETXPersistedModel>: ETXCustomRepository<M> {
    override func findById(_ id: String, completion: @escaping (M?, ETXError?) -> Void) {
        super.findById(id, completion:completion)
        
        print(self.getHttpPath())
        let localModel = ETXIndoorAirQuality()
        localModel.id = "local-model"
        if self.getHttpPath() == "/steps" {
            
            completion(localModel as! M, nil)
        } else {
            completion(localModel as! M, nil)
        }
    }
}






