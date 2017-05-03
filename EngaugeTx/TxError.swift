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
    internal static let CODE_DUPLICATE_KEY_ERROR: String = "11000"
    /**
     The error code
     */
    public var code: String?
    
    /**
     The error name
     */
    public var name: String?
    
    /**
     Summary of the error that occurred
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
    
    private var codeAsInt: Int?
    
    
    public init() { }
    
    public init(message: String) {
        self.message = message
    }
    
    public required init?(map: Map) {
        
    }
    
    var rawJson: [String: Any]?
    
    public func mapping(map: Map) {
        codeAsInt <- map["error.code"]
        code <- map["error.code"]
        statusCode <- map["error.statusCode"]
        details <- map["error.details"]
        message <- map["error.message"]
        name <- map["error.name"]
        if self.code == nil, let codeAsInt = self.codeAsInt {
            self.code = String(codeAsInt)
        }
    }
    
}
