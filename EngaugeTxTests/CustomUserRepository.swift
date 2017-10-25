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

class CustomUserRepository: ETXTestCase {
    
    override func tearDown() {
        super.tearDown()
        EngaugeTxApplication.clearCustomRepositories()
    }
    
    func testUserLogin() {
        ETXUserService.useCustomDataRepository(LocalUserRepository.self, forModelType: ETXUser.self)
        
        let loginExpectation = expectation(description: "login Expectation")
        ETXUserService().loginUserWithEmail("an@email.com", password: "password", rememberMe: true) {
         (resp, err) in
            XCTAssertNil(err)
            loginExpectation.fulfill()
            
        }
        
        waitForExpectations(timeout: 10) {
            (err) in
            print("login Expectation \(String(describing: err))")
        }
    }
}

public class LocalUserRepository<M: ETXUser>: ETXCustomUserRepository<M> {
    
    override public func loginWithEmail(_ email: String, password: String, rememberMe: Bool, done: @escaping (M?, ETXError?) -> Void) {
        super.loginWithEmail(email, password: password, rememberMe: rememberMe, done: done)
        XCTAssertEqual(email, "an@email.com")
        XCTAssertEqual(password, "password")
        done(nil, nil)
    }
    
    
    override public func findWhere(_ filter: ETXSearchFilter, completion: @escaping ([M]?, ETXError?) -> Void) {
        super.findWhere(filter, completion: completion)
        let path = self.getHttpPath()
        var users = [ETXUser]()
        users.append(ETXUser(email: "blag", username: "user", password: "pwd"))
        completion(users as! [M], nil)
        print("this is it")
    }
    
    public override func provideInstance<T>(resourcePath: String) -> Repository<T>? where T : ETXUser {
        return LocalUserRepository<T>(resourcePath: resourcePath)
    }
    
}
