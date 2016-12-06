//
//  Repository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/6/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta
import ObjectMapper

class Repository<T: ETXModel> : Service, ResourceObserver {
    
    private let KEY_HEADER_APP_ID: String = "app-id"
    private let KEY_HEADER_CLIENT_KEY: String = "client-key"
    private let KEY_HEADER_AUTHORIZATION: String = "Authorization"
    
    public func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        print("The resource changed")
    }
    
    
    var resourcePath: String
    var etxResource: Resource {
        return resource(resourcePath)
    }
    
    init(resourcePath: String) {
        self.resourcePath = resourcePath
        super.init(baseURL:EngaugeTxApplication.baseUrl)
        configure {
            
            $0.headers[self.KEY_HEADER_APP_ID] = EngaugeTxApplication.appId
            $0.headers[self.KEY_HEADER_CLIENT_KEY] = EngaugeTxApplication.clientKey
            $0.headers["Authorization"] = self.getAccessToken()
        }
        
        //configureTransformer("", contentTransform: (Entity<τ_0_0>) throws -> τ_0_1?)
        configureTransformer("/users/**") {
            //(entity in)
            //print("Transforming")
            //ETXUser(x: $0.content)
            //Mapper<T>().map(JSON: $0.content)
            Mapper<T>().map(JSON: $0.content)
            
        }
        self.etxResource.addObserver(self)
//        self.etxResource.addObserver(owner: self) {
//            resource, _ in
//            if let m: T = self.etxResource.typedContent() {
//                print(m)
//            }
//        }
    }
    
    func save(model: T) {
        if let _ = model.id {
            self.update(model: model)
        } else {
            let _ = self.etxResource.request(.post, json: model as! JSONConvertible)
        }
    }
    
    private func update(model: T) {
        if let id = model.id {
            let _ = self.etxResource.child(id).request(.put, json: model as! JSONConvertible)
        }
    }
    
    func delete(model: T) {
        if let id = model.id {
            let _  = self.etxResource.child(id).request(.delete)
        }
    }
    
    func get(id: String) -> Void {
        let _  = self.etxResource.child(id)
    }
    
    func getAccessToken() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "accessToken")
    }
}
