//
//  AuthError.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/6/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Failure when a user tries to authenticate
 */
public class ETXAuthenticationError: ETXError {
    
    public var reason: Reason?
    
    /**
    */
    public init(_ reason: Reason) {
        self.reason = reason
        super.init()
    }
    
    public convenience init?(reasonRawValue: String) {
        let reason: Reason? = Reason(rawValue: reasonRawValue)
        if let reason: Reason = reason {
            self.init(reason)
        } else {
            return nil
        }
    }
    
    public required init?(map: Map) {
        super.init(map: map)
    }
}

public extension ETXAuthenticationError {
    public enum Reason: String {
        /**
         Maximum login attempts reached, please wait 30 minutes before retrying
         */
        case MaxLoginAttemptsReached = "LOGIN_FAILED_MAX_ATTEMPTS_REACHED"
        
        /**
         The email address on the account is not yet verified
         */
        case EmailNotVerified = "LOGIN_FAILED_EMAIL_NOT_VERIFIED"
        
        /**
         The account has been disabled
         */
        case AccountDisabled = "DISABLED_USER"
        
        /**
         Invalid username and password combination
         */
        case InvalidUsernameOrPassword = "LOGIN_FAILED"
    }
}
