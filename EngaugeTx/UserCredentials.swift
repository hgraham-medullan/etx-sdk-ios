//
//  UserCredentials.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/5/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta
import ObjectMapper

protocol UserCredentials: Mappable {
    var password: String { get set }
}


class UserEmailCredentials: UserCredentials {
    var email: String = ""
    var password: String = ""
    
    init(_ email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        email <- map["email"]
        password <- map["password"]
    }
}

class UsernameCredentials: UserCredentials {
    var username: String = ""
    var password: String = ""
    
    init(_ username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        username <- map["username"]
        password <- map["password"]
    }
}

class PasswordUpdateCredentials: UserCredentials {
    
    var oldPassword: String
    var password: String
    
    init(currentPassword: String, newPassword: String) {
        self.oldPassword = currentPassword
        self.password = newPassword
    }
    
    required public init?(map: Map) {
        // TODO: Find appropriate way to initialize
        self.oldPassword = ""
        self.password = ""
    }
    
    public func mapping(map: Map) {
        // TODO: Platform to be update to accept current password
        //currentPassword <- map["currentPassword"]
        password <- map["password"]
    }
}

class EmailUpdateCredentials: UserEmailCredentials {
    
    init(newEmailAddress: String, currentPassword: String) {
        super.init(newEmailAddress, password: currentPassword)
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
}
