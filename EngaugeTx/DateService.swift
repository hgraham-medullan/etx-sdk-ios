//
//  DateService.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
class DateService {
    static func getCurrentTimeZoneOffset() -> Float {
        return Float(TimeZone.current.secondsFromGMT())/(60*60)
    }
    
    static func getCurrentTimeZoneName() -> String {
        return TimeZone.current.identifier
    }
    
    static func subtractTimeframe(timeframe: ETXTrendTimeframe, date: Date) -> Date {
        var dateComponent = DateComponents()

        switch timeframe {
        case .OneMonth:
            dateComponent.month = -29
        case .OneWeek:
            dateComponent.day = -6
        case .TwoWeeks:
            dateComponent.day = -13
        }
        
        return Calendar.current.date(byAdding: dateComponent, to: date)!
    }
    
    static func setToMidnight(_ date: Date) -> Date {
        return Calendar.startOfDay(Calendar.current)(for: date)
    }
    
    static func setToEndOfDay(_ date: Date) -> Date {
        return DateService.updateTimePart(of: date, hour: 23, minute: 59, second: 59, nanosecond: 9)
    }
    
    private static func updateTimePart(of date: Date, hour: Int, minute: Int, second: Int, nanosecond: Int) -> Date {
        var updatedDate = Calendar.current.date(bySetting: Calendar.Component.hour, value: hour, of: date)!
        updatedDate = Calendar.current.date(bySetting: Calendar.Component.minute, value: minute, of: updatedDate)!
        updatedDate = Calendar.current.date(bySetting: Calendar.Component.second, value: second, of: updatedDate)!
        //updatedDate = Calendar.current.date(bySetting: Calendar.Component.nanosecond, value: nanosecond, of: updatedDate)!
        return updatedDate
    }
}
