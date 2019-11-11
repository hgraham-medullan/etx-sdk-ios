//
//  SearchFilter.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 1/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

/**
 Provides capabilites for setting filters when fetching models
 */
public class ETXSearchFilter {
    
    /**
     The order by which to sort results
    */
    public enum SortOrder: String {
        /**
         Sorts in an ascending order
        */
        case ASC = "ASC"
        
        /**
         Sorts in a descending order
         */
        case DESC = "DESC"
    }
    
    var whereCondtions: [ETXCondition]?
    private var limit: Int?
    private var skip: Int?
    private var sorting: [String]?
    private var customFilter: String?
    
    /**
     Create a new instance of SearchFilter
    */
    public init() {
    
    }
    
    /**
     Create a new instance of SearchFilter
     - parameter customFilter: Filter query expressed in [loopback's query string format](http://loopback.io/doc/en/lb2/Where-filter.html) If this constructor is used, all other consditions set through the SDK's API will be ignored. 
         Please contact support for any large queries you may need,
     
     */
    public init(customFilter: String) {
        self.customFilter = customFilter
    }
    
    public var usesCustomFilter: Bool {
        return self.customFilter != nil
    }
    
    /**
     Create a new instance of SearchFilter
     - parameter conditions: The list of conditions to be applied to the filter
     */
    public init(conditions: [ETXCondition]) {
        self.whereCondtions = conditions
    }
    
    /**
     Create a new instance of SearchFilter
     - parameter condition: The conditions to be applied to the filter
     */
    public init(condition: ETXCondition) {
        self.whereCondtions = [condition]
    }
    
    /**
     A limit filter limits the number of records returned to the specified number (or less).
     - parameter limit: The maximum number of records to return
    */
    public func setLimit(_ limit: Int) {
        self.limit = limit
    }
    
    /**
     The number of records to skip
     - parameter skip: The number of records to skip
     */
    public func skip(_ skip: Int) {
        self.skip = skip
    }
    
    /**
     Specifies how to sort the results
     - parameter property: The property by which the results should be sorted
     - parameter order: The order by which to sort the results
     
    */
    public func sortBy(_ property: String, order: SortOrder) {
        if self.sorting == nil {
            self.sorting = [String]([])
        }
        self.sorting?.append("\(property) \(order.rawValue)")
    }
    
    private func toJson() -> [String:Any] {
        var q = [String: Any]()
        
        if let whereCondtions = self.whereCondtions {
            var whereClause = [String:Any]()
            for condition in whereCondtions {
                for(k,v) in condition.toJson() {
                    whereClause[k] = v
                }
            }
            q["where"] = whereClause
        }
        
        if let sorting = self.sorting {
            var sortValue: Any
            if sorting.count == 1 {
                sortValue = sorting.first!
            } else {
                sortValue = sorting
            }
            q["order"] = sortValue
        }
        
        if let limit = self.limit {
            q["limit"] = limit
        }
        
        if let skip = self.skip {
            q["skip"] = skip
        }
        return q
    }
    
    func toJsonString() -> String {
        var jsonString: String
        if let customFilter = self.customFilter {
            jsonString = customFilter
        } else {
            let dictionary = self.toJson()
            jsonString = dictionary.printJson()
        }
        return jsonString
    }
}

extension Dictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    public func printJson() -> String {
        return json
    }

}
