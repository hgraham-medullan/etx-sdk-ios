//
//  AffiliationService.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/12/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

/**
 * Service class for retrieving affiliations among users
 * @available(0.0.46, deprecated, message: "Use ETXUserService instead")
 */
public class ETXAffiliationService<T: ETXUser> {
    let userService: ETXUserService<T>
    
    /**
     Create an instance of ETXUserService
     */
    public init() {
        self.userService = ETXUserService<T>()
    }
    
    /**
     * Returns a list of Users associated with the currrently logged in user.
     *
     * @param withRole  The role of the users to be returned
     * @param forMyRole Which role for the current user should be used
     * @param callback  Callback when the request completes
     * @available(0.0.46, deprecated, message: "Use ETXUserService#getAffiliatedUsers instead")
     */
    public func getAffiliatedUsers(withRole: ETXRole, forMyRole: ETXRole, completion: @escaping (_ object: [ETXUser]?, _ err: ETXError?) -> Void) {
        self.userService.getAffiliatedUsers(withRole: withRole, forMyRole: forMyRole, completion: completion)
    }

}

