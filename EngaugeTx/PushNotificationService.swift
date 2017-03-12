//
//  PushNotificationService.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 2/4/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
class PushNotificationService: ETXDataService<ETXDeviceToken> {
    
    var deviceTokenRepository: Repository<ETXDeviceToken>
    
    init() {
        let deviceTokenResourcePath = "/notifications/token"
        self.deviceTokenRepository = Repository<ETXDeviceToken>(resourcePath: deviceTokenResourcePath)
        super.init(repository: deviceTokenRepository)
    }
    
    override func save(model: ETXDeviceToken, completion: @escaping (ETXDeviceToken?, ETXError?) -> Void) {
        super.save(model: model) {
            (deviceToken, err) in
            if let err = err {
                // TODO: Cleanup after DE131 is fixed. https://rally1.rallydev.com/#/48675326525ud/detail/defect/98692948668
                if let errCode = err.code, errCode == ETXError.CODE_DUPLICATE_KEY_ERROR {
                    model.rawJson = model.toJSON()
                    completion(model, nil)
                } else {
                    completion(nil, err)
                }
            } else {
                completion(deviceToken, nil)
            }
        }
    }
    
}
