//
//  DeviceToken.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 2/4/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 The device token used for receiving push notifications
 */
public class ETXDeviceToken: ETXModel {
    
    var type: String = "ios"
    var token: String
    
    private var _pushNotificationSvc: PushNotificationService?
    
    var pushNotificationSvc: PushNotificationService {
        if self._pushNotificationSvc == nil {
            self._pushNotificationSvc = PushNotificationService()
        }
        return self._pushNotificationSvc!
    }
    
    /**
     Create a new instance
     - parameter token: The device's token for receiving push notifications
    */
    public init(token: String) {
        self.token = token
        super.init()
    }
    
    required public init?(map: Map) {
        self.token = ""
        super.init(map: map)
    }
    
    /**
     Describes how the object should be desearialized
     - parameter map: The data as a Map
     */
    override open func mapping(map: Map) {
        super.mapping(map: map)
        self.type <- map["type"]
        self.token <- map["token"]
    }
    
    public func save(completion: @escaping (ETXError?) -> Void) {
        self.pushNotificationSvc.save(model: self) {
            (model, err) in
            if let model = model {
                let map = Map(mappingType: .fromJSON, JSON: model.rawJson!)
                self.mapping(map: map)
            }
            completion(err)
        }
        
    }
}
