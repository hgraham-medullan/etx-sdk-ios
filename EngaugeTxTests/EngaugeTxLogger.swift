//
//  EngaugeTxLogger.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 8/25/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import SwiftyBeaver

class EngaugeTxLogTests : ETXTestCase {
    
    func testEngaugeTxLogLevelsShouldMatchSwiftyBeaver() {
        XCTAssertEqual(LogLevel.error.value, SwiftyBeaver.Level.error.rawValue, "EngaugeTx error log level must match SwiftyBeaver's error log level")
        XCTAssertEqual(LogLevel.warn.value, SwiftyBeaver.Level.warning.rawValue, "EngaugeTx warn log level must match SwiftyBeaver's Info warning level")
        XCTAssertEqual(LogLevel.info.value, SwiftyBeaver.Level.info.rawValue, "EngaugeTx Info log level must match SwiftyBeaver's Info log level")
        XCTAssertEqual(LogLevel.debug.value, SwiftyBeaver.Level.debug.rawValue, "EngaugeTx Info debug level must match SwiftyBeaver's Info debug level")
        XCTAssertEqual(LogLevel.trace.value, SwiftyBeaver.Level.verbose.rawValue, "EngaugeTx trace log level must match SwiftyBeaver's Info verbose level")
    }
    
    func testWhenTheApplicationIsInitializedThenTheConsoleShouldBeAddedAsADestination() {
        XCTAssertTrue(SwiftyBeaver.destinations.contains(EngaugeTxApplication.consoleLogDestination!), "The console should be added a log destination")
    }
    
    func testWhenTheApplicationIsInitializedThenItShouldContainATotalOfOneLogDestination() {
        XCTAssertEqual(SwiftyBeaver.destinations.count, 1, "There should only be one added log destination")
    }
}
