//
//  AuthSvc.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 11/28/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation


/**
 Provides authentication to the EnguageTx Platform
 */
public class AuthSvc {
    
    public init() {
        
    }
    
    /**
     Login with username
     - parameter username: The user's username
     - parameter password: The user's password
     - parameter completion: Callback when the request completes
     */
    public func loginUserWithUsername(_ username: String, password: String, completion: (TxModel, TxError) -> Void) {
        
    }
    
    /**
     Login with email address
     - parameter email: The user's email address
     - parameter password: The user's password
     - parameter completion: Callback when the request completes
     */
    public func loginUserWithEmail(_ email: String, password: String, completion: (TxModel, TxError) -> Void) {
        
    }
}
