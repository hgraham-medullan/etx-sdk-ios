//
//  UserRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/5/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Alamofire
class UserRepository {
    
    let headers: HTTPHeaders
    
    init() {
        headers = [
            "Authorization": "thqvTvYIqTPFCIYmTKz2YM397vYLVlTHwrWVPS2GsJTvA4DhVxYr8DJEJewwIXVt",
            "Accept": "application/json"
        ]
    }
    
    func login(don: @escaping (String) ->Void) {
        // TODO: clear auth token before login
        Alamofire.request( EngaugeTxApplication.DEFAULT_BASE_URL + "/users/57f3d6999ba8b300cfd604ed").responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let defaults = UserDefaults.standard
                defaults.set("the-token", forKey: "accessToken")

            }
            don("Done")
        }
    }
    
    func getAccessToken() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "accessToken")
    }
    
    func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "accessToken")
    }

}
