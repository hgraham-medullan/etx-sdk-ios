//
//  Date.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 2/9/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

class ETXDateTransform: TransformType {
    static let SERVER_DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.S'Z'"
    
    public func transformFromJSON(_ value: Any?) -> Date? {
        
        guard case let value as String = value else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = ETXDateTransform.SERVER_DATE_FORMAT
        guard let date: Date = formatter.date(from: value) else {
            return nil
        }
        
        return date
    }
    
    public func transformToJSON(_ value: Date?) -> String? {
        guard let value = value else {
            return nil
        }
        return value.toTxDateFormat()
    }
}

public extension Date {
    public func toTxDateFormat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ETXDateTransform.SERVER_DATE_FORMAT
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
}
