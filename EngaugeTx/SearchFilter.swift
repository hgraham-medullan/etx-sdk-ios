//
//  SearchFilter.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 1/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

class SearchFilter {
    
    enum SortOrder: String {
        case ASC = "asc"
        case DESC = "desc"
    }
    
    var whereCondtions: [Condition]?
    private var limit: Int?
    
    init() {
    }
    
    init(conditions: [Condition]) {
        self.whereCondtions = conditions
    }
    
    public func setLimit(_ limit: Int) {
        self.limit = limit
    }
    
    public func sortBy(_ property: String, order: SortOrder) {
        
    }
    
    func toString() -> String {
        var s = ""
        for condition in self.whereCondtions! {
            s = s + "filter[where]" + condition.toString() + "&"
        }
        return s
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
        if let limit = self.limit {
            q["limit"] = limit
        }
        return q
    }
    
    func toJsonString() -> String {
        return self.toJson().printJson()
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
