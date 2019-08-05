//
//  Product.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 01/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

private enum ProductFields: String {
    case uid = "uid"
    case title = "title"
    case price = "price"
    case manufacturer = "manufacturer"
    case image = "image"
    case description = "description"
}

struct Product: Codable {
    let uid: String
    let title: String
    let price: Double
    let manufacturer: String
    let image: String?
    let description: String?
    
    init(uid: String = UUID().uuidString,
         title: String,
         price: Double = 0.0,
         manufacturer: String,
         image: String?,
         description: String?) {
        self.uid = uid
        self.title = title
        self.price = price
        self.manufacturer = manufacturer
        self.image = image
        self.description = description
    }
}

extension Product {
    
    var json: [String: Any] {
        var dict = [String: Any]()
        
        dict[ProductFields.uid.rawValue] = self.uid
        dict[ProductFields.title.rawValue] = self.title
        dict[ProductFields.price.rawValue] = self.price
        dict[ProductFields.manufacturer.rawValue] = self.manufacturer
        
        if let image = self.image {
            dict[ProductFields.image.rawValue] = image
        }
        
        if let description = self.description {
            dict[ProductFields.description.rawValue] = description
        }
        
        return dict
    }
    
    static func parse(json: [String: Any]) -> Product? {
        guard json.count != 0,
            json[ProductFields.uid.rawValue] != nil,
            json[ProductFields.title.rawValue] != nil,
            json[ProductFields.price.rawValue] != nil,
            json[ProductFields.manufacturer.rawValue] != nil else {
                return nil
        }
        
        var uid: String = ""
        var title: String = ""
        var price: Double = 0.0
        var manufacturer: String = ""
        var image: String?
        var description: String?
        
        for (key, value) in json {
            switch key {
            case ProductFields.uid.rawValue:
                guard let uidString = value as? String, uidString.isEmpty == false else {
                    return nil
                }
                
                uid = uidString
            case ProductFields.title.rawValue:
                guard let titleString = value as? String else {
                    return nil
                }
                
                title = titleString
            case ProductFields.price.rawValue:
                guard let priceDouble = value as? Double else {
                    return nil
                }
                
                price = priceDouble
            case ProductFields.manufacturer.rawValue:
                guard let manufacturerString = value as? String else {
                    return nil
                }
                
                manufacturer = manufacturerString
            case ProductFields.image.rawValue:
                guard let imageString = value as? String else {
                    return nil
                }
                
                image = imageString
            case ProductFields.description.rawValue:
                guard let descriptionString = value as? String else {
                    return nil
                }
                
                description = descriptionString
            default:
                break
            }
        }
        
        return Product(
            uid: uid,
            title: title,
            price: price,
            manufacturer: manufacturer,
            image: image,
            description: description
        )
    }
}
