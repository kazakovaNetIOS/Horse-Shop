//
//  LoadProductsFileOperation.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 01/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class LoadProductsFileOperation: BaseFileOperation {
    
    var result: [Product]?
    
    override init(store: Store) {
        super.init(store: store)
    }
    
    override func main() {
        store.loadFromJsonFile()
        result = store.products
        
        print("Load products from file completed")
        
        finish()
    }
}
