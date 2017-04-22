//
//  StringUtils.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

class ETXStringUtils {
    static let EMPTY = ""
    static let COMMA = ","
    
    static func join(strings: [String]?) -> String{
        return join(strings: strings, delimiter: nil)
    }
    
    static func join(strings: [String]?, delimiter: String?) -> String{
        var result: String = EMPTY
        var d = delimiter
        if d == nil {
            d = EMPTY
        }
        strings?.forEach {
            (t) in
            if result.characters.count > 0 {
                result.append(d!)
            }
            result.append(t)
        }
        return result
    }
}
