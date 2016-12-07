//
//  User.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/2/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Represents a user of an application on the platform
 */
public class ETXUser: ETXModel {
    
    /**
     The user's first name
     */
    public var firstName: String = ""
    
    /**
     The user's last name
     */
    public var lastName: String = ""
    
    /**
     The username of the user
     */
    public var username: String = ""
    
    /**
     The user's email address
     */
    public var email: String = ""
    
    /**
     Creates a instance of ETXUser
     */
    public override init() {
        super.init()
    }
    
    /**
     Creates a instance of ETXUser
     */
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    /**
     Creates a instance of ETXUser from map
     */
    public override func mapping(map: Map) {
        super.mapping(map: map)
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        username <- map["username"]
        email <- map["email"]
    }
}
