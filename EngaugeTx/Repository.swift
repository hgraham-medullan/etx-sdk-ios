//
//  Repository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/6/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta
import ObjectMapper

class Repository<T: ETXModel> : Service {
    
    private let KEY_HEADER_APP_ID: String = "app-id"
    private let KEY_HEADER_CLIENT_KEY: String = "client-key"
    private let KEY_HEADER_AUTHORIZATION: String = "Authorization"
    private let KEY_DEFAULTS_ACCESS_TOKEN: String = "accessToken"
    private let KEY_DEFAULTS_USER_ID: String = "userId"
    private let KEY_DEFAULTS_CURRENT_USER: String = "currentUser"
    
    var resourcePath: String
    var etxResource: Resource {
        return resource(resourcePath)
    }
    
    init(resourcePath: String) {
        self.resourcePath = resourcePath
        super.init(baseURL:EngaugeTxApplication.baseUrl)
        configure {
            
            $0.headers[self.KEY_HEADER_APP_ID] = EngaugeTxApplication.appId
            $0.headers[self.KEY_HEADER_CLIENT_KEY] = EngaugeTxApplication.clientKey
            $0.headers[self.KEY_HEADER_AUTHORIZATION] = self.getAccessToken()
        }
    
        configureTransformer("/users/**") {
            Mapper<T>().map(JSON: $0.content)
            
        }
    }
    
    func save(model: T) {
        if let _ = model.id {
            self.update(model: model)
        } else {
            let _ = self.etxResource.request(.post, json: model as! JSONConvertible)
        }
    }
    
    private func update(model: T) {
        if let id = model.id {
            let _ = self.etxResource.child(id).request(.put, json: model as! JSONConvertible)
        }
    }
    
    func delete(model: T) {
        if let id = model.id {
            let _  = self.etxResource.child(id).request(.delete)
        }
    }
    
    func get(id: String) -> Void {
        let _  = self.etxResource.child(id)
    }
    
    func getAccessToken() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: self.KEY_DEFAULTS_ACCESS_TOKEN)
    }
    
    func saveCurrentUser(_ accessToken: ETXAccessToken?) {
        let defaults = UserDefaults.standard
        let currentUser: [String: String?] =
            [KEY_DEFAULTS_USER_ID: accessToken?.userId,
             KEY_DEFAULTS_ACCESS_TOKEN: accessToken?.id]
        defaults.set(currentUser, forKey: KEY_DEFAULTS_CURRENT_USER)
    }

    func deleteCurrentUser() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: self.KEY_DEFAULTS_CURRENT_USER)
    }
}
