//
//  EngaugeTxLogger.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 8/25/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import SwiftyBeaver

/**
 The level of logs to output
 */
public enum LogLevel: Int {
    
    /**
     The most serious and highest priority log level. Use this only when your 
     app has triggered a serious error.
     */
    case error
    
    /**
     Use this log level to show logs that would reach a condition that won’t 
     necessarily cause a problem but strongly leads the app in that direction.
     */
    case warn
    
    /**
     This is typically used for information useful in a more general support 
     context. In other words, info that is useful for non developers looking 
     into issues.
     */
    case info
    
    /**
     Use this level for printing variables and results that will help you fix a 
     bug or solve a problem.
     */
    case debug
    
    /**
     The lowest priority level. Use this one for contextual information.
     */
    case trace
    
    var value: Int {
        switch self {
        case .error: return SwiftyBeaver.Level.error.rawValue
        case .warn: return SwiftyBeaver.Level.warning.rawValue
        case .info: return SwiftyBeaver.Level.info.rawValue
        case .debug: return SwiftyBeaver.Level.debug.rawValue
        case .trace: return SwiftyBeaver.Level.verbose.rawValue
        }
    }
    
}

class EngaugeTxLog {
    
    static func error(_ message: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line, context: Any? = nil) {
        SwiftyBeaver.self.error(message, file, function, line: line, context: context)
    }
    
    static func warn(_ message: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        SwiftyBeaver.self.warning(message, file, function, line: line)
    }
    static func info(_ message: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line, context: Any? = nil) {
        SwiftyBeaver.self.info(message, file, function, line: line, context: context)
    }
    static func debug(_ message: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line, context: Any? = nil) {
        SwiftyBeaver.self.debug(message, file, function, line: line, context: context)
    }
    static func trace(_ message: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line, context: Any? = nil) {
        SwiftyBeaver.self.verbose(message, file, function, line: line, context: context)
    }
}
