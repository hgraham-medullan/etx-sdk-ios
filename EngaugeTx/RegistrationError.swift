//
//  RegistrationError.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/13/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Encapsulates errors that can be received during the registration process of a user
 */
public class ETXRegistrationError: ETXError {
    
    /**
     A list of validations that failed during registration process.
     */
    public var validationErrors: [String: [String:String]]? {
        return getValidationErrors()
    }
    
    private func getValidationErrors() ->  [String: [String:String]]? {
        let KEY_CODES: String  = "codes"
        let KEY_MESSAGES: String  = "messages"
        
        var validationErrors: [String: [String:String]]?
        if let details = self.details {
            validationErrors = [String: [String:String]]()
            
            for (fieldName, failedValidations) in details {
                if fieldName != KEY_CODES, fieldName != KEY_MESSAGES {
                    validationErrors?[fieldName] = failedValidations as? [String:String]
                }
            }
            
            if let codes:[String: [String]] = details[KEY_CODES] as? [String: [String]],
                let messages: [String: [String]] = details[KEY_MESSAGES] as? [String: [String]]  {
                
                for (fieldName, failedValidations) in codes {
                    let validationMessagesForField: [String] = messages[fieldName]!
                    for (index, validationName) in failedValidations.enumerated() {
                        validationErrors?[fieldName] = [validationName: validationMessagesForField[index]]
                    }
                }
            }
        }
        return validationErrors
    }
}
