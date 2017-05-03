//
//  ResourceObserver.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 4/27/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta

class TxResourceObserver: ResourceObserver{
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        print("asds")
        switch(event) {
        case ResourceEvent.observerAdded:
            print("Observer added")
        default:
            print(event)
        }
        if let latestError = resource.latestError {
            //latestError.httpStatusCode
            print("err: \(latestError.httpStatusCode)")
        }
    }
    
//    func resourceRequestProgress(for resource: Resource, progress: Double) {
//        
//    }
}
