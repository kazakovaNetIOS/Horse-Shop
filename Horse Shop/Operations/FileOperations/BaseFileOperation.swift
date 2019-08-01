//
//  BaseFileOperation.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 01/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class BaseFileOperation: AsyncOperation {
    
    let store: Store
    
    init(store: Store) {
        self.store = store
        
        super.init()
    }
}
