//
//  Restoration.swift
//  OrderApp
//
//  Created by Антон Шалимов on 27.03.2023.
//

import Foundation

/// Создаем расширение для класса `NSUserActivity`
extension NSUserActivity {
    
    /// Определяем вычислительное свойство `order`
    /// Свойство типизировано как опциональный экземпляр `Order`,
    /// т.е. может быть либо инстансом `Order`, либо `nil`
    var order: Order? {
        get {
            /// В геттере мы делаем следующее:
            /// 1. Проверяем есть ли значение для ключа `order` в словаре `userInfo`
            /// 2. Если значение есть, и оно может быть преобразовано в тип `Data`, то JSON-декодер используется
            ///     для преобразования `Data` в экземпляр `Order`
            /// 3. Если какой-то из этих шагов не удается выполнить (значение для ключа `order` отсутствует или
            ///     или не может быть преобразовано в тип `Data`), то геттер возвращает `nil`
            guard let jsonData = userInfo?["order"] as? Data else {
                return nil
            }
            
            return try? JSONDecoder().decode(Order.self, from: jsonData)
        }
        
        set {
            /// Сеттер делает следующие вещи:
            /// 1. Проверяет, не является ли переданное значение `nil`,
            /// 2. Если это не так, то, то JSONEncoder используется для преобразования переданного значения
            ///     `Order` в `Data`.
            /// 3. Затем метод `addUserInfoEntries` добавляет в словарь `userInfo` значенив в ключ `order` с
            ///     текущим заказом пользователя
            /// 4. Если переданное значение = `nil`, то ключ `order` удалется из словаря `userInfo`
            if let newValue = newValue, let jsonData = try? JSONEncoder().encode(newValue) {
                addUserInfoEntries(from: ["order": jsonData])
            } else {
                userInfo?["order"] = nil
            }
        }
    }
}
