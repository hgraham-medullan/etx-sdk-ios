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

/**
 Work around to support 204 responses
 */
struct ChangeEmptyResponseContentType: ResponseTransformer
{
    private let HEADER_CONTENT_TYPE: String = "content-type"
    func process(_ response: Siesta.Response) -> Siesta.Response
    {
        switch(response)
        {
        case .success(var entity):
            if let data = entity.content as? NSData, data.length == 0 {
                /* 
                 If there is no content in the response, content type should
                 not be present
                */
                entity.headers.removeValue(forKey: HEADER_CONTENT_TYPE)
            }
            return .success(entity)
            
        case .failure:
            return response
        }
    }
}

class AccesssTokenCache {
    static var tokenCached = false
    static var accessToken: String? = nil
}

class Repository<T> : Service where T: ETXModel {
    
    private let KEY_HEADER_APP_ID: String = "app-id"
    private let KEY_HEADER_CLIENT_KEY: String = "client-key"
    private let KEY_HEADER_AUTHORIZATION: String = "Authorization"
    
    let KEY_DEFAULTS_ACCESS_TOKEN: String = "accessToken"
    
    var resourcePath: String
    
    private var _etxResource: Resource?
    var etxResource: Resource {
        
        get {
            if _etxResource == nil {
                _etxResource = resource(resourcePath)
            }
            return _etxResource!
        }
        set { _etxResource = newValue }
    }
    
    init(resourcePath: String) {
        self.resourcePath = resourcePath
        super.init(baseURL:EngaugeTxApplication.baseUrl)

        configure {
            $0.headers[self.KEY_HEADER_APP_ID] = EngaugeTxApplication.appId
            $0.headers[self.KEY_HEADER_CLIENT_KEY] = EngaugeTxApplication.clientKey
            $0.headers[self.KEY_HEADER_AUTHORIZATION] = self.getAccessToken()
            $0.pipeline[.decoding].add(ChangeEmptyResponseContentType())
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
                etxError?.statusCode = etxError?.statusCode ?? err.httpStatusCode
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
        if AccesssTokenCache.tokenCached {
            return AccesssTokenCache.accessToken
        } else {
            let defaults = UserDefaults.standard
            print("Getting Access Token")
            return defaults.string(forKey: self.KEY_DEFAULTS_ACCESS_TOKEN)
        }
    }
    
    func setAccessToken(_ accessToken: String?) {
        AccesssTokenCache.accessToken = accessToken
        AccesssTokenCache.tokenCached = true
        let defaults = UserDefaults.standard
        defaults.setValue(accessToken, forKey: self.KEY_DEFAULTS_ACCESS_TOKEN)
        //defaults.set(accessToken, forKey: self.KEY_DEFAULTS_ACCESS_TOKEN)
        print("Saved Access Token")
    }
    
    func deleteAccessToken() {
        AccesssTokenCache.accessToken = nil
        print("Deleting Access Token")
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: self.KEY_DEFAULTS_ACCESS_TOKEN)
        defaults.removeObject(forKey: self.KEY_DEFAULTS_ACCESS_TOKEN)
        
    }
    
    func getAppId() -> String {
        return EngaugeTxApplication.appId
    }
    
    func getClientKey() -> String {
        return EngaugeTxApplication.clientKey
    }
    
}
