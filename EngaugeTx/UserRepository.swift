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

class UserRepository<T: ETXUser>: Repository<T> {
    
    private let KEY_DEFAULTS_USER_ID: String = "userId"
    private let KEY_DEFAULTS_CURRENT_USER: String = "currentUser"
    
    var users: Resource { return resource("/users") }
    
    init() {
        super.init(resourcePath: "/users")
        self.configureTransformer("/users/login") {
            Mapper<ETXAccessToken>().map(JSON: $0.content)
        }
    }
    
    private func login(credentials: UserCredentials, rememberMe: Bool, completion: @escaping (T?, ETXError?) ->Void) {
        
        let req = self.users.child("/login").withParam("include", "user").request(.post, json: credentials.toJSON())
        req.onFailure { (err) in
            var authErr: ETXAuthenticationError? = nil
            let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
            if let httpStatusCode = err.httpStatusCode, httpStatusCode == 401 {
                authErr = ETXAuthenticationError(reasonRawValue: (etxError?.code)!)
            }
            if let authErr = authErr {
                completion(nil, authErr)
            } else {
                completion(nil, etxError)
            }
        }
        
        req.onSuccess { (obj) in
            
            let accessToken: ETXAccessToken = (obj.content as! ETXAccessToken)
            self.saveCurrentUser(accessToken)
            
            completion(Mapper<T>().map(JSON: (accessToken.user?.rawJson)!), nil)
        }
    }
    
    func saveCurrentUser(_ accessToken: ETXAccessToken?) {
        let defaults = UserDefaults.standard
        let currentUser: [String: String?] =
            [KEY_DEFAULTS_USER_ID: accessToken?.userId,
             KEY_DEFAULTS_ACCESS_TOKEN: accessToken?.id]
        defaults.set(currentUser, forKey: KEY_DEFAULTS_CURRENT_USER)
    }
    
    func getCurrentUserId() -> String? {
        let defaults = UserDefaults.standard
        return defaults.dictionary(forKey: KEY_DEFAULTS_CURRENT_USER)?[KEY_DEFAULTS_USER_ID] as! String?
    }
    
    func deleteCurrentUser() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: self.KEY_DEFAULTS_CURRENT_USER)
    }
    
    func loginWithEmail(_ email: String, password: String, rememberMe: Bool, done: @escaping (T?, ETXError?) ->Void) {
        self.deleteCurrentUser()
        let userCredentials = UserEmailCredentials(email, password: password)
        self.login(credentials: userCredentials, rememberMe: rememberMe, completion: done)
    }
    
    func loginWithUsername(_ username: String, password: String, rememberMe: Bool, done: @escaping (T?, ETXError?) ->Void) {
        let userCredentials = UsernameCredentials(username, password: password)
        self.login(credentials: userCredentials, rememberMe: rememberMe, completion: done)
    }
    
    func logout() {
        self.deleteCurrentUser()
        self.wipeResources()
    }

}
