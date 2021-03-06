//
//  RepositoryTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 9/17/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper

class RepositoryTests: ETXTestCase {
    
    func testWhenIgnoreAccessTokenIsSetToTheDefaultValue() {
        let reqExpectation = expectation(description: "Request Expectation")
        let repo = Repository(resourcePath: "/non-existent-path")
        AccesssTokenCache.tokenCached = true
        AccesssTokenCache.accessToken = "a-dummy-token"
        
        repo.getById("") { (data, err) in
            reqExpectation.fulfill()
            XCTAssertNotNil(err, "An error should occur for a request with an invalid access token")
            XCTAssertEqual(err!.statusCode, 401, "The request should be unauthorized when an invalid access token is set")
            XCTAssertNotNil(repo.etxResource.configuration.headers["Authorization"], "The access token should be set")
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("Request Expectation \(String(describing: err))")
        }
    }
    
    func testWhenIgnoreAccessTokenIsFalse() {
        let reqExpectation = expectation(description: "Request Expectation")
        let repo = Repository(resourcePath: "/non-existent-path")
        AccesssTokenCache.tokenCached = true
        AccesssTokenCache.accessToken = "a-dummy-token"
        repo.ignoreAccessToken = false
        
        repo.getById("") { (data, err) in
            reqExpectation.fulfill()
            XCTAssertNotNil(err, "An error should occur for a request with an invalid access token")
            XCTAssertEqual(err!.statusCode, 401, "The request should be unauthorized when an invalid access token is set")
            XCTAssertNotNil(repo.etxResource.configuration.headers["Authorization"], "The access token should be set")
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("Request Expectation \(String(describing: err))")
        }
    }
    
    func testWhenIgnoreAccessTokenIsTrue() {
        let reqExpectation = expectation(description: "Request Expectation")
        let repo = Repository(resourcePath: "/non-existent-path")
        AccesssTokenCache.tokenCached = true
        AccesssTokenCache.accessToken = "a-dummy-token"
        repo.ignoreAccessToken = true
        
        repo.getById("") { (data, err) in
            reqExpectation.fulfill()
            XCTAssertNotNil(err, "An error should be returned for a path that does not exist")
            XCTAssertEqual(err!.statusCode, 404, "The request resource should not be found")
            XCTAssertNil(repo.etxResource.configuration.headers["Authorization"], "The access token should not be set")
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("Request Expectation \(String(describing: err))")
        }
    }
    
    func testUserLogoutWhenItFails() {
        let logoutExpectation = expectation(description: "Logout Expectation")
        let userRepo = UserRepository()
        let dummyToken = self.getUniqueId()
        userRepo.setAccessToken(dummyToken, rememberUser: true)
        XCTAssertEqual(dummyToken, userRepo.getAccessToken(), "The access token should be set to a dummy value")
        userRepo.logout {
            (err) in
            XCTAssertEqual(err?.code, "INVALID_ACCESS_TOKEN", "Logout should fail with an invalid access token error")
            XCTAssertNil(userRepo.getAccessToken(), "The user's access token should be removed when logout fails")
            logoutExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("Logout Expectation \(String(describing: err))")
        }
    }
    
    func testAppendOwnerIdtoFilterWhereFilterHasNoWhereCondArray() {
        let repo = Repository(resourcePath: "/non-existent-path")
        let expected = "{\"where\":{\"ownerId\":\"testing\"}}"
        let result = repo.appendOwnerIdToWhereFilter(filter: ETXSearchFilter(), ownerId: "testing")
        XCTAssertEqual(result, expected)
    }
    func testAppendOwnerIdtoFilterWhereFilterHasAWhereCondArrayInitialized() {
        let repo = Repository(resourcePath: "/non-existent-path")
        let expected = "{\"where\":{\"ownerId\":\"testing\"}}"
        let filter: ETXSearchFilter = ETXSearchFilter()
        filter.whereCondtions = [ETXWhereCondition]()
        let result = repo.appendOwnerIdToWhereFilter(filter: filter, ownerId: "testing")
        XCTAssertEqual(result, expected)
    }
}
