//
//  ETXMappable.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/19/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/// A class that can be serialize to JSOn and back
open class ETXMappable: Mappable {
    
    public var rawJson: [String:Any]?
    
    public init() {
        
    }
    
    /**
     Create an instance from a Map
     - parameter map: The Map object
     */
    required public init?(map: Map) {
        self.rawJson = map.JSON
    }
    
    /**
     This function is where all variable mappings should occur. It is executed
     by Mapper during the mapping (serialization and deserialization) process.
     */
    open func mapping(map: Map) {
    }
    
    var ignoreProperties: [String] = [String]()
    
    public func ignoreOnNull(_ jsonPropertyName: String) {
        self.ignoreProperties.append(jsonPropertyName)
    }
    
    public func ignoreOnNull(_ jsonPropertyName: String, map: Map) -> Map {
        self.ignoreOnNull(jsonPropertyName)
        return map[jsonPropertyName]
    }
    
    public func ignoreOnNull<T: TransformType>(_ jsonPropertyName: String, map: Map, transformType: T) -> (Map, T) {
        self.ignoreOnNull(jsonPropertyName)
        return (map[jsonPropertyName], transformType)
    }
}
//

public extension ETXMappable {
    func toJSON() -> [String : Any] {
        var jsonProperties = Mapper(context: nil, shouldIncludeNilValues: true).toJSON(self)
        
        for key in ignoreProperties {
            
            // TODO: check if key has dots
            //let x = jsonProperties[keyPath: key]
            if let value = jsonProperties[key], value is NSNull {
                jsonProperties.removeValue(forKey: key)
            }
        }
        return jsonProperties
    }
    
    func toJSONString(prettyPrint: Bool) -> String? {
        return Mapper(context: nil, shouldIncludeNilValues: true).toJSONString(self, prettyPrint: prettyPrint)
    }
}
