//
//  SaveProduct.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 03/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class SaveProductOperation: AsyncOperation {
    
    init(product: Product,
         store: Store,
         imageUrl: NSURL?,
         fileQueue: OperationQueue,
         imageQueue: OperationQueue) {
        super.init()
        if let imageUrl = imageUrl {
            saveProductWithImage(imageUrl, store, product, fileQueue, imageQueue)
        } else {
            saveProductWithoutImage(product, store, fileQueue)
        }
    }
    
    override func main() {
        finish()
    }
    
    private func saveProductWithImage(_ imageUrl: NSURL,
                                      _ store: Store,
                                      _ product: Product,
                                      _ fileQueue: OperationQueue,
                                      _ imageQueue: OperationQueue) {
        let saveProductImage = SaveProductImageOperation(imageUrl: imageUrl,
                                                         store: store,
                                                         productId: product.uid)
        saveProductImage.completionBlock = {
            let newProduct = Product(uid: product.uid,
                                     title: product.title,
                                     price: product.price,
                                     manufacturer: product.manufacturer,
                                     image: saveProductImage.result,
                                     description: product.description)
            let saveProductToFile = SaveProductJSONOperation(product: newProduct, store: store)
            self.addDependency(saveProductToFile)
            fileQueue.addOperation(saveProductToFile)
        }
        
        addDependency(saveProductImage)
        imageQueue.addOperation(saveProductImage)
    }
    
    private func saveProductWithoutImage(_ product: Product,
                                         _ store: Store,
                                         _ fileQueue: OperationQueue) {
        let saveProductToFile = SaveProductJSONOperation(product: product, store: store)
        self.addDependency(saveProductToFile)
        fileQueue.addOperation(saveProductToFile)
    }
}
