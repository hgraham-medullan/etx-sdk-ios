//
//  CustomFunctionTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 1/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper

class CustomFunctionTests: ETXTestCase {
    
    override func setUp() {
        super.setUp()
        
        let userSvc = ETXUserService()
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
    
    func testGetAuthenticatedUrlWhenAnAccessTokenIsAvailable() {
        let customFunctionName = "report-download"
        let cf = (ETXCustomFunction(functionName: customFunctionName))!
        
        let repo = Repository<ETXModel>(resourcePath: "/")
        let accessToken = repo.getAccessToken()
        
        XCTAssertNotNil(accessToken, "Access Token should not be nil")
        
        let urlString: String = "\(EngaugeTxApplication.baseUrl!)/run/\(customFunctionName)"
            + "?accessToken=\(accessToken!)"
            + "&appId=\(EngaugeTxApplication.appId!)"
            + "&clientKey=\(EngaugeTxApplication.clientKey!)"
        
        let url = URL(string: urlString)
        XCTAssertEqual(url!, cf.getAuthenticatedUrl())
    }
    
    func testGetAuthenticatedUrlWhenAnAccessTokenIsNotAvailable() {
        let customFunctionName = "report-download"
        let cf = (ETXCustomFunction(functionName: customFunctionName))!
        
        let repo = Repository<ETXModel>(resourcePath: "/")
        repo.deleteAccessToken()
        let x = cf.getAuthenticatedUrl()
        
        if (x != nil) {
            print("Gotcha")
        }
        
        XCTAssertEqual(nil, x)
    }
    
    func testPerformGet() {
        let getExpectation = expectation(description: "Get req on custom function")
        let cf = ETXCustomFunction(functionName: "get-test")
        
        cf?.performGet {
            (model, err) in
            XCTAssertNotNil(err)
            XCTAssertEqual(404, err?.statusCode!)
            getExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            err in
            print("\(err)")
        }
    }
    
    func testPerformPost() {
        let customFunctionPostExpectation = expectation(description: "Get req on custom function")
        let cf = ETXCustomFunction(functionName: "post-test")
        
        cf?.performPost(model: ETXModel()) {
            (model, err) in
            XCTAssertNotNil(err)
            XCTAssertEqual(404, err?.statusCode!)
            customFunctionPostExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            err in
            print("\(err)")
        }
    }
    
    func testIsValidFunctionNameWhenTheFunctionNameIsValid() {
        let urlPrefix = "/run/"
        XCTAssertTrue(ETXCustomFunction.isValidFunctionName("funcname", urlPrefix: urlPrefix))
        XCTAssertTrue(ETXCustomFunction.isValidFunctionName("func-name", urlPrefix: urlPrefix))
        XCTAssertTrue(ETXCustomFunction.isValidFunctionName("func_name", urlPrefix: urlPrefix))
        XCTAssertTrue(ETXCustomFunction.isValidFunctionName("func/name", urlPrefix: urlPrefix))
    }
    
    func testIsValidFunctionNameWhenTheFunctionNameIsNotValid() {
        let urlPrefix = "/run/"
        XCTAssertFalse(ETXCustomFunction.isValidFunctionName("func\name", urlPrefix: urlPrefix))
        XCTAssertFalse(ETXCustomFunction.isValidFunctionName("func name", urlPrefix: urlPrefix))
    }
    
    func testAddQueryStringsWhenThereIsNoQueryString() {
        let resourcePath = "/test"
        let functionName = "test"
        
        let repo = Repository(resourcePath: resourcePath)
        let expectedRepo = Repository(resourcePath: resourcePath)
        let customFunction = (ETXCustomFunction(functionName: functionName))!
        
        customFunction.addQueryStrings(nil, toResource: &repo.etxResource)
        
        XCTAssertEqual(expectedRepo.etxResource.url, repo.etxResource.url)
    }
    
    func testAddQueryStringsWhenThereIsAQueryString() {
        let resourcePath = "/test"
        let functionName = "test"
        let pageQueryName = "page"
        let pageQueryValue = "2"
        
        let repo = Repository(resourcePath: resourcePath)
        let expectedRepo = Repository(resourcePath: resourcePath)
        let customFunction = (ETXCustomFunction(functionName: functionName))!
        
        expectedRepo.etxResource = expectedRepo.etxResource.withParam(pageQueryName, pageQueryValue)
        
        customFunction.addQueryStrings([pageQueryName: pageQueryValue], toResource: &repo.etxResource)
        
        XCTAssertEqual(expectedRepo.etxResource.url, repo.etxResource.url)
    }
    
    
    class MyComplexObject: ETXModel {
        //let
        override func mapping(map: Map) {
          super.mapping(map: map)
        }
    }
    
}
