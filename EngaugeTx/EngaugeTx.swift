//
//  EngaugeTx.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 11/28/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation

/**
 Protocol to be extended by the app delegate to be able to bootstrap your
 application with EngaugeTx
 */
public protocol EngaugeTxAppDelegate {
    
    /**
     
     */
    var engaugeTx: EngaugeTxApplication? { get set }
    
}

/**
 Representation of you application in the EngaugeTx platform
 */
public class EngaugeTxApplication {
    var appId: String
    var clientKey: String
    var baseUrl: String
    
    static let KEY_APP_ID: String = "appId"
    static let KEY_CLIENT_KEY: String = "clientKey"
    static let KEY_BASE_URL: String = "baseUrl"
    static let CONFIG_FILENAME = "EngaugeTx"
    static let CONFIG_FILE_TYPE = "plist"
    static let DEFAULT_BASE_URL = "https://api.eu1.engaugetx.com/v1"
    
    /**
     
     */
    public init(appId: String, clientKey: String, baseUrl: String) {
        self.baseUrl = baseUrl
        self.appId = appId
        self.clientKey = clientKey
    }
    
    /**
     Sets up an EngaugeTx Application with your credentials
     
     - parameter appId: The application's ID
     - parameter clientKey: The application's client Key
     */
    public convenience init(appId: String, clientKey: String) {
        self.init(appId: appId, clientKey: clientKey,
                  baseUrl: EngaugeTxApplication.DEFAULT_BASE_URL)
    }
    
    /// Sets up an EngaugeTx Application with credentials stored in your Plist file
    public convenience init() {
        if let appId = EngaugeTxApplication.getValueForKey(key: EngaugeTxApplication.KEY_APP_ID),
            let clientKey = EngaugeTxApplication.getValueForKey(key: EngaugeTxApplication.KEY_CLIENT_KEY),
            let baseUrl = EngaugeTxApplication.getValueForKey(key: EngaugeTxApplication.KEY_BASE_URL) {
            self.init(appId: appId, clientKey: clientKey, baseUrl: baseUrl)
        } else {
            self.init(appId: "", clientKey: "")
        }
    }
    
    static func getValueForKey(key: String) -> String? {
        var value: String?
        if let path = Bundle.main.path(forResource: CONFIG_FILENAME, ofType: CONFIG_FILE_TYPE) {
            if let keys = NSDictionary(contentsOfFile: path), let keyValue = keys.value(forKey: key) {
                value = keyValue as? String
                print(keyValue)
            }
        }
        return value
    }
}
