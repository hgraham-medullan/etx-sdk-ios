//
//  CustomStandaloneFunctionRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 10/25/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper

class CustomStandaloneFunctionRepository: ETXTestCase {
    
    override func tearDown() {
        super.tearDown()
        EngaugeTxApplication.clearCustomRepositories()
    }
    
    func testGetRequestWhenUsingCustomStandaloneFunctionRepository() {
        let getReqExpectation = expectation(description: "getReq Expectation")
        ETXCustomFunction.useCustomRepository(repositoryType: LocalSfRepo<ETXModel>.self)
        
        ETXCustomFunction(functionName: "get-func")?.performGet() {
            (res, err) in
            XCTAssertEqual("model-resp-standalone-function", res?.id)
            getReqExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("findById Expectation \(String(describing: err))")
        }
        
    }
    
    func testPostRequestWhenUsingCustomStandaloneFunctionRepository() {
        let getReqExpectation = expectation(description: "findById Expectation")
        ETXCustomFunction.useCustomRepository(repositoryType: LocalSfRepo.self)
        
        let modelToPost = MyGdo()
        modelToPost.id = "model-to-post-to-standalone-func"
        ETXCustomFunction<MyGdo>(functionName: "post-func")!.performPost(model: modelToPost) {
            (res, err) in
            XCTAssertEqual("model-resp-standalone-function", res?.id)
            getReqExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("findById Expectation \(String(describing: err))")
        }
        
    }
}

class LocalSfRepo<M: ETXModel>: ETXCustomStandaloneFunctionRepository<M> {
    
    private let defaultSfResp: M = MyGdo() as! M
    
    required init(resourcePath: String) {
        super.init(resourcePath: resourcePath)
        defaultSfResp.id = "model-resp-standalone-function"
    }
    
    override public func post(model: M, completion: @escaping (M?, ETXError?) -> Void) {
        super.post(model:model, completion: completion)
        XCTAssertEqual("/run/post-func", self.getHttpPath())
        XCTAssertEqual("model-to-post-to-standalone-func", model.id!)
        completion(self.defaultSfResp, nil)
    }
    
    override public func get(completion: @escaping (M?, ETXError?) -> Void) {
        super.get(completion: completion)
        XCTAssertEqual("/run/get-func/", self.getHttpPath())
        completion(self.defaultSfResp, nil)
    }
    
    private var store: [M] = [M]()
    
    override func provideInstance<T>(resourcePath: String) -> Repository<T> where T : ETXModel {
        return LocalSfRepo<T>(resourcePath: resourcePath)
    }
    
    
    
}
