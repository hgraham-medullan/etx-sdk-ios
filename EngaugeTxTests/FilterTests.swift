//
//  FilterTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/23/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest

class FilterTests: XCTestCase {
    class Filter {
        let wf = WhereFilter()
        
        var json: [String: Any] = [String: Any]()
        
        enum WhereCondition {
            case gt(String)
            case gte(String)
            case lt(String)
            case lte(String)
            case eq(String)
        }
        
        class Combinator {
            let f = Filter()
            
            func and(_ filter: WhereFilter?) {
                
            }
            
            func or(_ filter: WhereFilter) {
                
            }
            
            func and() -> Filter  {
                return f
            }
        }
        
        class WhereFilter {
            
            var itemAdded: ((_ comparator: String,  _ value: String) -> Void)?
            
            let combinator = Combinator()
            
            func gt() -> Combinator {
                return combinator
            }
            func gte() -> Combinator {
                return combinator
            }
            func lt() -> Combinator {
                return combinator
            }
            func lte() -> Combinator {
                return combinator
            }
            
            func eq(_ val: String) -> Combinator {
                if let itemAdded = itemAdded {
                    itemAdded("eq", val)
                }
                return combinator
            }
            
            
        }
        
        func Where(_ property: Any) -> WhereFilter {
            json["where"] = property
            return wf
        }
    }
    
    func testX() {
        let w = Filter()
        w.Where("firstName").eq("sean").and(nil)
        
        w.Where("firstName").eq("sean").and()
            .Where("lastName").eq("Hoilett")
    }
}
