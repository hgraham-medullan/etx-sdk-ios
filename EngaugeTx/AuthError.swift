//
//  AuthError.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/6/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation

/**
 Failure when a user tries to authenticate
 */
public class ETXAuthenticationError: ETXError {
    public var reason: Reason
    
    /**
    */
    public init(_ reason: Reason) {
        self.reason = reason
    }
}

public extension ETXAuthenticationError {
    public enum Reason {
        /**
         Maximum login attempts reached, please wait 30 minutes before retrying
         */
        case MaxLoginAttemptsReached
        
        /**
         The email address on the account is not yet verified
         */
        case EmailNotVerified
        
        /**
         The account has been disabled
         */
        case AccountDisabled
        
        /**
         Invalid username and password combination
         */
        case InvalidUsernameOrPassword
    }
}
