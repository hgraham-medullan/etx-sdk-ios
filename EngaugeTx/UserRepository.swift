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
    }
    
    private func login(credentials: UserCredentials, completion: @escaping (String) ->Void) {
        let r = self.users.child("/login").withParam("include", "user").request(.post, json: credentials.toJSON())
        r.onFailure { (err) in
            if let httpStatusCode = err.httpStatusCode, httpStatusCode == 401 {
                print("Auth err")
            } else  {
                print("Oops \(err.httpStatusCode)")
            }
        }
        r.onSuccess { (obj) in
            print(obj.content)
        }
        r.onCompletion { (res) in
            completion(res.response.description)
            
        }
    }
    
    func loginWithEmail(_ email: String, password: String, done: @escaping (String) ->Void) {
        let userCredentials = UserEmailCredentials(email, password: password)
        self.login(credentials: userCredentials, completion: done)
    }
    
    func loginWithUsername(_ username: String, password: String, done: @escaping (String) ->Void) {
        let userCredentials = UsernameCredentials(username, password: password)
        self.login(credentials: userCredentials, completion: done)
    }
    
    func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "accessToken")
        self.wipeResources()
    }

}
