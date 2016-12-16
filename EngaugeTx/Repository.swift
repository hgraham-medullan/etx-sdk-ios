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

class Repository<T> : Service where T: ETXModel {
    
    private let KEY_HEADER_APP_ID: String = "app-id"
    private let KEY_HEADER_CLIENT_KEY: String = "client-key"
    private let KEY_HEADER_AUTHORIZATION: String = "Authorization"
    
    let KEY_DEFAULTS_ACCESS_TOKEN: String = "accessToken"
    
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
    
        configureTransformer(resourcePath) {
            Mapper<T>().map(JSON: $0.content)
        }
    }
    
    func save(model: T, completion: @escaping (T?, ETXError?) -> Void) {
        if let _ = model.id {
            self.update(model: model, completion: completion)
        } else {
            let req = self.etxResource.request(.post, json: ((model as? ETXModel)?.toJSON())!)
            req.onFailure({ (err) in
                let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
                etxError?.rawJson = err.jsonDict
                completion(nil, etxError)
            })
            req.onSuccess({ (m) in
                let n = (m.content as! T)
                completion(n, nil)
            })
        }
    }
    
    private func update(model: T, completion: (T?, ETXError?)-> Void) {
        if let id = model.id {
            let _ = self.etxResource.child(id).request(.put, json: ((model as? ETXModel)?.toJSON())!)
        }
    }
    
    func delete(model: T, completion: (ETXError?) -> Void) {
        if let id = model.id {
            let _  = self.etxResource.child(id).request(.delete)
        }
    }
    
    func getById(_ id: String, completion: @escaping (T?, ETXError?) -> Void) {
        let req  = self.etxResource.child(id).request(.get)
        req.onFailure({ (err) in
            let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
            etxError?.rawJson = err.jsonDict
            completion(nil, etxError)
        })
        req.onSuccess({ (m) in
            let model = Mapper<T>().map(JSON: m.content as! [String : Any])
            completion(model, nil)
        })
    }
    
    func getAccessToken() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: self.KEY_DEFAULTS_ACCESS_TOKEN)
    }
}
