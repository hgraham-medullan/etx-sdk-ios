//
//  AffiliatedUser.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/12/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 A user that is affiliated with another through some role
 */
public class ETXAffiliatedUser : ETXModel {
    
    var firstName: String?
    var lastName: String?
    var myRole: ETXRole?
    var role: ETXRole?
    
    public required init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        myRole <- map["myRole"]
        role <- map["role"]
    }
}
