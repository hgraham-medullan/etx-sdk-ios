//
//  CustomFunction.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 1/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta

@available(*, renamed: "ETXCustomFunction", deprecated: 0.0.12)
typealias CustomFunction = ETXCustomFunction<ETXModel>

/**
 Provides the ability to execute add-on functionality created via Custom Logic
 */
public class ETXCustomFunction<T: ETXModel> {
    
    private let urlPrefix = "/run"
    private let queryStringNameAppId = "appId"
    private let queryStringNameClientKey = "clientKey"
    private let queryStringNameAccessToken = "accessToken"
    private var functionName: String
    
    private var repo: Repository<T>
    
    // The last
    var lastUsedRepo: Repository<T>?

    /**
     Create access to a custom function
     - parameter functionName: The name of the function, as configured in the application
    */
    public init?(functionName: String) {
        guard ETXCustomFunction.isValidFunctionName(functionName, urlPrefix: urlPrefix) else {
            return nil
        }
        self.functionName = functionName
        self.repo = Repository<T>(resourcePath: "\(urlPrefix)/\(functionName)")
    }
    
    private func getRepo() -> Repository<T> {
        return Repository<T>(resourcePath: "\(urlPrefix)/\(functionName)")
    }
    
    /**
     Get the URL to the custom function with all authentication parameters.
     returns: The authenticated URL with app ID, Client Key and Access Token 
     query parameters
    */
    public func getAuthenticatedUrl() -> URL? {
        let r: Repository<T> = self.getRepo()
        
        guard let accessToken = r.getAccessToken() else {
            EngaugeTxLog.info("An access token is not available to create the authenticated URL: \(r.etxResource.url.absoluteString)")
            return nil
        }

        let resource = self.getRepo().etxResource
            .withParam(queryStringNameAccessToken, accessToken)
            .withParam(queryStringNameAppId, r.getAppId())
            .withParam(queryStringNameClientKey, r.getClientKey())
        
        return resource.url
    }

    /**
     Perform a GET request on the URL to get some data
     - parameter queryStrings: Key map of query string values to add to the request
     - asUnauthenticatedReq: Whether the authorization token should be ignored when making the request
     - parameter completion: Callback when the requests completes
     - parameter model: The data when the request completes successfullt
     - parameter err: The err as t why the request failed
     */
    public func performGet(queryStrings: [String:String]? = nil, asUnauthenticatedReq: Bool = false, completion: @escaping (_ model: T?, _ err: ETXError?) -> Void) {
        let repo = getRepo()
        repo.ignoreAccessToken = asUnauthenticatedReq 
        self.addQueryStrings(queryStrings, toResource: &repo.etxResource)
        repo.getById("", completion: completion)
        self.lastUsedRepo = repo
    }
    
    /**
     Perform a POST request on the URL to send some data
     - parameter model: The model to serialized and send as the payload
     - parameter queryStrings: Key map of query string values to add to the request
     - asUnauthenticatedReq: Whether the authorization token should be ignored when making the request
     - parameter completion: Callback when the requests completes
     - parameter model: The data when the request completes successfullt
     - parameter err: The err as t why the request failed
     */
    public func performPost(model: T, queryStrings: [String:String]? = nil, asUnauthenticatedReq: Bool = false, completion: @escaping (T?, ETXError?) -> Void) {
        let repo = self.getRepo()
        self.addQueryStrings(queryStrings, toResource: &repo.etxResource)
        repo.ignoreAccessToken = asUnauthenticatedReq
        repo.save(model: model, completion: completion)
        self.lastUsedRepo = repo
    }
    
    func addQueryStrings(_ queryStrings: [String:String]?, toResource resource: inout Resource) {
        if let queryStrings = queryStrings {
            for (k, v) in queryStrings {
                resource = resource.withParam(k, v)
            }
        }
    }
    
    internal class func isValidFunctionName(_ functionName: String, urlPrefix: String) -> Bool {
        guard let _ = URL(string: "\(EngaugeTxApplication.baseUrl!)\(urlPrefix)/\(functionName)")  else {
            return false
        }
        return true
    }
}
