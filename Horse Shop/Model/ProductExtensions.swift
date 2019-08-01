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
        
        if let date = self.dateOfAdding {
            dict["dateOfAdding"] = date.timeIntervalSince1970
        }
        
        return dict
    }
    
    static func parse(json: [String: Any]) -> Product? {
        guard json.count != 0,
            json["uid"] != nil,
            json["title"] != nil,
            json["price"] != nil else {
                return nil
        }
        
        var uid: String = ""
        var title: String = ""
        var price: Double = 0.0
        var dateOfAdding: Date?
        
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
            case "dateOfAdding":
                guard let timeInterval = value as? TimeInterval else {
                    return nil
                }
                
                dateOfAdding = Date(timeIntervalSince1970: timeInterval)
            default:
                break
            }
        }
        
        return Product(
            uid: uid,
            title: title,
            price: price,
            dateOfAdding: dateOfAdding
        )
    }
}
