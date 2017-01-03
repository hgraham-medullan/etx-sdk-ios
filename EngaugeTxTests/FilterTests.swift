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
    
    class Combinator {
        
        var parentFilter: Filter
        
        init(parentFilter: Filter) {
            self.parentFilter = parentFilter
        }
        
        func or(_ filter: WhereFilter) {
            
        }
        
        func and(_ propertyName: String) -> WhereFilter  {
            return WhereFilter(propertyName: propertyName, parentFilter: self.parentFilter)
        }
    }
    
    class WhereFilter {
        
        enum Comparator: String {
            case gt = "gt"
            case gte
            case lt
            case lte
            case eq
        }
        
        var propertyName: String
        var comparator: Comparator?
        var value: String?
        var parentFilter: Filter
        
        var itemAdded: ((_ comparator: Comparator,  _ value: String) -> Void)?
        
        let combinator: Combinator
        
        init(propertyName: String, parentFilter: Filter) {
            self.propertyName = propertyName
            self.parentFilter = parentFilter
            self.combinator = Combinator(parentFilter: parentFilter)
            self.parentFilter.whereFilters.append(self)
        }
        
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
            fireAddItem(.eq, val)
            return combinator
        }
        
        func fireAddItem(_ comparator: Comparator, _ value: String) {
            self.comparator = comparator
            self.value = value
            if let itemAdded = itemAdded {
                itemAdded(comparator, value)
            }

        }
        
        func toString() -> String {
            guard let comparator = self.comparator, let value = self.value else {
                    return ""
            }
            return "filter[where][\(propertyName)]=\(value)"
            
        }

        
    }
    
    class Filter {
        var whereFilters: [WhereFilter] = [WhereFilter]()
        
        //var json: [String: Any] = [String: Any]()
        
        func Where(_ property: Any) -> WhereFilter {
            //json["where"] = property
            let wf = WhereFilter(propertyName: property as! String, parentFilter: self)
            return wf
        }
        
        private func or() {
            
        }
        
        func toString() -> String {
            var f = ""
            var i: Int = 0
            for whereFilter in whereFilters {
                print(index)
                if i>0 {
                    f = f + "&"
                }
                f = f + whereFilter.toString()
                print(whereFilter.toString())
                i = i + 1
            }
            return f
        }
    }
    
    func testFilterWhenThereAreThreeMultipleConditionsUsingAnd() {
        let filter = Filter()
        filter.Where("firstName").eq("sean").and("lastName").eq("Hoilett")
        let expectedString = "filter[where][firstName]=sean&filter[where][lastName]=Hoilett"
        XCTAssertEqual(expectedString, filter.toString())
    }
    
    func testFilterWhenThereAreTwoMultipleConditionsUsingAnd() {
        let filter = Filter()
        filter.Where("firstName").eq("sean").and("lastName").eq("Hoilett")
        let expectedString = "filter[where][firstName]=sean&filter[where][lastName]=Hoilett"
        XCTAssertEqual(expectedString, filter.toString())
    }
    
    func testFilterWhenThereIsOnlyOneCondition() {
        let filter = Filter()
        filter.Where("firstName").eq("sean")
        let expectedString = "filter[where][firstName]=sean"
        XCTAssertEqual(expectedString, filter.toString())
    }
    
    func testUrl() {
        let url = URL(string: "/?q=searc&b=1")
        print(url?.query)
        
//        let urlR = URLRequest(url: )
        
        print(url)
    }
}
