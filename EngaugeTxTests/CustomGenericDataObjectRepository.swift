//
//  CustomGenericDataObjectRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 10/25/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper

class CustomGenericDataObjectRepository: ETXTestCase {
    
    override func tearDown() {
        super.tearDown()
        EngaugeTxApplication.clearCustomRepositories()
        XCTAssertFalse(EngaugeTxApplication.isUsingCustomRepsoitories())
    }
    
    func testFindByIdWithCustomRepositoryForGDOs() {
        let findByIdExpectation = expectation(description: "findById Expectation")
        ETXGenericDataService.useCustomDataRepository(LocalGdoRepository<ETXGenericDataObject>.self, forModelType: ETXGenericDataObject.self)
        
        MyGdo.findById("foo-id") {
            (myGdo, err) in
            XCTAssertNil(err, "The error should be nil")
            XCTAssertNotNil(myGdo, "It should return a GDO")
            XCTAssertEqual("gdo-from-custom-repo", myGdo?.id, "The ID of the GDO should match the GDO from the custom repository")
            findByIdExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("findById Expectation \(String(describing: err))")
        }
    }
    
    func testFindByIdWithCustomRepositoryForGDOs2() {
        let findByIdExpectation = expectation(description: "findById Expectation")
        ETXGenericDataService.useCustomDataRepository(LocalGdoRepository<MyGdo>.self, forModelType: MyGdo.self)
        
        MyGdo.findById("foo-id") {
            (myGdo, err) in
            XCTAssertNil(err, "The error should be nil")
            XCTAssertNotNil(myGdo, "It should return a GDO")
            XCTAssertEqual("gdo-from-custom-repo", myGdo?.id, "The ID of the GDO should match the GDO from the custom repository")
            findByIdExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("findById Expectation \(String(describing: err))")
        }
    }
    
    func testGdoFindWhere() {
        let findByIdExpectation = expectation(description: "findWhere Expectation")
        ETXGenericDataService.useCustomDataRepository(LocalGdoRepository.self, forModelType: MyGdo.self)
        
        MyGdo.findWhere(filter: ETXSearchFilter()) {
            (items, err) in
            XCTAssertEqual(1, items?.count, "One result should be return")
            XCTAssertEqual(items?.first?.id, "gdo-from-custom-repo", "The return result should have 'gdo-from-custom-repo' as the ID")
            findByIdExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("findById Expectation \(String(describing: err))")
        }
    }
    
    func testGdoSaveForNewModelWhenUsingTheBaseTypeWithTheCustomRepository() {
        let saveExpectation = expectation(description: "save Expectation")
        ETXGenericDataService.useCustomDataRepository(LocalGdoRepository.self, forModelType: MyGdo.self)
        
        let gdoToSave = MyGdo();
        gdoToSave.foo = "This is foo"
        gdoToSave.save {
            (err) in
            XCTAssertNil(err, "The GDO should save successfully")
            XCTAssertNotNil(gdoToSave, "The saved object should not be nil")
            XCTAssertEqual(gdoToSave.foo, "This is foo", "The 'foo' property should be set")
            XCTAssertEqual(gdoToSave.id, "model-saved", "The model should be assigned an ID")
            saveExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("save Expectation \(String(describing: err))")
        }
    }
    
    func testGdoSaveForNewModel() {
        let saveExpectation = expectation(description: "save Expectation")
        ETXGenericDataService.useCustomDataRepository(LocalGdoRepository.self, forModelType: ETXGenericDataObject.self)
        
        let gdoToSave = MyGdo();
        gdoToSave.foo = "This is foo"
        gdoToSave.save {
            (err) in
            XCTAssertNil(err, "The GDO should save successfully")
            XCTAssertNotNil(gdoToSave, "The saved object should not be nil")
            XCTAssertEqual(gdoToSave.foo, "This is foo", "The 'foo' property should be set")
            XCTAssertEqual(gdoToSave.id, "model-saved", "The model should be assigned an ID")
            saveExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("save Expectation \(String(describing: err))")
        }
    }
}

public class LocalGdoRepository<M: ETXGenericDataObject>: ETXCustomGenericObjectRepository<M> {
    
    private var defaultGdoResp:M = MyGdo() as! M
    
    required public init(resourcePath: String) {
        super.init(resourcePath: resourcePath)
        defaultGdoResp.id = "gdo-from-custom-repo"
    }
    
    override public func findById(_ id: String, completion: @escaping (M?, ETXError?) -> Void) {
        super.findById(id, completion: completion)
        completion(self.defaultGdoResp, nil)
    }
    
    public override func findWhere(_ filter: ETXSearchFilter, completion: @escaping ([M]?, ETXError?) -> Void) {
        super.findWhere(filter, completion: completion)
        var resp:[M] = [M]()
        resp.append(self.defaultGdoResp as M)
        completion(resp, nil)
    }
    
    public override func provideInstance<T>(resourcePath: String) -> Repository<T>? where T : ETXGenericDataObject {
        return LocalGdoRepository<T>(resourcePath:resourcePath)
    }
    
    open override func save(model: M, completion: @escaping (M?, ETXError?) -> Void) {
        super.save(model: model, completion: completion)
        model.id = "model-saved"
        completion(model, nil)
    }
    
    
}
