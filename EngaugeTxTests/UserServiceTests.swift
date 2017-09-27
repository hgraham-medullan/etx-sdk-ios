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
    
    func testLoginWithValidUsernameCredentials() {
        let username: String = "sean@medullan.com"
        let password: String = "P@ssw0rd"
        
        let successfulUserLoginExpectation = expectation(description: "User login is successsful")
        
        self.userSvc.loginUserWithUsername(username, password: password, rememberMe: true) {
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
    
    /** FIXME: This test consistently fails on the CI server.
     
     User creation failed: ["error": {
     details =     {
     codes =         {
     email =             (
     "uniqueness.MongoError: not authorized on app-e8b836cd6d20f3431e0fbcb54196360b to execute command { find: \"EtxUser\", filter: { email: \"sean+tx_cb641eb6f2234c04b3a71b6667f26844@medullan.com\" }, sort: { _id: 1 } }"
     );
     };
     context = EtxUser;
     messages =         {
     email =             (
     "is invalid"
     );
     };
     };
     message = "The Model instance is not valid. See error object `details` property for more info.";
     name = ModelValidationError;
     stack = "ValidationError: The `EtxUser` instance is not valid. Details: `email` is invalid (value: \"sean+tx_cb641eb6f2234c04b...com\").\n    at /usr/src/app/node_modules/loopback-datasource-juggler/lib/dao.js:2380:19\n    at ModelConstructor.<anonymous> (/usr/src/app/node_modules/loopback-datasource-juggler/lib/validations.js:503:13)\n    at ModelConstructor.next (/usr/src/app/node_modules/loopback-datasource-juggler/lib/hooks.js:81:12)\n    at done (/usr/src/app/node_modules/loopback-datasource-juggler/lib/validations.js:500:25)\n    at /usr/src/app/node_modules/loopback-datasource-juggler/lib/validations.js:578:7\n    at ModelConstructor.<anonymous> (/usr/src/app/node_modules/loopback-datasource-juggler/lib/validations.js:372:5)\n    at /usr/src/app/node_modules/loopback-datasource-juggler/lib/dao.js:1939:11\n    at /usr/src/app/node_modules/loopback-datasource-juggler/node_modules/async/lib/async.js:396:17\n    at done (/usr/src/app/node_modules/loopback-datasource-juggler/node_modules/async/lib/async.js:167:19)\n    at /usr/src/app/node_modules/loopback-datasource-juggler/node_modules/async/lib/async.js:40:16\n    at /usr/src/app/node_modules/loopback-datasource-juggler/node_modules/async/lib/async.js:393:21\n    at /usr/src/app/node_modules/loopback-datasource-juggler/lib/dao.js:1916:17\n    at doNotify (/usr/src/app/node_modules/loopback-datasource-juggler/lib/observer.js:98:49)\n    at doNotify (/usr/src/app/node_modules/loopback-datasource-juggler/lib/observer.js:98:49)\n    at doNotify (/usr/src/app/node_modules/loopback-datasource-juggler/lib/observer.js:98:49)\n    at doNotify (/usr/src/app/node_modules/loopback-datasource-juggler/lib/observer.js:98:49)\n    at doNotify (/usr/src/app/node_modules/loopback-datasource-juggler/lib/observer.js:98:49)\n    at Function.ObserverMixin._notifyBaseObservers (/usr/src/app/node_modules/loopback-datasource-juggler/lib/observer.js:121:5)\n    at Function.ObserverMixin.notifyObserversOf (/usr/src/app/node_modules/loopback-datasource-juggler/lib/observer.js:96:8)\n    at Function.ObserverMixin._notifyBaseObservers (/usr/src/app/node_modules/loopback-datasource-juggler/lib/observer.js:119:15)\n    at Function.ObserverMixin.notifyObserversOf (/usr/src/app/node_modules/loopback-datasource-juggler/lib/observer.js:96:8)\n    at Function.ObserverMixin._notifyBaseObservers (/usr/src/app/node_modules/loopback-datasource-juggler/lib/observer.js:119:15)\n    at Function.ObserverMixin.notifyObserversOf (/usr/src/app/node_modules/loopback-datasource-juggler/lib/observer.js:96:8)\n    at Function.ObserverMixin._notifyBaseObservers (/usr/src/app/node_modules/loopback-datasource-juggler/lib/observer.js:119:15)\n    at Function.ObserverMixin.notifyObserversOf (/usr/src/app/node_modules/loopback-datasource-juggler/lib/observer.js:96:8)\n    at Function.ObserverMixin._notifyBaseObservers (/usr/src/app/node_modules/loopback-datasource-juggler/lib/observer.js:119:15)\n    at Function.ObserverMixin.notifyObserversOf (/usr/src/app/node_modules/loopback-datasource-juggler/lib/observer.js:96:8)\n    at /usr/src/app/node_modules/loopback-datasource-juggler/lib/dao.js:1913:21";
     statusCode = 400;
     }]
     /Users/distiller/etx-sdk-ios/EngaugeTxTests/UserServiceTests.swift:144: error: -[EngaugeTxTests.UserServiceTest testCreateUser] : XCTAssertNil failed: "EngaugeTx.ETXRegistrationError" - An error should not be present
     /Users/distiller/etx-sdk-ios/EngaugeTxTests/UserServiceTests.swift:145: error: -[EngaugeTxTests.UserServiceTest testCreateUser] : XCTAssertNotNil failed - The user object should contain an ID
    */
    func testCreateUser() {
        let increment = self.getUniqueId()
        let username: String = "tu_\(increment)"
        let email: String = "sean+\(increment)@medullan.com"
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
    
    func testLogout() {
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
    
    func testUserUpdateWhenOnlyUpdatingTheUserFirstName() {
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
            
            user?.firstName = "Sean"
            user?.save(completion: { (err) in
                XCTAssertNil(err, "Updating a user's firstName only, should not result in an error")
                logoutExpectation.fulfill()
            })
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Expectations not resolved: \(error)")
            }
        }
    }
    
    func testUserUpdateWhenThePasswordPropertyIsSpecified() {
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
            
            user?.firstName = "Sean"
            user?.password = "P@ssw0rd"
            user?.save(completion: { (err) in
                XCTAssertNotNil(err, "Specifying password when updating the user should result in an error")
                XCTAssertNotNil(err!.details?["password"], "Details should be returned on the error specying that the password field should not be specified")
                logoutExpectation.fulfill()
            })
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Expectations not resolved: \(error)")
            }
        }
    }

    
    func testChangePasswordWhenTheNewPasswordIsNotTheSameAsTheCurrent() {
        let passwordChangeExpectation = expectation(description: "Password Change")
        let userSvc = ETXUserService()
        let emailAddress = "sean@medullan.com"
        let oldPassword = "P@ssw0rd"
        let newPassword: String = "P@ssw0rd2"
        
        // Login
        userSvc.loginUserWithEmail(emailAddress, password: oldPassword, rememberMe: true) {
            (user, err) in
            XCTAssertNotNil(user, "Should have a logged in user (\(String(describing: err?.message)))")
            if let user = user {
                
                // Change Password
                user.updatePassword(newPassword, currentPassword: oldPassword) {
                    (err) in
                    XCTAssertNil(err, "Password should be updated successfully (\(String(describing: err?.message)))")
                    
                    // Test with old Password. Login should fail
                    userSvc.loginUserWithEmail(emailAddress, password: oldPassword, rememberMe: true) {
                        (user, err) in
                        XCTAssertNotNil(err, "Login should not be successful \(String(describing: err?.message))")
                        XCTAssertTrue(err is ETXAuthenticationError, "Login error should be an authentication error (\(err?.message))")
                        XCTAssertEqual(ETXAuthenticationError.Reason.InvalidUsernameOrPassword, (err as! ETXAuthenticationError).reason, "Authentication error should be 'InvalidUsernameOrPassword'")
                        
                        // Try with the new Password. Login should pass
                        userSvc.loginUserWithEmail(emailAddress, password: newPassword, rememberMe: true) {
                            (user, err) in
                            XCTAssertNil(err, "Login should be successful (\(err?.message))")
                            
                            // Set the password back to the old one
                            user!.updatePassword(oldPassword, currentPassword: newPassword) {
                                (err) in
                                XCTAssertNil(err, "Password update should be successful (\(err?.message))")
                                passwordChangeExpectation.fulfill()
                            }
                            
                        }
                        
                    }
                    
                    
                }
            }
            
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Expectations not resolved: \(error)")
            }
        }
    }
    
    // Will need to be a manual test
    func xtestUserSoftDelete() {
        let userDeletionExpectation = expectation(description: "User deletion")
        
        let userSvc = ETXUserService()
        
        userSvc.loginUserWithEmail(softDeletedUser.email, password: softDeletedUser.password!, rememberMe: false) { (user, err) in
            XCTAssertNil(err, "User login should not fail")
            user!.delete {
                (err) in
                XCTAssertNil(err, "User deletion should be successful")
                userSvc.loginUserWithEmail(self.softDeletedUser.email, password: self.softDeletedUser.password!, rememberMe: false) { (user, err) in
                    XCTAssertNil(user, "User login should not be successful")
                    XCTAssertNotNil(err, "User login should failed")
                    XCTAssertTrue(err! is ETXAuthenticationError, "User login should fail with an authentication error")
                    let authErr = err as! ETXAuthenticationError
                    XCTAssertEqual(authErr.reason, ETXAuthenticationError.Reason.AccountDisabled, "The user's account should be disabled")
                    userDeletionExpectation.fulfill()
                }
                
            }
        }
        
        waitForExpectations(timeout: TIMEOUT_DEFAULT) { error in
            if let error = error {
                XCTFail("Expectations not resolved: \(error)")
            }
        }
    }
    
    // Will need to be a manual test
    func xtestUserHardDelete() {
        let userDeletionExpectation = expectation(description: "User deletion")
        
        let userSvc = ETXUserService()
        
        userSvc.loginUserWithEmail(hardDeletedUser.email, password: hardDeletedUser.password!, rememberMe: false) { (user, err) in
            XCTAssertNil(err, "User login should not fail")
            user!.delete(hardDelete: true) {
                (err) in
                XCTAssertNil(err, "User deletion should be successful")
                userSvc.loginUserWithEmail(self.hardDeletedUser.email, password: self.hardDeletedUser.password!, rememberMe: false) { (user, err) in
                    XCTAssertNil(user, "User login should not be successful")
                    XCTAssertNotNil(err, "User login should failed")
                    XCTAssertTrue(err! is ETXAuthenticationError, "User login should fail with an authentication error")
                    let authErr = err as! ETXAuthenticationError
                    XCTAssertEqual(authErr.reason, ETXAuthenticationError.Reason.InvalidUsernameOrPassword, "The user's account should be disabled")
                    userDeletionExpectation.fulfill()
                }
                
            }
        }
        
        waitForExpectations(timeout: 10000) { error in
            if let error = error {
                XCTFail("Expectations not resolved: \(error)")
            }
        }
    }

    
}
