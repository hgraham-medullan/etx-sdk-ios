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
    
    
    
    func testGdoFind() {
        let findByIdExpectation = expectation(description: "findById Expectation")
        
        ETXGenericDataService.useCustomDataRepository(LocalGdoRepository.self, forModelType: MyGdo.self)
        
        MyGdo.findById("foo-id") {
            (myGdo, err) in
            XCTAssertNil(err)
            XCTAssertNotNil(myGdo)
            findByIdExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("findById Expectation \(String(describing: err))")
        }
    }
    
    func testGdoFindWhere() {
        let findByIdExpectation = expectation(description: "findById Expectation")
        ETXUserService.useCustomDataRepository(LocalUserRepository.self, forModelType: ETXUser.self)
        let app = EngaugeTxApplication.getInstance()
        let expected = String(describing: LocalUserRepository.self)
        let storedVal = app.customDataRepositories[String(describing: ETXUser.self)]!
        let actual = String(describing: storedVal)
        XCTAssertEqual(actual, expected)
        
        ETXUser.findWhere(filter: ETXSearchFilter()) {
            (items, err) in
            print ("AS")
            XCTAssertEqual(1, items?.count)
            XCTAssertEqual("blag", items?.first?.email)
            findByIdExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            
            print("findById Expectation \(String(describing: err))")
        }
        
    }
    
    func testTrends() {
        let findByIdExpectation = expectation(description: "findById Expectation")
        ETXTrendService.useCustomDataRepository(LocalTrendRepo.self)
        
        var classes = [ETXAggregatableModel.Type]()
        classes.append(ETXSteps.self)
        
        ETXTrendService.getTrend(startDate: Date(), endDate: Date(), classes: classes) {
            (res, err) in
            print("Got them")
            findByIdExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("findById Expectation \(String(describing: err))")
        }
        
    }
    
    func testFindStepsById() {
        let findByIdExpectation = expectation(description: "findById Expectation")
        ETXTrendService.useCustomDataRepository(LocalTrendRepo.self)
        
        
        ETXSteps.findById("") {
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

public class LocalGdoRepository<M: ETXGenericDataObject>: ETXCustomGenericObjectRepository<M> {
    override public func findById(_ id: String, completion: @escaping (M?, ETXError?) -> Void) {
        print("Using the custom repository for GDOs")
        completion(MyGdo() as! M, nil)
    }
}

class MyGdo: ETXGenericDataObject {
    var foo: String = "Hello"
}

class LocalTrendRepo: CustomTrendRepository {
    
    override func getAggregatedData(startDate: Date, endDate: Date, classes: [ETXAggregatableModel.Type], gdoConfig: ETXGenericDataObjectConfiguration?, forUser: ETXUser?, completion: @escaping (ETXTrendResultSet?, ETXError?) -> Void) {
        
        print(self.getHttpPath())
        completion(nil, nil)
    }
}

class LocalRepo<M:ETXModel>: ETXCustomRepository<M> {
    override func findById(_ id: String, completion: @escaping (M?, ETXError?) -> Void) {
        completion(nil, nil)
    }
}



