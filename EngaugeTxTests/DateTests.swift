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
        
        // toJSONString sometimes returns properties in random order, and therefore may cause string comparison errors.
        XCTAssertTrue(personAsString.contains("\"birthday\":\"1980-07-11T17:30:00.0Z\""), "Serialized object should include correct date format")
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
    
    func testSubtractDaysWhenTheTimeframeIsOneWeek() {
        
        var dateComponents = DateComponents()
        dateComponents.year = 2017
        dateComponents.month = 3
        dateComponents.day = 12
        dateComponents.hour = 15
        dateComponents.minute = 30
        dateComponents.second = 0
        dateComponents.nanosecond = 0
        
        let userCalendar = Calendar.current // user calendar
        let date = userCalendar.date(from: dateComponents)!
        
        let d = DateService.subtractTimeframe(timeframe: .OneWeek, date: date)
        
        XCTAssertEqual("2017-03-06T15:30:00.0", d.toTxDateFormat(convertToUTC: false))
    }
    
    func testSubtractDaysWhenTheTimeframeIsTwoWeeks() {
        
        var dateComponents = DateComponents()
        dateComponents.year = 2017
        dateComponents.month = 3
        dateComponents.day = 12
        dateComponents.hour = 15
        dateComponents.minute = 30
        dateComponents.second = 0
        dateComponents.nanosecond = 0
        
        let userCalendar = Calendar.current // user calendar
        let date = userCalendar.date(from: dateComponents)!
        
        let d = DateService.subtractTimeframe(timeframe: .TwoWeeks, date: date)
        
        XCTAssertEqual("2017-02-27T15:30:00.0", d.toTxDateFormat(convertToUTC: false))
    }
    
    func testSetToMidnight() {
        XCTAssertEqual("1980-07-11T00:00:00.0", DateService.setToMidnight(self.dateOfBirth).toTxDateFormat(convertToUTC: false))
    }
    
    func testSetEndOfDay() {        
        XCTAssertEqual("1980-07-11T23:59:59.0", DateService.setToEndOfDay(self.dateOfBirth).toTxDateFormat(convertToUTC: false))
    }
    
    class GdoWithDateProp: ETXGenericDataObject  {
        var dateProp: Date?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            dateProp <- (map["dateProp"], ETXDateOnlyTransform())
        }
    }
    
    func testEtxDateOnlyTransformWhenTheDateFormatIsZulu() {
        let dob: Date = person.dob!
        let dobAsUtc: String = dob.toTxDateFormat(convertToUTC: true)!
        let jsonString: String = "{\"dateProp\":\"\(dobAsUtc)\"}"
        let gdoWithDateProp = Mapper<GdoWithDateProp>().map(JSONString: jsonString);
        XCTAssertNotNil(gdoWithDateProp?.dateProp, "Date should be populated")
        if let dateInLocalTime = gdoWithDateProp?.dateProp?.toTxDateFormat(convertToUTC: false) {
            XCTAssertEqual("1980-07-11T00:00:00.0", dateInLocalTime)
        }
    }
    
    func testEtxDateOnlyTransformWhenTheDateFormatIsShort() {
        let gdoWithDateProp = Mapper<GdoWithDateProp>().map(JSONString: "{\"dateProp\":\"1980-07-11\"}");
        XCTAssertNotNil(gdoWithDateProp?.dateProp, "Date should be populated")
        if let dateInLocalTime = gdoWithDateProp?.dateProp?.toTxDateFormat(convertToUTC: false) {
            XCTAssertEqual("1980-07-11T00:00:00.0", dateInLocalTime)
        }
    }

}
