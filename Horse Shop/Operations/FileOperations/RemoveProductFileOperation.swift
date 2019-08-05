//
//  RemoveProductFileOperation.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 01/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class RemoveProductFileOperation: BaseFileOperation {
    
    private let productId: String
    
    init(productId: String, store: Store) {
        self.productId = productId
        super.init(store: store)
    }
    
    override func main() {
        store.remove(with: productId)
        store.saveToJsonFile()
        
        print("Remove product from file completed")
        
        finish()
    }
}
