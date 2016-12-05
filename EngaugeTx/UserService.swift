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
    /// Login with username
    ///
    /// - parameter username: The user's username
    /// - parameter password: The user's password
    /// - parameter completion: Callback when the request completes
    /// - parameter obj: The TX object
    /// - parameter err: The error object
    public func loginUserWithUsername(_ username: String, password: String, completion: (_ obj: ETXUser?, _ err: ETXError?) -> Void) {
        
        let user: ETXUser = ETXUser()
        user.username = username
        completion(user, nil)
    }
    
    /**
     Login with email address
     - parameter email: The user's email address
     - parameter password: The user's password
     - parameter completion: Callback when the request completes
     - parameter object: The TX object
     - parameter err: The error object
     */
    public func loginUserWithEmail(_ email: String, password: String, completion: (_ object: ETXUser?, _ err: ETXError?) -> Void) {
        let user: ETXUser = ETXUser()
        user.email = email
        completion(user, nil)
    }
}
