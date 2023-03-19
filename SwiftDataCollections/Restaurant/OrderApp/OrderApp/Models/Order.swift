//
//  Order.swift
//  OrderApp
//
//  Created by Антон Шалимов on 19.03.2023.
//

import Foundation

/// Структура для хранения спика объектов, которые пользователь добавил в свой заказ
struct Order: Codable {
    var menuItems: [MenuItem]
    
    /// В данном случае конструктор принимает параметр menuItems, который по умолчанию имеет пустой массив
    /// [MenuItem] = []. Таким образом, при создании нового экземпляра структуры Order, если не передать массив
    /// объектов MenuItem в качестве аргумента, то свойство menuItems будет инициализировано пустым массивом.
    /// - Parameter menuItems: Массив объектов элементов меню
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
