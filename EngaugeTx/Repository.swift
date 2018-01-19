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
     let QUERY_STRING_FILTER = "filter"
     let QUERY_STRING_CLIENT_KEY = "clientKey"
     let QUERY_STRING_ACCESS_TOKEN = "accessToken"
    
    let FILTER_PROP_WHERE = "where"
    
    let FILTER_PROP_OWNER_ID = "ownerId"
    
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
    
    open func save(model: T, completion: @escaping (T?, ETXError?) -> Void) {
        if let _ = model.id {
            self.update(model: model, completion: completion)
        } else {
            self.create(model: model, completion: completion)
        }
    }
    
    open func create(model: T, completion: @escaping (T?, ETXError?) -> Void) {
        self.makeRequest(resource: self.etxResource,
                         httpMethod: .post,
                         model: model,
                         errorListener: { (err) in
                            let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
                            etxError?.rawJson = err.jsonDict
                            etxError?.statusCode = etxError?.statusCode ?? err.httpStatusCode
                            completion(nil, etxError)
                         },
                         successListener: { (m) in
                            let model = Mapper<T>().map(JSON: m.content as! [String : Any])
                            completion(model, nil)
                         })
    }
    
    public func makeRequest(resource: Resource,
                     httpMethod: RequestMethod,
                     model: T?,
                     errorListener: @escaping (RequestError) -> Void,
                     successListener: @escaping (Entity<Any>) -> Void){
        beforeResourceRequest(resource) {
            if (httpMethod == .put || httpMethod == .post) {
                let reqWithData = resource.request(httpMethod, json: ((model as? ETXModel)?.toJSON())!)
                reqWithData.onFailure(errorListener)
                reqWithData.onSuccess(successListener)
            } else {
                let req = resource.request(httpMethod)
                req.onFailure(errorListener)
                req.onSuccess(successListener)
            }
        }
    }
    
    public func performUpdate(_ resource: Resource, model: T, completion: @escaping (T?, ETXError?) -> Void) {
        self.makeRequest(resource: resource,
                         httpMethod: .put,
                         model: model,
                         errorListener: { (err) in
                            let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
                            etxError?.rawJson = err.jsonDict
                            completion(nil, etxError)
                         },
                         successListener: { (m) in
                            let model = Mapper<T>().map(JSON: m.content as! [String : Any])
                            completion(model, nil)
                         })
    }
    
    open func update(model: T, completion: @escaping (T?, ETXError?)-> Void) {
        guard let id = model.id else {
            completion(nil, Repository.unsavedModelError)
            return
        }
        self.etxResource = self.etxResource.child(id)
        performUpdate(self.etxResource, model: model, completion: completion)
    }
    
    open func delete(model: T, completion: @escaping (ETXError?) -> Void) {
        guard let id = model.id else {
            completion(Repository.unsavedModelError)
            return
        }
        
        self.makeRequest(resource: self.etxResource.child(id),
                         httpMethod: .delete,
                         model: model,
                         errorListener: { (err) in
                            let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
                            etxError?.rawJson = err.jsonDict
                            completion(etxError)
                         },
                         successListener: { (m) in
                            completion(nil)
                         })
    }
    
    public func getById(_ id: String, completion: @escaping (T?, ETXError?) -> Void) {
        self.findById(id, completion: completion)
    }
    
    public func performFindById(_ resource: Resource, _ completion: @escaping (T?, ETXError?) -> Void) {
        self.makeRequest(resource: resource,
                         httpMethod: .get,
                         model: nil,
                         errorListener: { (err) in
                            let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
                            etxError?.rawJson = err.jsonDict
                            etxError?.statusCode = etxError?.statusCode ?? err.httpStatusCode
                            completion(nil, etxError)
                         },
                         successListener: { (m) in
                            let model = Mapper<T>().map(JSON: m.content as! [String : Any])
                            completion(model, nil)
                         })
    }
    
    open func findById(_ id: String, completion: @escaping (T?, ETXError?) -> Void) {
        self.etxResource = self.etxResource.child(id)
        performFindById(self.etxResource, completion)
    }
    
    public func performFindWhere(_ resource: Resource,_ completion: @escaping ([T]?, ETXError?) -> Void) {
        self.makeRequest(resource: resource,
                         httpMethod: .get,
                         model: nil,
                         errorListener: { (err) in
                            let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
                            etxError?.rawJson = err.jsonDict
                            etxError?.statusCode = etxError?.statusCode ?? err.httpStatusCode
                            completion(nil, etxError)
                         },
                         successListener: { (m) in
                            var models: [T]?
                            if let content = m.content as? [String : Any], let result: [[String : Any]] = content["result"] as! [[String : Any]]?  {
                                models = Mapper<T>().mapArray(JSONObject: result)
                            } else {
                                models = Mapper<T>().mapArray(JSONArray: [m.content as! [String : Any]])
                            }
                            completion(models, nil)
                        })
    }
    
    open func findWhere(_ filter: ETXSearchFilter, completion: @escaping ([T]?, ETXError?) -> Void) {
        self.etxResource = self.etxResource.withParam(QUERY_STRING_FILTER, filter.toJsonString())
        performFindWhere(self.etxResource, completion)
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
        if filter.usesCustomFilter {
            return self.appendOwnerIdToWhereFilter(filter: filter.toJsonString(), ownerId: ownerId)
        } else  {
        filter.whereCondtions?.append(ETXWhereCondition(property: FILTER_PROP_OWNER_ID, comparator: ETXComparator.eq, value: ownerId))
            return filter.toJsonString()
        }
    }
    
    private func appendOwnerIdToWhereFilter(filter: String, ownerId: String) -> String{
        var ownerIdFilter: [String: String] = [String: String]()
        ownerIdFilter[FILTER_PROP_OWNER_ID] = ownerId
        
        var filterDict = ETXRequestUtils.jsonStringToDictionary(json: filter)
        var whereCond = filterDict![FILTER_PROP_WHERE] as? [String: Any];
        if whereCond != nil {
            whereCond![FILTER_PROP_OWNER_ID] = ownerId
            filterDict![FILTER_PROP_WHERE] = whereCond
        } else {
            filterDict![FILTER_PROP_WHERE] = ownerIdFilter
        }
        return ETXRequestUtils.convertJSONDataToString(filterDict)
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
