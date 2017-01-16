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
open class ETXUser: ETXModel {
    
    /**
     The user's first name
     */
    public var firstName: String?
    
    /**
     The user's last name
     */
    public var lastName: String?
    
    /**
     The username of the user
     */
    public var username: String
    
    /**
     The user's email address
     */
    public var email: String
    
    /**
     The user's Password
     */
    public var password: String
    
    public init(email: String, username: String, password: String) {
        self.email = email
        self.username = username
        self.password = password
        super.init()
    }
    
    
    /**
     Creates a instance of ETXUser
     */
    required public init?(map: Map) {
        self.email = ""
        self.username = ""
        self.password = ""
        do {
            try self.password = map.value("password")
            try self.username = map.value("username")
            try self.email = map.value("email")
        }
        catch {
            print("Err occured while mapping to an ETXUser")
        }
        
        super.init(map: map)
    }
    
    /**
     Creates a instance of ETXUser from map
     */
    open override func mapping(map: Map) {
        super.mapping(map: map)
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        username <- map["username"]
        email <- map["email"]
        password <- map["password"]
    }
}
