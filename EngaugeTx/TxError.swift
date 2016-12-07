//
//  TxError.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/1/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 An error response from the EngaugeTx Platform
 */
public class ETXError: Mappable {
    
    /**
     The error code
     */
    public var code: String = ""
    
    public init() { }
    
    public required init?(map: Map) {
        //super.init(map: map)
    }
    
    public func mapping(map: Map) {
        code <- map["error.code"]
    }
    
}
