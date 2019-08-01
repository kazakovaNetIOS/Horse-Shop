//
//  Product.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 01/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

struct Product {
    let uid: String
    let title: String
    let price: Double
    let manufacturer: String
    let image: String?
    
    init(uid: String = UUID().uuidString, title: String, price: Double = 0.0, manufacturer: String, image: String?) {
        self.uid = uid
        self.title = title
        self.price = price
        self.manufacturer = manufacturer
        self.image = image
    }
}
