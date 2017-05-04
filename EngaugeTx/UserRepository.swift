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
    
    private let URL_USERS: String = "/users"
    private let URL_USER_LOGIN: String = "/users/login"
    private let URL_USER_AFFILIATED_USERS: String = "/users/*/affiliatedUsers"
    
    
    var users: Resource { return resource(URL_USERS) }
    
    init() {
        super.init(resourcePath: URL_USERS)
        self.configureTransformer(URL_USER_LOGIN) {
            Mapper<ETXAccessToken>().map(JSON: $0.content)
        }
        
        self.configureTransformer(URL_USER_AFFILIATED_USERS) {
            Mapper<ETXResponse>().map(JSON: $0.content)
        }
    }
    
    private func login(credentials: UserCredentials, rememberMe: Bool, completion: @escaping (T?, ETXError?) ->Void) {
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
            self.saveCurrentUser(accessToken, rememberUser: rememberMe)
            
            completion(Mapper<T>().map(JSON: (accessToken.user?.rawJson)!), nil)
        }
    }
    
    public func getAffiliatedUsers(withRole: ETXRole, forMyRole: ETXRole, completion: @escaping ( [ETXUser]?, ETXError?)->Void) {
        let id = getCurrentUserId() ?? ""
        if(id.isEmpty){
            completion(nil, ETXError(message: "A logged in user is required"))
        } else {
            let req = self.users.child(id).child("/affiliatedUsers").request(.get)
            
            req.onFailure { (err) in
                let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
                print("Getting affiliatedUsers  failed: \(err.jsonDict)")
                completion(nil, etxError)
            }
            
            req.onSuccess { (obj) in
                let res: ETXResponse = (obj.content as! ETXResponse)
                let affiliatedUsers: [ETXAffiliatedUser] = Mapper<ETXAffiliatedUser>().mapArray(JSONArray: res.result as! [[String : Any]])!
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
    func saveCurrentUser(_ accessToken: ETXAccessToken?, rememberUser: Bool) {
        self.deleteCurrentUser()
        if let userId:String = accessToken?.userId, let accessToken: String =  accessToken?.id {
            self.setAccessToken(accessToken, rememberUser: rememberUser)
            self.keychainInstance.set(userId, forKey: ETXConstants.KEY_DEFAULTS_USER_ID)
        }
    }
    
    func getCurrentUserId() -> String? {
        cleanUpOldCurrentUserRefs()
        let userId = keychainInstance.string(forKey: ETXConstants.KEY_DEFAULTS_USER_ID)
        return userId
    }
    
    func deleteCurrentUser() {
        keychainInstance.removeObject(forKey: ETXConstants.KEY_DEFAULTS_USER_ID)
        self.deleteAccessToken()
        cleanUpOldCurrentUserRefs()
    }
    
    private func cleanUpOldCurrentUserRefs() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: ETXConstants.KEY_DEFAULTS_CURRENT_USER)
    }
    
    func loginWithEmail(_ email: String, password: String, rememberMe: Bool, done: @escaping (T?, ETXError?) ->Void) {
        let userCredentials = UserEmailCredentials(email, password: password)
        self.login(credentials: userCredentials, rememberMe: rememberMe, completion: done)
    }
    
    func loginWithUsername(_ username: String, password: String, rememberMe: Bool, done: @escaping (T?, ETXError?) ->Void) {
        let userCredentials = UsernameCredentials(username, password: password)
        self.login(credentials: userCredentials, rememberMe: rememberMe, completion: done)
    }
    
    func logout(completion: @escaping (ETXError?) ->Void) {
        let req = self.users.child("/logout").request(.post)
        req.onFailure { (err) in
            let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
            completion(etxError)
        }
        
        req.onSuccess { (obj) in
            self.deleteCurrentUser()
            self.wipeResources()
            completion(nil)
        }
    }
    
    func initiatePasswordReset(emailAddress: String, completion: @escaping (_ err: ETXError?)->Void) {
        self.deleteCurrentUser()
        let reqBody:[String:String] = ["email": emailAddress]
        let req = self.users.child("/reset").request(.post, json: reqBody)
        
        req.onFailure { (err) in
            let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
            completion(etxError)
        }
        
        req.onSuccess { (obj) in
            completion(nil)
        }
    }
    
    func changePassword(_ passwordUpdateCredentials: PasswordUpdateCredentials, userId: String, completion: @escaping (_ err: ETXError?)->Void) {
        let req = self.users.child("/\(userId)").request(.put, json: passwordUpdateCredentials.toJSON())
        
        req.onFailure { (err) in
            let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
            completion(etxError)
        }
        
        req.onSuccess { (obj) in
            completion(nil)
        }
    }
    
    func changeEmailAddress(_ emailUpdateCredentials: EmailUpdateCredentials, userId: String, completion: @escaping (_ err: ETXError?)->Void) {
        // TODO: Integrate with API
        completion(nil)
    }

}
