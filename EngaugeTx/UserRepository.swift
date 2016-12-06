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
    
    private func login(credentials: UserCredentials, completion: @escaping (ETXUser?, ETXError?) ->Void) {
        
        let req = self.users.child("/login").withParam("include", "user").request(.post, json: credentials.toJSON())
        req.onFailure { (err) in
            if let httpStatusCode = err.httpStatusCode, httpStatusCode == 401 {
                print("Auth err")
            } else  {
                print("Oops \(err.httpStatusCode)")
            }
            completion(nil, ETXAuthenticationError(.InvalidUsernameOrPassword))
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
    
    func loginWithEmail(_ email: String, password: String, done: @escaping (ETXUser?, ETXError?) ->Void) {
        let userCredentials = UserEmailCredentials(email, password: password)
        self.login(credentials: userCredentials, completion: done)
    }
    
    func loginWithUsername(_ username: String, password: String, done: @escaping (ETXUser?, ETXError?) ->Void) {
        let userCredentials = UsernameCredentials(username, password: password)
        self.login(credentials: userCredentials, completion: done)
    }
    
    
    private func saveAccessToken(_ accessToken: String?) {
        let defaults = UserDefaults.standard
        defaults.set(accessToken, forKey: "accessToken")
    }
    
    func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "accessToken")
        self.wipeResources()
    }

}
