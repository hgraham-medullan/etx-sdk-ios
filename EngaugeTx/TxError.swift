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
    public var code: String?
    
    /**
     The error name
     */
    public var name: String?
    
    /**
     Summary of the errir that occurred
     */
    public var message: String?
    
    /**
     The response HTTP status code
     */
    public var statusCode: Int?
    
    /**
     Additional details about the error
     */
    public var details: [String: Any]?
    
    
    public init() { }
    
    public required init?(map: Map) {
        //super.init(map: map)
    }
    
    var rawJson: [String: Any]?
    
    public func mapping(map: Map) {
        code <- map["error.code"]
        statusCode <- map["error.statusCode"]
        details <- map["error.details"]
        message <- map["error.message"]
        name <- map["error.name"]
    }
    
}
