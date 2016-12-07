//
//  UserRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/5/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta
import ObjectMapper

class UserRepository: Repository<ETXUser> {
    
    var users: Resource { return resource("/users") }
    
    init() {
        super.init(resourcePath: "/users")
        self.configureTransformer("/users/login") {
            Mapper<ETXAccessToken>().map(JSON: $0.content)
        }
    }
    
    private func login(credentials: UserCredentials, rememberMe: Bool, completion: @escaping (ETXUser?, ETXError?) ->Void) {
        
        let req = self.users.child("/login").withParam("include", "user").request(.post, json: credentials.toJSON())
        req.onFailure { (err) in
            var authErr: ETXAuthenticationError? = nil
            let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
            if let httpStatusCode = err.httpStatusCode, httpStatusCode == 401 {
                authErr = ETXAuthenticationError(reasonRawValue: (etxError?.code)!)
                print("Auth err")
            }
            if let authErr = authErr {
                completion(nil, authErr)
            } else {
                completion(nil, etxError)
            }
            
        }
        
        req.onSuccess { (obj) in
            
            let accessToken: ETXAccessToken = (obj.content as! ETXAccessToken)
            self.saveAccessToken(accessToken.id)
            completion(accessToken.user, nil)
        }
//        req.onCompletion { (res) in
//            completion(res.response.description)
//            
//        }
    }
    
    func loginWithEmail(_ email: String, password: String, rememberMe: Bool, done: @escaping (ETXUser?, ETXError?) ->Void) {
        self.deleteAccessToken()
        let userCredentials = UserEmailCredentials(email, password: password)
        self.login(credentials: userCredentials, rememberMe: rememberMe, completion: done)
    }
    
    func loginWithUsername(_ username: String, password: String, rememberMe: Bool, done: @escaping (ETXUser?, ETXError?) ->Void) {
        let userCredentials = UsernameCredentials(username, password: password)
        self.login(credentials: userCredentials, rememberMe: rememberMe, completion: done)
    }
    
    func logout() {
        self.deleteAccessToken()
        self.wipeResources()
    }

}
