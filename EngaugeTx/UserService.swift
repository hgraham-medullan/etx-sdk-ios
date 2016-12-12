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
open class ETXUserService {
    
    private static let KEY_ACCESS_TOKEN = "accessToken"
    
    let userRepository: UserRepository
    
    /**
     Create an instance of ETXUserService
     */
    public init() {
        self.userRepository = UserRepository()
    }
    
    /** Login with username.
     - parameter username: The user's username
     - parameter password: The user's password
     - parameter rememberMe: Allows for an extended user session
     - parameter completion: Callback when the request completes
     - parameter object: The TX object
     - parameter err: The error object
     */
    public func loginUserWithUsername(_ username: String, password: String, rememberMe: Bool, completion: @escaping (_ user: ETXUser?, _ err: ETXError?) -> Void) {
        
        self.userRepository.loginWithUsername(username, password: password, rememberMe: rememberMe, done: completion)
    }
    
    /**
     Login with email address.
     - parameter email: The user's email address
     - parameter password: The user's password
     - parameter rememberMe: Allows for an extended user session
     - parameter completion: Callback when the request completes
     - parameter object: The TX object
     - parameter err: The error object
     */
    public func loginUserWithEmail(_ email: String, password: String, rememberMe: Bool, completion: @escaping (_ object: ETXUser?, _ err: ETXError?) -> Void) {
        self.userRepository.loginWithEmail(email, password: password, rememberMe: rememberMe, done: completion)
    }
    
    public func logout(completion: ()->Void) {
        self.userRepository.logout()
        completion()
    }
    
    public func getCurrentUser(completion:(ETXUser?)->Void) {
        print(self.userRepository.getAccessToken())
        completion(nil)
    }
    
}
