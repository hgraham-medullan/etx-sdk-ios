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
     Reference to the EngaugeTx Application
     */
    var engaugeTx: EngaugeTxApplication? { get set }
    
}

public extension EngaugeTxAppDelegate {
    
}

/**
 Representation of you application in the EngaugeTx platform
 */
public class EngaugeTxApplication {
    static var appId: String!
    static var clientKey: String!
    static var baseUrl: String!
    static var defaultTTL: Int?
    static var rememberMeTTL: Int?
    
    private static let KEY_APP_ID: String = "appId"
    private static let KEY_CLIENT_KEY: String = "clientKey"
    private static let KEY_LOGIN_DEFUALT_TTL: String = "defaultTTL"
    private static let KEY_LOGIN_REMEMBER_ME_TTL: String = "rememberMeTTL"
    private static let KEY_BASE_URL: String = "baseUrl"
    private static let CONFIG_FILENAME = "EngaugeTx"
    private static let CONFIG_FILE_TYPE = "plist"
    private static let DEFAULT_BASE_URL = "https://api.us1.engaugetx.com/v1"
    
    private var application: UIApplication?
    
    /**
     Create an instance of an EngaugeTx Application
     - parameter appId: The application's ID
     - parameter clientKey: The application's client key
     - parameter baseUrl: The base url to the EngaugeTx API. Defaults to https://api.us1.engaugetx.com/v1
     - parameter application: The UIApplication
     */
    public init(appId: String, clientKey: String, baseUrl: String, defaultTTL: Int?, rememberMeTTL: Int?, application: UIApplication?) {
        EngaugeTxApplication.baseUrl = baseUrl
        EngaugeTxApplication.appId = appId
        EngaugeTxApplication.clientKey = clientKey
        EngaugeTxApplication.defaultTTL = defaultTTL
        EngaugeTxApplication.rememberMeTTL = rememberMeTTL
        self.application = application
        //let appDelegate = UIApplication.shared.delegate as! EngaugeTxAppDelegate
        //let aVariable = appDelegate.someVariable
    }
    
    /**
     Create an instance of an EngaugeTx Application
     - parameter appId: The application's ID
     - parameter clientKey: The application's client key
     - parameter baseUrl: The base url to the EngaugeTx API. Defaults to https://api.us1.engaugetx.com/v1
     */
    public convenience init(appId: String, clientKey: String, baseUrl: String) {
        self.init(appId: appId,
                  clientKey: clientKey,
                  baseUrl: baseUrl,
                  defaultTTL: nil,
                  rememberMeTTL: nil,
                  application: nil)
    }
    
    
    /// Create an instance of an EngaugeTx Application
    ///
    /// - Parameters:
    ///   - appId: The application's ID
    ///   - clientKey: The application's client key
    ///   - baseUrl: The base url to the EngaugeTx API. Defaults to https://api.us1.engaugetx.com/v1
    ///   - defaultTTL: The default time to live (TTL) for the user's access token
    ///   - rememberMeTTL: The time to live (TTL) for the user's access token when remember me is selected
    public convenience init(appId: String, clientKey: String, baseUrl: String, defaultTTL: Int?, rememberMeTTL: Int?) {
        self.init(appId: appId,
                  clientKey: clientKey,
                  baseUrl: baseUrl,
                  defaultTTL: defaultTTL,
                  rememberMeTTL: rememberMeTTL,
                  application: nil)
    }
    
    /**
     Sets up an EngaugeTx Application with your credentials
     - parameter appId: The application's ID
     - parameter clientKey: The application's client Key
     */
    public convenience init(appId: String, clientKey: String) {
        self.init(appId: appId,
                  clientKey: clientKey,
                  baseUrl: EngaugeTxApplication.DEFAULT_BASE_URL,
                  defaultTTL: nil,
                  rememberMeTTL: nil,
                  application: nil)
    }
    
    /**
     Create an instance of an EngaugeTx Application
     - parameter application: The UIApplication
     */
    public convenience init(application: UIApplication?) {
        if let appId: String = EngaugeTxApplication.getValueForKey(key: EngaugeTxApplication.KEY_APP_ID),
            let clientKey: String = EngaugeTxApplication.getValueForKey(key: EngaugeTxApplication.KEY_CLIENT_KEY),
            let baseUrl: String = EngaugeTxApplication.getValueForKey(key: EngaugeTxApplication.KEY_BASE_URL){
            
            let defaultTTL: Int? = EngaugeTxApplication.getValueForKey(key: EngaugeTxApplication.KEY_LOGIN_DEFUALT_TTL)
            let rememberMeTTL: Int? = EngaugeTxApplication.getValueForKey(key: EngaugeTxApplication.KEY_LOGIN_REMEMBER_ME_TTL)
            
            self.init(appId: appId,
                      clientKey: clientKey,
                      baseUrl: baseUrl,
                      defaultTTL: defaultTTL,
                      rememberMeTTL: rememberMeTTL,
                      application: application)
        } else {
            self.init(appId: ETXStringUtils.EMPTY, clientKey: ETXStringUtils.EMPTY)
        }
    }
    
    /// Sets up an EngaugeTx Application with credentials stored in your Plist file
    public convenience init() {
        self.init(application: nil)
    }
    
    static func getValueForKey<T>(key: String) -> T? {
        return getValueForKey(key: key, plistFileName: CONFIG_FILENAME)
    }
    
    static func getValueForKey<T>(key: String, plistFileName: String) -> T? {
        var value: T?
        guard let path = Bundle.main.path(forResource: plistFileName, ofType: CONFIG_FILE_TYPE) else {
            print("The file was not found")
            return nil
        }
        print("The path \(path)")
        if let keys = NSDictionary(contentsOfFile: path), let keyValue = keys.value(forKey: key) {
            value = keyValue as? T
        }
        return value
    }
}
