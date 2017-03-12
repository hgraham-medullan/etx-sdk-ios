//
//  TrendRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta

class TrendRepository: Repository<ETXModel> {
    
    private let TRENDS_URL = "/trends"
    
    init() {
        super.init(resourcePath: TRENDS_URL)
    }
    
    func getTrends(completion: @escaping (T?, ETXError?) ->Void) {
        self.deleteCurrentUser()
        let req = self.users.child("/login").withParam("include", "user").request(.post, json: credentials.toJSON())
        req.onFailure { (err) in
            
            var etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
            if let httpStatusCode = err.httpStatusCode, httpStatusCode == 401 {
                let authErr: ETXAuthenticationError? = Mapper<ETXAuthenticationError>().map(JSON: err.jsonDict)
                etxError = authErr
            }
            print("User login failed: \(err.jsonDict)")
            completion(nil, etxError)
        }
        
        req.onSuccess { (obj) in
            
            let accessToken: ETXAccessToken = (obj.content as! ETXAccessToken)
            self.saveCurrentUser(accessToken)
            
            completion(Mapper<T>().map(JSON: (accessToken.user?.rawJson)!), nil)
        }
    }
}
