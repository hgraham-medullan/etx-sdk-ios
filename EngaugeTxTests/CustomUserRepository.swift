//
//  CustomUserRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 10/25/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper

fileprivate class DerivedUser: ETXUser {
    
}

fileprivate class CustomUserRepository<M: ETXUser>: ETXCustomUserRepository<M> {
    
    required init(resourcePath: String) {
        super.init(resourcePath:resourcePath)
    }
    
    func getDummyUser() -> M {
        let user: M = M()
        user.firstName = "Dummy"
        user.lastName = "User"
        return user 
    }
    
    override func loginWithUsername(_ username: String, password: String, rememberMe: Bool, done: @escaping (M?, ETXError?) -> Void) {
        super.loginWithUsername(username, password: password, rememberMe: rememberMe, done: done)
        done(self.getDummyUser(), nil)
    }
    
    override public func loginWithEmail(_ email: String, password: String, rememberMe: Bool, done: @escaping (M?, ETXError?) -> Void) {
        super.loginWithEmail(email, password: password, rememberMe: rememberMe, done: done)
        done(self.getDummyUser(), nil)
    }
    
    override public func findWhere(_ filter: ETXSearchFilter, completion: @escaping ([M]?, ETXError?) -> Void) {
        super.findWhere(filter, completion: completion)
        XCTAssertNotNil(self.getHttpPath(), "The HTTP path should be set")
        var users = [M]()
        users.append(self.getDummyUser())
        completion(users, nil)
    }
    
    override public func getAffiliatedUsers(withRole: ETXRole, forMyRole: ETXRole, completion: @escaping ([ETXUser]?, ETXError?) -> Void) {
        super.getAffiliatedUsers(withRole: withRole, forMyRole: forMyRole, completion: completion)
        var affiliatedUsers: [ETXUser] = [ETXUser]()
        affiliatedUsers.append(self.getDummyUser())
        completion(affiliatedUsers, nil)
    }
    
    override func getCurrentUserId() -> String? {
        return "user-id"
    }
    
    public override func provideInstance<T>(resourcePath: String) -> Repository<T>? where T : ETXUser {
        return CustomUserRepository<T>(resourcePath: resourcePath)
    }
    
    open override func save(model: M, completion: @escaping (M?, ETXError?) -> Void) {
        super.save(model: model, completion: completion)
        model.id = "new-user-id";
        completion(model, nil)
    }
}

class CustomUserRepositoryTests: ETXTestCase {
    
    override func setUp() {
        super.setUp()
        ETXUserService.useCustomDataRepository(CustomUserRepository.self, forModelType: ETXUser.self)
    }
    
    override func tearDown() {
        super.tearDown()
        EngaugeTxApplication.clearCustomRepositories()
        XCTAssertFalse(EngaugeTxApplication.isUsingCustomRepsoitories())
    }
    
    func testUserLoginWithEmail() {
        let reqExpectation = expectation(description: "Request Expectation")
        let userSvc = ETXUserService()
        userSvc.loginUserWithEmail("non-existent-user@email.com", password: "password", rememberMe: false) {
            (user, err) in
            XCTAssertEqual("\(user!.firstName!) \(user!.lastName!)", "Dummy User", "The dummy user account should be returned")
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
            XCTAssertEqual("\(user!.firstName!) \(user!.lastName!)", "Dummy User", "The dummy user account should be returned")
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
            XCTAssertEqual("\(user!.firstName!) \(user!.lastName!)", "Dummy User", "The dummy user account should be returned")
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
            XCTAssertNil(err, "It should retrieve the list of users successfully")
            XCTAssertEqual(users!.count, 1, "")
            let user = users!.first!
            XCTAssertEqual("\(user.firstName!) \(user.lastName!)", "Dummy User", "The dummy user account should be returned")
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
            XCTAssertNil(err, "It should retrieve the list of users successfully")
            XCTAssertEqual(users!.count, 1, "")
            let user = users!.first!
            XCTAssertEqual("\(user.firstName!) \(user.lastName!)", "Dummy User", "The dummy user account should be returned")
            reqExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("Request Expectation \(String(describing: err))")
        }
    }
    
    func testSave() {
        let reqExpectation = expectation(description: "Request Expectation")
        let user = ETXUser();
        user.email = "sean@med.com"
        user.save {
            (err) in
            XCTAssertEqual(user.id, "new-user-id", "The saved user should be assigned the ID 'new-user-id'")
            reqExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("Request Expectation \(String(describing: err))")
        }
    }
    
}


