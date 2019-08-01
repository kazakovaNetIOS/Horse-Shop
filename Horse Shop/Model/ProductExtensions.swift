//
//  ProductExtensions.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 01/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

extension Product {
    
    var json: [String: Any] {
        var dict = [String: Any]()
        
        dict["uid"] = self.uid
        dict["title"] = self.title
        dict["price"] = self.price
        dict["manufacturer"] = self.manufacturer
        
        if let image = self.image {
            dict["image"] = image
        }
        
        if let description = self.description {
            dict["description"] = description
        }
        
        return dict
    }
    
    static func parse(json: [String: Any]) -> Product? {
        guard json.count != 0,
            json["uid"] != nil,
            json["title"] != nil,
            json["price"] != nil,
            json["manufacturer"] != nil else {
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
            case "uid":
                guard let uidString = value as? String, uidString != "" else {
                    return nil
                }
                
                uid = uidString
            case "title":
                guard let titleString = value as? String else {
                    return nil
                }
                
                title = titleString
            case "price":
                guard let priceDouble = value as? Double else {
                    return nil
                }
                
                price = priceDouble
            case "manufacturer":
                guard let manufacturerString = value as? String else {
                    return nil
                }
                
                manufacturer = manufacturerString
            case "image":
                guard let imageString = value as? String else {
                    return nil
                }
                
                image = imageString
            case "description":
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
