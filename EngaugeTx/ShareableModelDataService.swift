//
//  ShareableModelDataService.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/22/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

/**
 Service class for handling shareable models
 */
public class ETXShareableModelDataService<T: ETXShareableModel>: ETXDataService<T> {
    
    required public init(repository: Repository<T>) {
        super.init(repository: repository)
    }
}
