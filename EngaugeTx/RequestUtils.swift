//
//  RequestUtils.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 1/18/18.
//  Copyright © 2018 Medullan Platform Solutions. All rights reserved.
//

import Foundation

class ETXRequestUtils {
    static func jsonStringToDictionary(json: String) -> [String: Any]? {
        if let data = json.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                EngaugeTxLog.error("Failed to parse '\(json)' as a JSON object: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    static func convertJSONDataToString(_ jsonData: [String : Any]?) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonData, options:[])
            let convertedString = String(data: data, encoding: String.Encoding.utf8)
            return convertedString!
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }
    
    static func queryToDictionary(query: String?) -> [String: String] {
        var queryStrings = [String: String]()
        guard let query = query else {
            return queryStrings
        }
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
}
