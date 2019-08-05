//
//  Store.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 01/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class Store {
    private(set) var products: [Product] = [Product]()
    
    init() {
        loadFromPlist()
    }
}

//MARK: - Public interface

extension Store {
    func add(product: Product) {
        if let index = products.firstIndex(where: { $0.uid == product.uid }) {
            products[index] = product
        } else {
            products.append(product)
        }
    }
    
    func replaceAll(products: [Product]) {
        self.products = products
    }
    
    func remove(with uid: String) {
        if let index = products.firstIndex(where: { $0.uid == uid }){
            products.remove(at: index)
        }
    }
    
    func saveToJsonFile() {
        guard let fileUrl = getStoreJsonFilePath() else { return }
        
        var jsonArrayProducts = [[String: Any]]()
        for product in products {
            jsonArrayProducts.append(product.json)
        }
        
        do {
            let jsdata = try JSONSerialization.data(withJSONObject: jsonArrayProducts, options: [])
            try jsdata.write(to: fileUrl)
        } catch {
            print("Error save products to file, \(error.localizedDescription)")
        }
    }
    
    func loadFromJsonFile() {
        guard let fileUrl = getStoreJsonFilePath() else {
            return
        }
        
        do {
            let jsData = try Data(contentsOf: fileUrl)
            
            let anyJsonObject = try JSONSerialization.jsonObject(with: jsData, options: [])
            
            guard let jsonArrayProducts = anyJsonObject as? [[String : Any]] else { return }
            
            products = []
            
            for item in jsonArrayProducts {
                guard let product = Product.parse(json: item) else { continue }
                add(product: product)
            }
        } catch {
            print("Error reading data from a file, \(error.localizedDescription)")
        }
    }
    
    func saveImageToCache(imageURL: NSURL, imageName: String) -> String? {
        guard let pathExtension = imageURL.pathExtension,
            let fileUrl = getStoreImagesFilePath(imageName: "\(imageName).\(pathExtension)") else {
            return nil
        }
        
        do {
            let jsdata = try Data(contentsOf: imageURL as URL)
            try jsdata.write(to: fileUrl)
            
            return fileUrl.path
        } catch {
            return nil
        }
    }
}

//MARK: - Private metods

extension Store {
    private func loadFromPlist() {
        guard let filePath = Bundle.main.path(forResource: "Store", ofType: "plist") else { return }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else { return }
        
        let decoder = PropertyListDecoder()
        do {
            products = try decoder.decode([Product].self, from: data)
        } catch {
            print("Error decoding product array, \(error.localizedDescription)")
        }
    }
    
    private func getStoreJsonFilePath() -> URL? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let directoryName = "HorseShopStore"
        let filename = "store.json"
        var isDir: ObjCBool = false
        let dirUrl = path.appendingPathComponent(directoryName)
        
        if !FileManager.default.fileExists(atPath: dirUrl.path, isDirectory: &isDir), !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating directory \"\(directoryName)\", \(error.localizedDescription)")
                return nil
            }
        }
        
        let fileUrl = dirUrl.appendingPathComponent(filename)
        
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            if !FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil) {
                return nil
            }
        }
        
        return fileUrl
    }
    
    private func getStoreImagesFilePath(imageName: String) -> URL? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let directoryName = "HorseShopStore"
        var isDir: ObjCBool = false
        let dirUrl = path.appendingPathComponent(directoryName)
        
        if !FileManager.default.fileExists(atPath: dirUrl.path, isDirectory: &isDir), !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating directory \"\(directoryName)\", \(error.localizedDescription)")
                return nil
            }
        }
        
        let fileUrl = dirUrl.appendingPathComponent(imageName)
        
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            if !FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil) {
                return nil
            }
        }
        
        return fileUrl
    }
}
