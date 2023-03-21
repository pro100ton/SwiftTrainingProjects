//
//  MenuItem.swift
//  OrderApp
//
//  Created by Антон Шалимов on 18.03.2023.
//

import Foundation

// Создаем структуру модели пункта меню
struct MenuItem: Codable {
    var id: Int
    var name: String
    var detailText: String
    var price: Double
    var category: String
    var imageURL: URL
    
    /// Перечисление CodingKeys используется для сопоставления ключей значений в JSON данных с характеристиками
    /// структуры.
    /// В данном примере например характеристике `detailText` будет соответствовать ключ `description` в
    /// JSON объекте
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case detailText = "description"
        case price
        case category
        case imageURL = "image_url"
    }
    
    static func createFailedInstance() -> MenuItem {
        return MenuItem(id: 0,
                        name: "Not found",
                        detailText: "Not found",
                        price: 0.0,
                        category: "Not found",
                        imageURL: URL(string: "notfound.com")!)
    }
}
