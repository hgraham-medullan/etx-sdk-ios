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
    
//        configureTransformer(resourcePath) {
//            Mapper<T>().map(JSON: $0.content)
//        }
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
                let model = Mapper<T>().map(JSON: m.content as! [String : Any])
                completion(model, nil)
            })
        }
    }
    
    func update(model: T, completion: @escaping (T?, ETXError?)-> Void) {
        if let id = model.id {
            let req = self.etxResource.child(id).request(.put, json: ((model as? ETXModel)?.toJSON())!)
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
    }
    
    func delete(model: T, completion: @escaping (ETXError?) -> Void) {
        if let id = model.id {
            let req  = self.etxResource.child(id).request(.delete)
            req.onFailure({ (err) in
                let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
                etxError?.rawJson = err.jsonDict
                completion(etxError)
            })
            
            req.onSuccess({ (m) in
                completion(nil)
            })
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
    
    func findWhere(_ filter: ETXSearchFilter, completion: @escaping ([T]?, ETXError?) -> Void) {
        let req = self.etxResource.withParam("filter", filter.toJsonString()).request(.get)
        
        req.onFailure({ (err) in
            let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
            etxError?.rawJson = err.jsonDict
            completion(nil, etxError)
        })
        
        req.onSuccess({ (m) in
            var models: [T]?
            if let content = m.content as? [String : Any], let result: [[String : Any]] = content["result"] as! [[String : Any]]?  {
                models = Mapper<T>().mapArray(JSONObject: result)
            } else {
                models = Mapper<T>().mapArray(JSONArray: [m.content as! [String : Any]])
            }
            completion(models, nil)
        })
    }
    
    func getAccessToken() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: self.KEY_DEFAULTS_ACCESS_TOKEN)
    }
    
    func setAccessToken(_ accessToken: String?) {
        let defaults = UserDefaults.standard
        defaults.set(accessToken, forKey: self.KEY_DEFAULTS_ACCESS_TOKEN)
    }
    
    func deleteAccessToken() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: self.KEY_DEFAULTS_ACCESS_TOKEN)
    }
}
