//
//  UserServiceTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/2/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import XCTest
@testable import EngaugeTx
import ObjectMapper

class UserServiceTest: ETXTestCase {
    var userSvc: ETXUserService<ETXUser>!
    
    override func setUp() {
        super.setUp()
        self.userSvc = ETXUserService()
    }
    
    override func tearDown() {
        self.app =  nil
        self.userSvc = nil
    }
    
    /**
     Failing on the CI server for some unknown reason. Spent enough time
     trying to figure it out and coming up blank. Will resume at a another time
     */
    func testLoginWithValidUsernameCredentials() {
        let username: String = "sean@medullan.com"
        let password: String = "P@ssw0rd"
        
        let successfulUserLoginExpectation = expectation(description: "User login is successsful")
        
        self.userSvc.loginUserWithUsername(username, password: password, rememberMe: false) {
            (user: ETXUser?, err: ETXError?) in
            if let user:ETXUser = user {
                XCTAssertEqual(user.username, username, "Login username and username on the oject should be the same.")
            } else {
                XCTFail("User object should not be nil")
            }
            successfulUserLoginExpectation.fulfill()
        }
        
        //XCTAssertTrue(false, "This is no true xyz")
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("User login call failed: \(error)")
            }
        }
    }
    
    
    /** 
     Failing on the CI server for some unknown reason. Spent enough time
     trying to figure it out and coming up blank. Will resume at a another time
    */
    func testLoginWithValidEmailCredentials() {
        let email: String = "sean@medullan.com"
        let password: String = "P@ssw0rd"
        
        let successfulUserLoginExpectation = expectation(description: "User login is successsful")
        self.userSvc.loginUserWithEmail(email, password: password, rememberMe: false) {
            (user: ETXUser?, err: ETXError?) in
            XCTAssertEqual(user?.email, email, "The user login email should match the email on the user returned")
            successfulUserLoginExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("User login call failed: \(error)")
            }
        }
    }
    
    func testLoginWithInvalidEmailCredentials() {
        let email: String = "sean@medullan.com"
        let password: String = "badpwd"
        
        let successfulUserLoginExpectation = expectation(description: "User login is successsful")
        self.userSvc.loginUserWithEmail(email, password: password, rememberMe: false) {
            (user: ETXUser?, err: ETXError?) in
            XCTAssertNil(user, "User object should be nil on login failure")
            XCTAssertNotNil(err, "Error object should not be nil on login failure")
            XCTAssertTrue(err is ETXAuthenticationError?)
            
            if let authErr: ETXAuthenticationError = (err as? ETXAuthenticationError), let failureReason = authErr.reason {
                XCTAssertEqual(failureReason, ETXAuthenticationError.Reason.InvalidUsernameOrPassword)
            } else {
                XCTFail("Error should be of type 'ETXAuthenticationError'")
            }
            
            successfulUserLoginExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("User login call failed: \(error)")
            }
        }
    }
    
    func testLoginWithUnverifiedEmail() {
        let email: String = "sean+unverified@medullan.com"
        let password: String = "P@ssw0rd"
        
        let userLoginExpectation = expectation(description: "User login attempt successsful")
        
        self.userSvc.loginUserWithEmail(email, password: password, rememberMe: false) {
            (user: ETXUser?, err: ETXError?) in
            let err:ETXAuthenticationError = err as! ETXAuthenticationError
            XCTAssertEqual(ETXAuthenticationError.Reason.EmailNotVerified, err.reason!)
            userLoginExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("User login call failed: \(error)")
            }
        }
    }
    
    class TestUser: ETXUser {
        var isTestUser: Bool = true
        var oldName:  String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            isTestUser <- map["isTestUser"]
            oldName <- map["oldName"]
        }
        
    }
    
    func testDate() {
        let username: String = "sean+testuser\((Date()).timeIntervalSince1970)@medullan.com"
        
        print(username)
    }
    
    func testCreateUser() {
        let increment = (Date()).timeIntervalSince1970
        let username: String = "sean+testuser\(increment)"
        let email: String = "sean+testuser\(increment)@medullan.com"
        let testUser: TestUser = TestUser(email: email, username: username, password: "P@ssw0rd")
        testUser.firstName = "Sean Caregiver"
        testUser.lastName = "Hoilett"
        testUser.oldName = "Old Name"
        
        let userCreateExpectation = expectation(description: "User creation successsful")
        
        self.userSvc.createUser(testUser) {
            (user, err) in
            XCTAssertNil(err, "An error should not be present")
            XCTAssertNotNil(user?.id, "The user object should contain an ID")
            XCTAssertNil(user?.lastName, "Only the userId is populated as part of the registration process")
            userCreateExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("User creation api call failed: \(error)")
            }
        }
        
    }
    
    func testCreateUserWhenTheEmailIsAlreadyInUse() {
        let user: ETXUser = ETXUser(email: "sean@medullan.com",
                                    username: "sean@medullan.com",
                                    password: "P@ssw0rd")
        user.firstName = "Sean"
        user.lastName = "Hoilett"
        
        let userCreateExpectation = expectation(description: "User login attempt successsful")
        
        self.userSvc.createUser(user) {
            (user, err) in
            XCTAssertNotNil(err)
            XCTAssertEqual(400, err?.statusCode, "The status code should be 400")
            XCTAssertNotNil(err?.validationErrors?["email"]?["uniqueness"], "Validation error \"unique email\" should be present")
            
            XCTAssertNotNil(err?.validationErrors?["username"]?["uniqueness"], "Validation error \"unique username\" should be present")
            userCreateExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("User login call failed: \(error)")
            }
        }
    }
    
    func testGetCurrentUserWhenTheUserExtendETXUser() {
        let email: String = "sean+extendedUser@medullan.com"
        let password: String = "P@ssw0rd"
        let firstName: String = "Extended"
        let lastName: String = "User"
        let oldName: String = "Old Name"
        
        let successfulUserLoginExpectation = expectation(description: "User login is successsful")
        let getCurrentUserExpectation = expectation(description: "Get current user successfully")
        
        self.userSvc.loginUserWithEmail(email, password: password, rememberMe: false) {
            (user: ETXUser?, err: ETXError?) in
            XCTAssertNotNil(user, "The user did not successfully login")
            successfulUserLoginExpectation.fulfill()
            
            let testUserService = ETXUserService<TestUser>()
            testUserService.getCurrentUser { (testUser) in
                XCTAssertNotNil(testUser)
                XCTAssertEqual(testUser?.email, email)
                XCTAssertEqual(testUser?.firstName, firstName)
                XCTAssertEqual(testUser?.lastName, lastName)
                XCTAssertEqual(testUser?.oldName, oldName)
                getCurrentUserExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Expectations not resolved: \(error)")
            }
        }
    }
    
    func testInitiatePasswordResetWithEmail() {
        let resetEmailExpectation = expectation(description: "Get current user successfully")
        self.userSvc.initiatePasswordResetWithEmail("sean@medullan.com") {
            (err) in
            XCTAssertNil(err, "Password reset should not result in an error")
            resetEmailExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Expectations not resolved: \(error)")
            }
        }
    }
    
    func xtestLogout() {
        let logoutExpectation = expectation(description: "Log the user out")
        let successfulUserLoginExpectation = expectation(description: "User login is successsful")
        let username: String = "sean@medullan.com"
        let password: String = "P@ssw0rd"
        let userRepos: UserRepository = UserRepository()
        userRepos.deleteCurrentUser()
        self.userSvc.loginUserWithUsername(username, password: password, rememberMe: false) {
            (user: ETXUser?, err: ETXError?) in
            XCTAssertNil(err, "User should be successfully logged in")
            successfulUserLoginExpectation.fulfill()
            
            self.userSvc.logout {
                (err) in
                XCTAssertNil(err, "User logout should not result in an error")
                XCTAssertNil(userRepos.getAccessToken(), "Access token should be deleted")
                logoutExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Expectations not resolved: \(error)")
            }
        }
    }
}
