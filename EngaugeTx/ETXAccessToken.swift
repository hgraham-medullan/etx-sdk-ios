//
//  ETXAccessToken.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/6/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Represents the AccessToken for the User
 */
class ETXAccessToken: ETXModel {
    
    var userId: String?
    var ttl: Int64 = 0
    var user: ETXUser?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        userId <- map["userId"]
        ttl <- map["ttl"]
        user <- map["user"]
    }
    
}
