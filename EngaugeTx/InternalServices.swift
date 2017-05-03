//
//  InternalServices.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/20/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

class ETXInternalService {
    
    static func getCurrentUserId() -> String? {
        let defaults = UserDefaults.standard
        return defaults.dictionary(forKey: ETXConstants.KEY_DEFAULTS_CURRENT_USER)?[ETXConstants.KEY_DEFAULTS_USER_ID] as! String?
    }
}
