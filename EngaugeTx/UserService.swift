//
//  UserService.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/2/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation

/**
 Provides authentication to the EnguageTx Platform
 */
public class UserService: AuthSvc {
    
    let userRepository: UserRepository
    
    override public init() {
        self.userRepository = UserRepository()
        super.init()
    }
    
    private static let KEY_ACCESS_TOKEN = "accessToken"
    
    /// Login with username
    ///
    /// - parameter username: The user's username
    /// - parameter password: The user's password
    /// - parameter completion: Callback when the request completes
    /// - parameter obj: The TX object
    /// - parameter err: The error object
    public func loginUserWithUsername(_ username: String, password: String, completion: @escaping (_ user: ETXUser?, _ err: ETXError?) -> Void) {
    
        self.userRepository.loginWithUsername(username, password: password, done: completion)
    }
    
    /**
     Login with email address
     - parameter email: The user's email address
     - parameter password: The user's password
     - parameter completion: Callback when the request completes
     - parameter object: The TX object
     - parameter err: The error object
     */
    public func loginUserWithEmail(_ email: String, password: String, completion: @escaping (_ object: ETXUser?, _ err: ETXError?) -> Void) {
        self.userRepository.loginWithEmail(email, password: password, done: completion)
    }
}
