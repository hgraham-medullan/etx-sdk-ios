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
    
}
