//
//  SearchFilter.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 1/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

public class SearchFilter {
    
    public enum SortOrder: String {
        case ASC = "ASC"
        case DESC = "DESC"
    }
    
    var whereCondtions: [Condition]?
    private var limit: Int?
    private var sorting: [String]?
    private var customFilter: String?
    
    init() {
    }
    
    init(customFilter: String) {
        self.customFilter = customFilter
    }
    
    init(conditions: [Condition]) {
        self.whereCondtions = conditions
    }
    
    public func setLimit(_ limit: Int) {
        self.limit = limit
    }
    
    public func sortBy(_ property: String, order: SortOrder) {
        self.sorting = [String]([])
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
        return q
    }
    
    func toJsonString() -> String {
        var jsonString: String
        if let customFilter = self.customFilter {
            jsonString = customFilter
        } else {
            jsonString = self.toJson().printJson()
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
