//
//  SaveProductFileOperation.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 01/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class SaveProductJSONOperation: BaseFileOperation {
    
    private let product: Product
    
    init(product: Product, store: Store) {
        self.product = product
        
        super.init(store: store)
    }
    
    override func main() {
        store.add(product: product)
        store.saveToJsonFile()
        
        print("Save products to file completed")
        
        finish()
    }
}
