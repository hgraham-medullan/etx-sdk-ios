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
        switch(event) {
        case ResourceEvent.observerAdded:
            EngaugeTxLog.debug("Resource Observer added")
        default:
            EngaugeTxLog.debug("resource Event", context: event)
        }
        if let latestError = resource.latestError {
            EngaugeTxLog.debug("An http error occurred with status code: \(String(describing: latestError.httpStatusCode))")
        }
    }
}
