//
//  User.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/2/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

public class ETXUser: ETXModel {
    var firstName: String = ""
    var lastName: String = ""
    var username: String = ""
    var email: String = ""
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public init(x: Any) {
        super.init()
        let d = (x as! [String:Any])
        let u:ETXUser? = Mapper<ETXUser>().map(JSON: d)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        username <- map["username"]
        email <- map["email"]
    }
}
