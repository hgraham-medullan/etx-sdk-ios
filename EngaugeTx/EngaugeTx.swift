//
//  EngaugeTx.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 11/28/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Google

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
public class EngaugeTxApplication: NSObject, GGLInstanceIDDelegate, GCMReceiverDelegate {
    static var appId: String!
    static var clientKey: String!
    static var baseUrl: String!
    
    private static let KEY_APP_ID: String = "appId"
    private static let KEY_CLIENT_KEY: String = "clientKey"
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
     */
    public init(appId: String, clientKey: String, baseUrl: String, application: UIApplication?) {
        super.init()
        EngaugeTxApplication.baseUrl = baseUrl
        EngaugeTxApplication.appId = appId
        EngaugeTxApplication.clientKey = clientKey
        self.application = application
        //let appDelegate = UIApplication.shared.delegate as! EngaugeTxAppDelegate
        //let aVariable = appDelegate.someVariable
    }
    
    public convenience init(appId: String, clientKey: String, baseUrl: String) {
        self.init(appId: appId, clientKey: clientKey, baseUrl: baseUrl, application: nil)
    }
    
    /**
     Sets up an EngaugeTx Application with your credentials
     - parameter appId: The application's ID
     - parameter clientKey: The application's client Key
     */
    public convenience init(appId: String, clientKey: String) {
        self.init(appId: appId, clientKey: clientKey,
                  baseUrl: EngaugeTxApplication.DEFAULT_BASE_URL, application: nil)
        if let application = application {
            self.application(application, didFinishLaunchingWithOptions: nil)
        }
    }
    
    public convenience init(application: UIApplication?) {
        if let appId = EngaugeTxApplication.getValueForKey(key: EngaugeTxApplication.KEY_APP_ID),
            let clientKey = EngaugeTxApplication.getValueForKey(key: EngaugeTxApplication.KEY_CLIENT_KEY),
            let baseUrl = EngaugeTxApplication.getValueForKey(key: EngaugeTxApplication.KEY_BASE_URL) {
            self.init(appId: appId, clientKey: clientKey, baseUrl: baseUrl, application: application)
        } else {
            self.init(appId: "", clientKey: "")
        }
    }
    
    /// Sets up an EngaugeTx Application with credentials stored in your Plist file
    public convenience override init() {
        self.init(application: nil)
    }
    
    static func getValueForKey(key: String) -> String? {
        return getValueForKey(key: key, plistFileName: CONFIG_FILENAME)
    }
    
    static func getValueForKey(key: String, plistFileName: String) -> String? {
        var value: String?
        guard let path = Bundle.main.path(forResource: plistFileName, ofType: CONFIG_FILE_TYPE) else {
            print("The file was not found")
            return nil
        }
        print("The path \(path)")
        if let keys = NSDictionary(contentsOfFile: path), let keyValue = keys.value(forKey: key) {
            value = keyValue as? String
        }
        return value
    }
    
    var window: UIWindow?
    
    var connectedToGCM = false
    var subscribedToTopic = false
    var gcmSenderID: String?
    var registrationToken: String?
    var registrationOptions = [String: AnyObject]()
    
    let registrationKey = "onRegistrationCompleted"
    let messageKey = "onMessageReceived"
    let subscriptionTopic = "/topics/global"
    
    // [START register_for_remote_notifications]
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)  {
        // [START_EXCLUDE]
        // Configure the Google context: parses the GoogleService-Info.plist, and initializes
        // the services that have entries in the file
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        // [END_EXCLUDE]
        // Register for remote notifications
        if #available(iOS 8.0, *) {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            // Fallback
            let types: UIRemoteNotificationType = [.alert, .badge, .sound]
            application.registerForRemoteNotifications(matching: types)
        }
        
        // [END register_for_remote_notifications]
        // [START start_gcm_service]
        let gcmConfig = GCMConfig.default()
        gcmConfig?.receiverDelegate = self
        GCMService.sharedInstance().start(with: gcmConfig)
        // [END start_gcm_service]
//        /return true
    }
    
    func subscribeToTopic() {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        if registrationToken != nil && connectedToGCM {
            GCMPubSub.sharedInstance().subscribe(withToken: self.registrationToken, topic: subscriptionTopic,
                                                 options: nil, handler: { error -> Void in
                                                    if let error = error as? NSError {
                                                        // Treat the "already subscribed" error more gently
                                                        if error.code == 3001 {
                                                            print("Already subscribed to \(self.subscriptionTopic)")
                                                        } else {
                                                            print("Subscription failed: \(error.localizedDescription)")
                                                        }
                                                    } else {
                                                        self.subscribedToTopic = true
                                                        NSLog("Subscribed to \(self.subscriptionTopic)")
                                                    }
            })
        }
    }
    
    // [START connect_gcm_service]
    func applicationDidBecomeActive( _ application: UIApplication) {
        // Connect to the GCM server to receive non-APNS notifications
        GCMService.sharedInstance().connect(handler: { error -> Void in
            if let error = error as? NSError {
                print("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                self.connectedToGCM = true
                print("Connected to GCM")
                // [START_EXCLUDE]
                self.subscribeToTopic()
                // [END_EXCLUDE]
            }
        })
    }
    // [END connect_gcm_service]
    // [START disconnect_gcm_service]
    func applicationDidEnterBackground(_ application: UIApplication) {
        GCMService.sharedInstance().disconnect()
        // [START_EXCLUDE]
        self.connectedToGCM = false
        // [END_EXCLUDE]
    }
    // [END disconnect_gcm_service]
    // [START receive_apns_token]
    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: Data ) {
        // [END receive_apns_token]
        // [START get_gcm_reg_token]
        // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
        let instanceIDConfig = GGLInstanceIDConfig.default()
        instanceIDConfig?.delegate = self
        // Start the GGLInstanceID shared instance with that config and request a registration
        // token to enable reception of notifications
        GGLInstanceID.sharedInstance().start(with: instanceIDConfig)
        registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken as AnyObject,
                               kGGLInstanceIDAPNSServerTypeSandboxOption:true as AnyObject]
        GGLInstanceID.sharedInstance().token(withAuthorizedEntity: gcmSenderID,
                                             scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
        // [END get_gcm_reg_token]
    }
    
    // [START receive_apns_token_error]
    func application( _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: Error ) {
        print("Registration for remote notification failed with error: \(error.localizedDescription)")
        // [END receive_apns_token_error]
        let userInfo = ["error": error.localizedDescription]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: registrationKey), object: nil, userInfo: userInfo)
    }
    
    // [START ack_message_reception]
    func application( _ application: UIApplication,
                      didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("Notification received: \(userInfo)")
        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo)
        // Handle the received message
        // [START_EXCLUDE]
        NotificationCenter.default.post(name: Notification.Name(rawValue: messageKey), object: nil,
                                        userInfo: userInfo)
        // [END_EXCLUDE]
    }
    
    func application( _ application: UIApplication,
                      didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                      fetchCompletionHandler handler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Notification received: \(userInfo)")
        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo)
        // Handle the received message
        // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
        // [START_EXCLUDE]
        NotificationCenter.default.post(name: Notification.Name(rawValue: messageKey), object: nil,
                                        userInfo: userInfo)
        handler(UIBackgroundFetchResult.noData)
        // [END_EXCLUDE]
    }
    // [END ack_message_reception]
    func registrationHandler(_ registrationToken: String?, error: Error?) {
        if let registrationToken = registrationToken {
            self.registrationToken = registrationToken
            print("Registration Token: \(registrationToken)")
            self.subscribeToTopic()
            let userInfo = ["registrationToken": registrationToken]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: self.registrationKey), object: nil, userInfo: userInfo)
        } else if let error = error {
            print("Registration to GCM failed with error: \(error.localizedDescription)")
            let userInfo = ["error": error.localizedDescription]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: self.registrationKey), object: nil, userInfo: userInfo)
        }
    }
    
    // [START on_token_refresh]
    public func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        print("The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().token(withAuthorizedEntity: gcmSenderID,
                                             scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    // [END on_token_refresh]
    // [START upstream_callbacks]
    public func willSendDataMessage(withID messageID: String!, error: Error!) {
        if error != nil {
            // Failed to send the message.
        } else {
            // Will send message, you can save the messageID to track the message
        }
    }
    
    public func didSendDataMessage(withID messageID: String!) {
        // Did successfully send message identified by messageID
    }
    // [END upstream_callbacks]
    public func didDeleteMessagesOnServer() {
        // Some messages sent to this device were deleted on the GCM server before reception, likely
        // because the TTL expired. The client should notify the app server of this, so that the app
        // server can resend those messages.
    }
}
