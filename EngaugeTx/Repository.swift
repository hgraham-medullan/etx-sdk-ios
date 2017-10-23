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
import SwiftKeychainWrapper

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

public protocol Repo {
    typealias RepoType = Self
    init(resourcePath: String)
}

open class Repository<T> : Service, Repo where T: ETXModel {
    
     let KEY_HEADER_APP_ID: String = "app-id"
     let KEY_HEADER_CLIENT_KEY: String = "client-key"
     let KEY_HEADER_AUTHORIZATION: String = "Authorization"
     let QUERY_STRING_APP_ID = "appId"
     let QUERY_STRING_CLIENT_KEY = "clientKey"
     let QUERY_STRING_ACCESS_TOKEN = "accessToken"
    
    let KEY_DEFAULTS_ACCESS_TOKEN: String = "accessToken"
    
    var resourcePath: String
    
    let keychainInstance: KeychainWrapper = KeychainWrapper(serviceName:  Bundle.main.bundleIdentifier ?? "engaugetx", accessGroup: nil)
    
    var ignoreAccessToken = false
    
    private var additionalHeaders: [String:String]? {
        didSet {
            // Rerun existing configuration closure using new value
            invalidateConfiguration()
            // Wipe any cached state if auth token changes
            wipeResources()
        }
    }
    
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
    
    required public init(resourcePath: String) {
        self.resourcePath = resourcePath
        super.init(baseURL:EngaugeTxApplication.baseUrl)

        configure {
            $0.headers[self.KEY_HEADER_APP_ID] = EngaugeTxApplication.appId
            $0.headers[self.KEY_HEADER_CLIENT_KEY] = EngaugeTxApplication.clientKey
            
            // Some requests may need to be made without the presence of the access token
            if self.ignoreAccessToken == false {
                $0.headers[self.KEY_HEADER_AUTHORIZATION] = self.getAccessToken()
            } else {
                EngaugeTxLog.debug("Ignoring the access token for the request to \(String(describing: self._etxResource?.url.absoluteString))")
            }
            if let additionalHeaders = self.additionalHeaders {
                for (headerName, headerValue) in additionalHeaders {
                    $0.headers[headerName] = headerValue;
                }
            }
            $0.pipeline[.decoding].add(ChangeEmptyResponseContentType())
        }
    }
    
    private static var unsavedModelError: ETXError {
        let err = ETXError(message: "The model is not assigned an ID and may be unsaved")
        err.name = "UnsavedModelError"
        return err
    }
    
    func save(model: T, completion: @escaping (T?, ETXError?) -> Void) {
        if let _ = model.id {
            self.update(model: model, completion: completion)
        } else {
            self.create(model: model, completion: completion)
        }
    }
    
    public func create(model: T, completion: @escaping (T?, ETXError?) -> Void) {
        beforeResourceRequest(self.etxResource) {
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
    
    public func update(model: T, completion: @escaping (T?, ETXError?)-> Void) {
        guard let id = model.id else {
            completion(nil, Repository.unsavedModelError)
            return
        }
        beforeResourceRequest(self.etxResource.child(id)) {
            let req = self.etxResource.request(.put, json: ((model as? ETXModel)?.toJSON())!)
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
    
    public func delete(model: T, completion: @escaping (ETXError?) -> Void) {
        guard let id = model.id else {
            completion(Repository.unsavedModelError)
            return
        }
        beforeResourceRequest(self.etxResource.child(id)) {
            let req  = self.etxResource.request(.delete)
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
    
    public func getById(_ id: String, completion: @escaping (T?, ETXError?) -> Void) {
        beforeResourceRequest(self.etxResource.child(id)){
            let req  = self.etxResource.request(.get)
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
    
    public func findById(_ id: String, completion: @escaping (T?, ETXError?) -> Void) {
        self.getById(id, completion: completion)
    }
    
    public func findWhere(_ filter: ETXSearchFilter, completion: @escaping ([T]?, ETXError?) -> Void) {
        beforeResourceRequest(self.etxResource.withParam("filter", filter.toJsonString())) {
            let req = self.etxResource.request(.get)
            
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
    }
    
    public func beforeResourceRequest(_ resource: Resource, completion: @escaping () -> Void) {
        // Default behaviour. No modification, return true for the request to continue
        completion()
    }
    
    
    func getAccessToken() -> String? {
        cleanUpOldAccessTokenRefs()
        EngaugeTxLog.debug("Getting the Access Token")
        var accessToken: String?
        if AccesssTokenCache.tokenCached {
            accessToken = AccesssTokenCache.accessToken
        } else {
            accessToken = keychainInstance.string(forKey: self.KEY_DEFAULTS_ACCESS_TOKEN)
        }
        return accessToken
    }
    
    func appendOwnerIdToWhereFilter(filter: ETXSearchFilter, ownerId: String) -> String{
        if filter.whereCondtions == nil {
            filter.whereCondtions = [ETXWhereCondition]()
        }
        filter.whereCondtions?.append(ETXWhereCondition(property: "ownerId", comparator: ETXComparator.eq, value: ownerId))
        return filter.toJsonString()
    }
    
    func setAccessToken(_ accessToken: String?, rememberUser: Bool) {
        self.deleteAccessToken()
        
        AccesssTokenCache.accessToken = accessToken
        AccesssTokenCache.tokenCached = true
        if rememberUser == true {
            if let accessToken = accessToken {
                self.keychainInstance.set(accessToken, forKey: self.KEY_DEFAULTS_ACCESS_TOKEN)
            }
        }
        EngaugeTxLog.debug("Saved the Access Token")
    }
    
    func deleteAccessToken() {
        EngaugeTxLog.debug("Deleting the Access Token")
        AccesssTokenCache.accessToken = nil
        AccesssTokenCache.tokenCached = false
        cleanUpOldAccessTokenRefs()
        keychainInstance.removeObject(forKey: self.KEY_DEFAULTS_ACCESS_TOKEN)
        
    }
    
    private func cleanUpOldAccessTokenRefs() {
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
    
    func addAdditionalHeader(_ headerKey: String, value: String) {
        guard var additionalHeaders = self.additionalHeaders else {
            self.additionalHeaders = [headerKey:value]
            return
        }
        additionalHeaders[headerKey] = value
        self.additionalHeaders = additionalHeaders
    }
}
