//
//  ResponseModels.swift
//  OrderApp
//
//  Created by Антон Шалимов on 18.03.2023.
//

// Данный файл создан для хранения response'ов, которые будут представлять из себя массивы строк и
// массивы объектов для categories и items соответственно

import Foundation

/// Структура для получения данных о menuItems, которые представляют собой массив из MenuItems
/// Используется для endpoint'a `/menu`
struct MenuResponse: Codable {
    let items: [MenuItem]
}

/// Структура для получения данных о категориях пуктов меню. Получается с сервера ввиде массива строк
/// Используется для endpoint'a `/categories`
struct CategoriesResponse: Codable {
    let categories: [String]
}

/// Структура для хранения ответа о времени приготовления заказа.
/// Прдеставляет из себя время, через которое заказ будет готов. 
/// Используется для endpoint'а `/order`
struct OrderResponse: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
