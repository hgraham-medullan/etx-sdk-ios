//
//  AffiliationService.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/10/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

open class AffiliationService<T: ETXUser> {
    let userRepository: UserRepository<T>
    
    /**
     Create an instance of ETXUserService
     */
    public init() {
        self.userRepository = UserRepository()
    }
    
    /**
     * Returns a list of Users associated with the currrently logged in user.
     *
     * @param withRole  The role of the users to be returned
     * @param forMyRole Which role for the current user should be used
     * @param callback  Callback when the request completes
     */
//    func getAffiliatedUsers(withRole: Role, forMyRole: Role, completion: @escaping (_ object: T?, _ err: ETXError?) -> Void) {
//        self.userRepository.getAffiliatedUsers(withRole, forMyRole, completion);
//    }
    
    /**
     * Returns a list of Users associated with the currrently logged in user.
     *
     * @param withRole The role of the users to be returned
     * @param callback Callback when the request completes
     */
//    public func getAffiliatedUsers(withRole: Role, completion: @escaping (_ object: T?, _ err: ETXError?) -> Void) {
//        self.userRepository.getAffiliatedUsers(withRole, completion);
//    }
}
