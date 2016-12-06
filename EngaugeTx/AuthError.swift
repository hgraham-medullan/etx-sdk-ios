//
//  AuthError.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/6/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation

protocol AuthenticationError {
    
}

/**
 Maximum login attempts reached, please wait 30 minutes before retrying
 */
public class MaxLoginAttemptsReached: AuthenticationError { }

/**
 The email address on the account is not yet verified
 */
public class EmailNotVerified: AuthenticationError { }


/**
 The account has been disabled
 */
public class AccountDisabled: AuthenticationError { }


/**
 Invalid username and password combination
 */
public class InvalidUsernameOrPassword: AuthenticationError { }
