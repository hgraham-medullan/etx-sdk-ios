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

// Find a better a to track that the user selected remember me
class CurrentUserCache {
    static var currentUserId: String?
}

open class UserRepository<T: ETXUser>: Repository<T> {
    
    private let URL_USER_LOGIN: String = "/users/login"
    private let URL_USER_AFFILIATED_USERS: String = "/users/*/affiliatedUsers"
    private let QUERY_PARAM_TTL: String = "ttl"
    
    
    var users: Resource { return resource(self.resourcePath) }
    
    static var URL_USERS: String {
        return "/users"
    }
    
    convenience init() {
        let URL_USERS: String = UserRepository.URL_USERS
        self.init(resourcePath: URL_USERS)
    }
    
    required public init(resourcePath: String) {
        super.init(resourcePath: resourcePath)
        self.configureTransformer(URL_USER_LOGIN) {
            Mapper<ETXAccessToken>().map(JSON: $0.content)
        }
        
        self.configureTransformer(URL_USER_AFFILIATED_USERS) {
            Mapper<ETXResponse>().map(JSON: $0.content)
        }
    }
    
    private func login(credentials: UserCredentials, rememberMe: Bool, completion: @escaping (T?, ETXError?) ->Void) {
        self.deleteCurrentUser()
        var ttl: Int? = EngaugeTxApplication.defaultTTL
        
        var resource = self.users.child("/login").withParam("include", "user")
        if (rememberMe && EngaugeTxApplication.rememberMeTTL != nil) {
            ttl = EngaugeTxApplication.rememberMeTTL
        }
        
        if let ttl = ttl {
            resource = resource.withParam(self.QUERY_PARAM_TTL, "\(ttl)")
        }
        
        beforeResourceRequest(resource) {
            let req = resource.request(.post, json: credentials.toJSON())
            req.onFailure { (err) in
                
                var etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
                if let httpStatusCode = err.httpStatusCode, httpStatusCode == 401 {
                    let authErr: ETXAuthenticationError? = Mapper<ETXAuthenticationError>().map(JSON: err.jsonDict)
                    etxError = authErr
                }
                EngaugeTxLog.info("User login failed.", context: err.jsonDict)
                completion(nil, etxError)
            }
            
            req.onSuccess { (obj) in
                let accessToken: ETXAccessToken = (obj.content as! ETXAccessToken)
                self.saveCurrentUser(accessToken, rememberUser: rememberMe)
                
                completion(Mapper<T>().map(JSON: (accessToken.user?.rawJson)!), nil)
            }
        }
    }
    
    public func getAffiliatedUsers(withRole: ETXRole, forMyRole: ETXRole, completion: @escaping ( [ETXUser]?, ETXError?)->Void) {
        let id = getCurrentUserId() ?? ""
        if(id.isEmpty){
            completion(nil, ETXError(message: "A logged in user is required"))
        } else {
            let resource = self.users.child(id).child("/affiliatedUsers")
            beforeResourceRequest(resource) {
                let req = resource.request(.get)
                
                req.onFailure { (err) in
                    let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
                    completion(nil, etxError)
                }
                
                req.onSuccess { (obj) in
                    let res: ETXResponse = (obj.content as! ETXResponse)
                    let affiliatedUsers: [ETXAffiliatedUser] = Mapper<ETXAffiliatedUser>().mapArray(JSONArray: res.result as! [[String : Any]])
                    var users: [ETXUser] = [ETXUser]()
                    for affiliatedUser in affiliatedUsers {
                        if(affiliatedUser.role == withRole) {
                            let user: ETXUser = ETXUser(user: affiliatedUser)
                            users.append(user)
                        }
                    }
                    completion(users, nil)
                }
            }
        }
        
    }
    
    func saveCurrentUser(_ accessToken: ETXAccessToken?, rememberUser: Bool) {
        self.deleteCurrentUser()
        if let userId:String = accessToken?.userId,
            let accessToken: String =  accessToken?.id {
            self.setAccessToken(accessToken, rememberUser: rememberUser)
            CurrentUserCache.currentUserId = userId
            if rememberUser == true {
                self.keychainInstance.set(userId, forKey: ETXConstants.KEY_DEFAULTS_USER_ID)
            }
        }
    }
    
    func getCurrentUserId() -> String? {
        cleanUpOldCurrentUserRefs()
        if CurrentUserCache.currentUserId != nil {
           return CurrentUserCache.currentUserId
        } else {
            return keychainInstance.string(forKey: ETXConstants.KEY_DEFAULTS_USER_ID)
        }
    }
    
    func deleteCurrentUser() {
        CurrentUserCache.currentUserId = nil
        keychainInstance.removeObject(forKey: ETXConstants.KEY_DEFAULTS_USER_ID)
        self.deleteAccessToken()
        cleanUpOldCurrentUserRefs()
    }
    
    private func cleanUpOldCurrentUserRefs() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: ETXConstants.KEY_DEFAULTS_CURRENT_USER)
    }
    
    public func loginWithEmail(_ email: String, password: String, rememberMe: Bool, done: @escaping (T?, ETXError?) ->Void) {
        let userCredentials = UserEmailCredentials(email, password: password)
        self.login(credentials: userCredentials, rememberMe: rememberMe, completion: done)
    }
    
    public func loginWithUsername(_ username: String, password: String, rememberMe: Bool, done: @escaping (T?, ETXError?) ->Void) {
        let userCredentials = UsernameCredentials(username, password: password)
        self.login(credentials: userCredentials, rememberMe: rememberMe, completion: done)
    }
    
    public func logout(completion: @escaping (ETXError?) ->Void) {
        let resource = self.users.child("/logout")
        beforeResourceRequest(resource) {
            let req = resource.request(.post)
            req.onFailure { (err) in
                self.deleteCurrentUser()
                self.wipeResources()
                let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
                completion(etxError)
            }
            
            req.onSuccess { (obj) in
                self.deleteCurrentUser()
                self.wipeResources()
                completion(nil)
            }
        }
    }
    
    public func initiatePasswordReset(emailAddress: String, completion: @escaping (_ err: ETXError?)->Void) {
        self.deleteCurrentUser()
        let reqBody:[String:String] = ["email": emailAddress]
        let resource = self.users.child("/reset")
        beforeResourceRequest(resource) {
            let req = resource.request(.post, json: reqBody)
            
            req.onFailure { (err) in
                let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
                completion(etxError)
            }
            
            req.onSuccess { (obj) in
                completion(nil)
            }
        }
    }
    
    public func changePassword(_ passwordUpdateCredentials: PasswordUpdateCredentials, completion: @escaping (_ err: ETXError?)->Void) {
        
        let resource = self.users.child("/changePassword")
        beforeResourceRequest(resource) {
            let req = resource.request(.post, json: passwordUpdateCredentials.toJSON())
            
            req.onFailure { (err) in
                let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
                completion(etxError)
            }
            
            req.onSuccess { (obj) in
                completion(nil)
            }
        }
    }
    
    func changeEmailAddress(_ emailUpdateCredentials: EmailUpdateCredentials, userId: String, completion: @escaping (_ err: ETXError?)->Void) {
        // TODO: Integrate with API
        completion(nil)
    }

}
