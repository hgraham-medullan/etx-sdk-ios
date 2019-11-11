//
//  CustomUserRepositoryWithFailedResponses.swift
//  EngaugeTxTests
//
//  Created by Sean Hoilett on 11/16/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper

fileprivate class DerivedUser: ETXUser {
    
}

fileprivate class CustomUserRepository<M: ETXUser>: ETXCustomUserRepository<M> {
    
    let requestError = ETXError()
    
    required init(resourcePath: String) {
        super.init(resourcePath:resourcePath)
        requestError.message = "Failed to perform the request!"
        requestError.name = "TestError"
    }
    
    override func loginWithUsername(_ username: String, password: String, rememberMe: Bool, done: @escaping (M?, ETXError?) -> Void) {
        super.loginWithUsername(username, password: password, rememberMe: rememberMe, done: done)
        XCTAssertEqual(self.getHttpPath(), "/users/login?include=user&ttl=1200", "The HTTP path should be set")
        done(nil, requestError)
    }
    
    override public func loginWithEmail(_ email: String, password: String, rememberMe: Bool, done: @escaping (M?, ETXError?) -> Void) {
        super.loginWithEmail(email, password: password, rememberMe: rememberMe, done: done)
        XCTAssertEqual(self.getHttpPath(), "/users/login?include=user&ttl=1200", "The HTTP path should be set")
        done(nil, requestError)
    }
    
    override public func findWhere(_ filter: ETXSearchFilter, completion: @escaping ([M]?, ETXError?) -> Void) {
        super.findWhere(filter, completion: completion)
        XCTAssertEqual(self.getHttpPath(), "/users?filter=%7B%7D", "The HTTP path should be set")
        completion(nil, requestError)
    }
    
    override public func getAffiliatedUsers(withRole: ETXRole, forMyRole: ETXRole, completion: @escaping ([ETXUser]?, ETXError?) -> Void) {
        super.getAffiliatedUsers(withRole: withRole, forMyRole: forMyRole, completion: completion)
        XCTAssertEqual(self.getHttpPath(), "/users/user-id/affiliatedUsers", "The HTTP path should be set")
        completion(nil, requestError)
    }
    
    override func getCurrentUserId() -> String? {
        return "user-id"
    }
    
    public override func provideInstance<T>(resourcePath: String) -> Repository<T>? where T : ETXUser {
        return CustomUserRepository<T>(resourcePath: resourcePath)
    }
}

class CustomUserRepositoryWithRequestErrorsTests: ETXTestCase {
    
    let expectedErrorName = "TestError"
    
    override func setUp() {
        super.setUp()
    
        ETXUserService.useCustomDataRepository(CustomUserRepository.self, forModelType: ETXUser.self)
    }
    
    override func tearDown() {
        super.tearDown()
        EngaugeTxApplication.clearCustomRepositories();
        XCTAssertFalse(EngaugeTxApplication.isUsingCustomRepsoitories())
    }
    
    func testUserLoginWithEmail() {
        let reqExpectation = expectation(description: "Request Expectation")
        let userSvc = ETXUserService()
        userSvc.loginUserWithEmail("non-existent-user@email.com", password: "password", rememberMe: false) {
            (user, err) in
            XCTAssertNotNil(err, "The loginUserWithEmail request should return an error")
            XCTAssertEqual(err!.name, self.expectedErrorName)
            reqExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("Request Expectation \(String(describing: err))")
        }
    }
    
    func testUserLoginWithUsername() {
        let reqExpectation = expectation(description: "Request Expectation")
        let userSvc = ETXUserService()
        userSvc.loginUserWithUsername("non-existent-user", password: "password", rememberMe: false) {
            (user, err) in
            XCTAssertNotNil(err, "The loginUserWithUsername request should return an error")
            XCTAssertEqual(err!.name, self.expectedErrorName)
            reqExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("Request Expectation \(String(describing: err))")
        }
    }
    
    func testUserLoginWithUsernameWithADerivedUserClass() {
        let reqExpectation = expectation(description: "Request Expectation")
        let userSvc: ETXUserService<DerivedUser> = ETXUserService<DerivedUser>()
        userSvc.loginUserWithUsername("non-existent-user", password: "password", rememberMe: false) {
            (user, err) in
            XCTAssertNotNil(err, "The loginUserWithUsername request should return an error")
            XCTAssertEqual(err!.name, self.expectedErrorName)
            reqExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("Request Expectation \(String(describing: err))")
        }
    }
    
    func testGetAffiliatedUsers() {
        let reqExpectation = expectation(description: "Request Expectation")
        let affiliationSvc = ETXAffiliationService()
        affiliationSvc.getAffiliatedUsers(withRole: ETXRole.patient, forMyRole: ETXRole.caregiver) {
            (users, err) in
            XCTAssertNotNil(err, "The getAffiliatedUsers request should return an error")
            XCTAssertEqual(err!.name, self.expectedErrorName)
            reqExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("Request Expectation \(String(describing: err))")
        }
    }
    
    func testFindWhere() {
        let reqExpectation = expectation(description: "Request Expectation")
        let userSvc: ETXUserService<ETXUser> = ETXUserService<ETXUser>()
        userSvc.findWhere(ETXSearchFilter()) {
            (users, err) in
            XCTAssertNotNil(err, "The findWhere request should return an error")
            XCTAssertEqual(err!.name, self.expectedErrorName)
            reqExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("Request Expectation \(String(describing: err))")
        }
    }
    
}


