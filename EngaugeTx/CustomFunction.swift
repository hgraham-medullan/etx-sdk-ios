//
//  CustomFunction.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 1/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta


/**
 Provides the ability to execute add-on functionality created via Custom Logic
 */
public class CustomFunction<T: ETXModel> {
    
    private let urlPrefix = "/run"
    private let queryStringNameAppId = "appId"
    private let queryStringNameClientKey = "clientKey"
    private let queryStringNameAccessToken = "accessToken"
    private var functionName: String
    
    private var repo: Repository<T>

    /**
     Create access to a custom function
     - parameter functionName: The name of the function, as configured in the application
    */
    public init?(functionName: String) {
        guard CustomFunction.isValidFunctionName(functionName, urlPrefix: urlPrefix) else {
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
            print("An access token is not available to create the authenticated URL")
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
     - parameter completion: Callback when the requests completes
     - parameter model: The data when the request completes successfullt
     - parameter err: The err as t why the request failed
    */
    public func performGet(completion: @escaping (_ model: T?, _ err: ETXError?) -> Void) {
        self.performGet(queryStrings: nil, completion: completion)
    }
    
    /**
     Perform a GET request on the URL to get some data
     - parameter queryStrings: Key map of query string values to add to the request
     - parameter completion: Callback when the requests completes
     - parameter model: The data when the request completes successfullt
     - parameter err: The err as t why the request failed
     */
    public func performGet(queryStrings: [String:String]?, completion: @escaping (T?, ETXError?) -> Void) {
        let repo = getRepo()
        self.addQueryStrings(queryStrings, toResource: &repo.etxResource)
        repo.getById("", completion: completion)
    }
    
    /**
     Perform a POST request on the URL to send some data
     - parameter model: The model to serialized and send as the payload
     - parameter completion: Callback when the requests completes
     - parameter model: The data when the request completes successfullt
     - parameter err: The error, as to why the request failed
     */
    public func performPost(model: T, completion: @escaping (T?, ETXError?) -> Void) {
        self.performPost(model: model, queryStrings: nil, completion: completion)
    }
    
    /**
     Perform a POST request on the URL to send some data
     - parameter model: The model to serialized and send as the payload
     - parameter queryStrings: Key map of query string values to add to the request
     - parameter completion: Callback when the requests completes
     - parameter model: The data when the request completes successfullt
     - parameter err: The err as t why the request failed
     */
    public func performPost(model: T, queryStrings: [String:String]?, completion: @escaping (T?, ETXError?) -> Void) {
        let repo = self.getRepo()
        self.addQueryStrings(queryStrings, toResource: &repo.etxResource)
        repo.save(model: model, completion: completion)
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
