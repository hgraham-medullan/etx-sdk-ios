//
//  ShareableModelDataService.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/22/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

public class ETXShareableModelDataService<T: ETXShareableModel>: ETXDataService<T> {
    
    init(repository: ETXShareableModelRespository<T>) {
        super.init()
        self.repository = repository
    }
}
