//
//  SaveImageProductOperation.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 03/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class SaveProductImageOperation: BaseFileOperation {
    
    var result: String?
    private let imageUrl: NSURL
    private let productId: String
    
    init(imageUrl: NSURL, store: Store, productId: String) {
        self.imageUrl = imageUrl
        self.productId = productId
        
        super.init(store: store)
    }
    
    override func main() {
        result = store.saveImageToCache(imageURL: imageUrl, imageName: productId)
        
        print("Save product image completed")
        
        finish()
    }
}
