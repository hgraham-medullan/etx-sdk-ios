//
//  FilterTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/23/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper

class FilterTests: XCTestCase {
    
    func testWhenConditionUsesGreaterThan() {
        let searchFilter = SearchFilter(conditions: [
            WhereCondition(property: "age", comparator: .gt, value: 20)
        ])
        
        let expectedJsonString: String = "{\"where\":{\"age\":{\"gt\":20}}}"
        
        XCTAssertEqual(expectedJsonString, searchFilter.toJsonString())
    }
    
    func testWhenConditionUsesGreaterThanOrEqualTo() {
        let searchFilter = SearchFilter(conditions: [
            WhereCondition(property: "age", comparator: .gte, value: 20)
            ])
        
        let expectedJsonString: String = "{\"where\":{\"age\":{\"gte\":20}}}"
        
        XCTAssertEqual(expectedJsonString, searchFilter.toJsonString())
    }
    
    func testWhenConditionUsesLessThan() {
        let searchFilter = SearchFilter(conditions: [
            WhereCondition(property: "age", comparator: .lt, value: 20)
            ])
        
        let expectedJsonString: String = "{\"where\":{\"age\":{\"lt\":20}}}"
        
        XCTAssertEqual(expectedJsonString, searchFilter.toJsonString())
    }
    
    func testWhenConditionUsesLessThanorEqualTo() {
        let searchFilter = SearchFilter(conditions: [
            WhereCondition(property: "age", comparator: .lte, value: 20)
            ])
        
        let expectedJsonString: String = "{\"where\":{\"age\":{\"lte\":20}}}"
        
        XCTAssertEqual(expectedJsonString, searchFilter.toJsonString())
    }
    
    func testWhenFilterUsesLimiting() {
        let searchFilter = SearchFilter()
        searchFilter.setLimit(20)
        XCTAssertEqual("{\"limit\":20}", searchFilter.toJsonString())
    }
    
    func testWhenFilterUsesLimitingWithACondition() {
        let searchFilter = SearchFilter(conditions: [
            WhereCondition(property: "age", comparator: .lte, value: 20)
            ])
        searchFilter.setLimit(20)
        XCTAssertEqual("{\"where\":{\"age\":{\"lte\":20}},\"limit\":20}", searchFilter.toJsonString())
    }
    
    func testWhenFilterUsesAndCombination() {
        let olderThan64 = WhereCondition(property: "age", comparator: .gt, value: 64)
        let females = WhereCondition(property: "gender", comparator: .eq, value: "female")
        
        let femaleRetirees = CombinedCondition(combineType: .and, conditions: [females, olderThan64])
        
        let searchFilter = SearchFilter(conditions: [
            femaleRetirees
        ])
        
        // https://loopback.io/doc/en/lb2/Where-filter.html#and--or
        XCTAssertEqual("{\"where\":{\"and\":[{\"gender\":\"female\"},{\"age\":{\"gt\":64}}]}}", searchFilter.toJsonString())
    }
    
    func testWhenFilterUsesAndCombinationWithOr() {
        let olderThan64 = WhereCondition(property: "age", comparator: .gt, value: 64)
        let females = WhereCondition(property: "gender", comparator: .eq, value: "female")
        let femaleRetirees = CombinedCondition(combineType: .and, conditions: [females, olderThan64])
        
        let olderThan59 = WhereCondition(property: "age", comparator: .gt, value: 59)
        let males = WhereCondition(property: "gender", comparator: .eq, value: "male")
        let maleRetirees = CombinedCondition(combineType: .and, conditions: [males, olderThan59])
        
        let allRetirees = CombinedCondition(combineType: .or, conditions: [maleRetirees, femaleRetirees])
        
        let searchFilter = SearchFilter(conditions: [
            allRetirees
            ])
        
        // https://loopback.io/doc/en/lb2/Where-filter.html#and--or
        XCTAssertEqual("{\"where\":{\"or\":[{\"and\":[{\"gender\":\"male\"},{\"age\":{\"gt\":59}}]},{\"and\":[{\"gender\":\"female\"},{\"age\":{\"gt\":64}}]}]}}", searchFilter.toJsonString())
    }
    
    func testWhenFilterUsesAscendingSorting() {
        let searchFilter = SearchFilter()
        searchFilter.sortBy("age", order: .ASC)
        XCTAssertEqual("{\"order\":\"age ASC\"}", searchFilter.toJsonString())
    }
    
    func testWhenFilterUsesDescendingSorting() {
        let searchFilter = SearchFilter()
        searchFilter.sortBy("age", order: .DESC)
        XCTAssertEqual("{\"order\":\"age DESC\"}", searchFilter.toJsonString())
    }
    
    func testWhenCustomFilterStringIsUsedAllOtherFiltersShouldBeIgnored() {
        let customFilter: String = "\"where\":{\"name\": \"sean\"}"
        let searchFilter = SearchFilter(customFilter: customFilter)
        searchFilter.sortBy("age", order: .DESC)
        XCTAssertEqual(customFilter, searchFilter.toJsonString())
        
    }
}
