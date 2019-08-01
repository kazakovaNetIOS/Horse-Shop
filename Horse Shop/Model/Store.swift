//
//  Store.swift
//  Horse Shop
//
//  Created by Natalia Kazakova on 01/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

class Store {
    public private(set) var products: [Product] = [Product]()
    
    init() {
        loadDummyData()
    }
    
    public func add(product: Product) {
        if let index = products.firstIndex(where: { $0.uid == product.uid }) {
            products[index] = product
        } else {
            products.append(product)
        }
    }
    
    public func replaceAll(products: [Product]) {
        self.products = products
    }
    
    public func remove(with uid: String) {
        if let index = products.firstIndex(where: { $0.uid == uid }){
            products.remove(at: index)
        }
    }
    
    public func saveToFile() {
        guard let fileUrl = getStoreFilePath() else {
            return
        }
        
        var jsonArrayProducts = [[String: Any]]()
        for product in products {
            jsonArrayProducts.append(product.json)
        }
        
        do {
            let jsdata = try JSONSerialization.data(withJSONObject: jsonArrayProducts, options: [])
            try jsdata.write(to: fileUrl)
        } catch {
            print("Error save products to file, \(error)")
        }
    }
    
    public func loadFromFile() {
        guard let fileUrl = getStoreFilePath() else {
            return
        }
        
        do {
            let jsData = try Data(contentsOf: fileUrl)
            
            let anyJsonObject = try JSONSerialization.jsonObject(with: jsData, options: [])
            
            guard let jsonArrayProducts = anyJsonObject as? [[String : Any]] else { return }
            
            products = []
            
            for item in jsonArrayProducts {
                if let product = Product.parse(json: item) {
                    add(product: product)
                }
            }
        } catch {
            print("Error reading data from a file, \(error)")
        }
    }
    
    private func getStoreFilePath() -> URL? {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        var isDir: ObjCBool = false
        let dirUrl = path.appendingPathComponent("Stores")
        
        if !FileManager.default.fileExists(atPath: dirUrl.path, isDirectory: &isDir), !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating directory \"store\", \(error)")
                return nil
            }
        }
        
        let fileUrl = dirUrl.appendingPathComponent("store")
        
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            if !FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil) {
                return nil
            }
        }
        
        return fileUrl
    }
    
    private func loadDummyData() {
        add(product: Product(uid: "1", title: "Ногавки анатомические передние", price: 3250, manufacturer: "NORTON Light", image: nil, description: "Эти рабочие ногавки на каждый день предлагают простую, но эффективную защиту ног лошади. Новый стиль этих неопреновых ногавок с застежками-липучками идеально подходит для тренировок. Неопрен снабжен вентиляционными отверстиями для усиления циркуляции воздуха. Эти ногавки легко надеть и они выглядят также стильно, как бинты."))
        add(product: Product(uid: "2", title: "Ногавки анатомические задние", price: 3750, manufacturer: "NORTON Light", image: nil, description: "Эти рабочие ногавки на каждый день предлагают простую, но эффективную защиту ног лошади. Новый стиль этих неопреновых ногавок с застежками-липучками идеально подходит для тренировок. Неопрен снабжен вентиляционными отверстиями для усиления циркуляции воздуха. Эти ногавки легко надеть и они выглядят также стильно, как бинты."))
        add(product: Product(uid: "3", title: "Трензель литой строгий", price: 1550, manufacturer: "Feeling", image: nil, description: "Распространенный вид трензеля, который оказывает прямое давление без рычагов. При натяжении повода создается воздействие на середину языка и края губ. Трензель имеет цельную литую структуру (не дутый), поэтому тяжелее обычного дутого и будет оказывать более сильное давление на рот лошади. Толщина грызла 14мм является довольно тонкой для современных трензелей, имеет небольшую площадь контакта, и будет оказывать дополнительное давление. Материал нержавеющая сталь."))
        add(product: Product(uid: "4", title: "Недоуздок жеребячий", price: 490, manufacturer: "Pfiff", image: nil, description: "Недоуздок сделан из прочного двуслойного нейлона с крепкой фурнитурой. Цвет: коричневый, синий-голубой, серый, сине-розовый"))
        add(product: Product(uid: "5", title: "Седло Seneca", price: 79990, manufacturer: "Kentaur", image: nil, description: "Легкое, универсальное седло с пластиковым ленчиком. Спинные подушки набиты шерстью. Ширина ленчика: М = 30 см на среднюю спину лошади, W = 32 см на средне-широкую. Размер 17,5” - для всадника весом от 50 до 70 кг."))
        
        saveToFile()
    }
}
