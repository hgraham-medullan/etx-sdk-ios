//
//  DateTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 2/9/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper
import XCTest
@testable import EngaugeTx

class Person: ETXGenericDataObject {
    var dob: Date? = Date()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        dob <- (map["birthday"], ETXDateTransform())
    }
    
}

class DateTests : ETXTestCase {
    
    let minus5Timezone = -5*(60*60)
    var person: Person!
    var dateOfBirth: Date!
    
    override func setUp() {
        super.setUp()
        self.person = Person()
        
        var dateComponents = DateComponents()
        dateComponents.year = 1980
        dateComponents.month = 7
        dateComponents.day = 11
        dateComponents.timeZone = TimeZone(secondsFromGMT: minus5Timezone)
        dateComponents.hour = 12
        dateComponents.minute = 30
        dateComponents.second = 0
        dateComponents.nanosecond = 0
        
        let userCalendar = Calendar.current // user calendar
        self.dateOfBirth = userCalendar.date(from: dateComponents)!
    
        self.person.dob = self.dateOfBirth
        
    }
    
    func testDateFormatWhenItIsBeingConvertedToJson() {

        let personAsString: String = self.person.toJSONString()!
        XCTAssertEqual("{\"birthday\":\"1980-07-11T17:30:00.0Z\",\"className\":\"Person\"}",
                       personAsString)
    }
    
    func testDateFormatFromJson() {
        let p: Person? = Mapper<Person>()
            .map(JSONString: "{\"birthday\":\"1980-07-11T17:30:00.0Z\",\"className\":\"Person\"}")
        XCTAssertEqual(self.dateOfBirth, p?.dob)
    }
    
    func testDateWhenUsingASeachFilter() {
        let condition = ETXWhereCondition(property: "dateOfBirth", comparator: .gte, value: self.dateOfBirth)
        let searchFilter = ETXSearchFilter(condition: condition)
        XCTAssertEqual("{\"where\":{\"dateOfBirth\":{\"gte\":\"1980-07-11T17:30:00.0Z\"}}}"	, searchFilter.toJsonString())
    }
}
