//
//  CustomFunction.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 1/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta

public class CustomFunction {
    
    private let urlPrefix = "/run"
    private let queryStringNameAppId = "appId"
    private let queryStringNameClientKey = "clientKey"
    private let queryStringNameAccessToken = "accessToken"
    private var functionName: String
    
    private var repo: Repository<ETXModel>

    init?(functionName: String) {
        guard CustomFunction.isValidFunctionName(functionName, urlPrefix: urlPrefix) else {
            return nil
        }
        self.functionName = functionName
        self.repo = Repository<ETXModel>(resourcePath: "\(urlPrefix)/\(functionName)")
    }
    
    private func getRepo() -> Repository<ETXModel> {
        return Repository<ETXModel>(resourcePath: "\(urlPrefix)/\(functionName)")
    }
    
    public func getUrl() -> URL? {
        guard let accessToken = self.repo.getAccessToken() else {
            return nil
        }

        let resource = self.getRepo().etxResource
            .withParam(queryStringNameAccessToken, accessToken)
            .withParam(queryStringNameAppId, self.repo.getAppId())
            .withParam(queryStringNameClientKey, self.repo.getClientKey())
        
        return resource.url
    }
    
    public func performGet(completion: @escaping (ETXModel?, ETXError?) -> Void) {
        self.performGet(queryStrings: nil, completion: completion)
    }
    
    public func performGet(queryStrings: [String:String]?, completion: @escaping (ETXModel?, ETXError?) -> Void) {
        let repo = getRepo()
        self.addQueryStrings(queryStrings, toResource: &repo.etxResource)
        repo.getById("", completion: completion)
    }
    
    private func addQueryStrings(_ queryStrings: [String:String]?, toResource resource: inout Resource) {
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
