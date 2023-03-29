//
//  Restoration.swift
//  OrderApp
//
//  Created by Антон Шалимов on 27.03.2023.
//

import Foundation

/// ENUM для перечисления кейсов сцен нашего приложения
/// Каждый контроллер имеет `case` и `value` если оно требуется. Когда юзер перемещается по сценам нам нужно
///     отслеживать на каком контроллере в данный момент он находится.
/// Для этого мы будем использовать `String`, который будет хранится в словаре `userInfo` объекта
///     `NSUserActivity`
/// В свою очередь для этого мы создаем вложенный enum `Identifier`с сырым значением типа `String`, которое
///     будет использоавться для хранения идентификатора каждого контролера
enum StateRestorationController {
    enum Identifier: String {
        case categories, menu, menuItemDetail, order
    }
    
    case categories
    case menu(category: String)
    case menuItemDetail(MenuItem)
    case order
    
    /// Каждый идентификатор должен ассоциироваться с кейсом `StateRestorationController`, поэтому мы
    ///     создадим вычислительную проперти `identifier`, которая будет свитчится по `self` и возвращать
    ///     соответствующее значение `Identifier`
    var identifier: Identifier {
        switch self {
        case .categories: return Identifier.categories
        case .menu: return Identifier.menu
        case .menuItemDetail: return Identifier.menuItemDetail
        case .order: return Identifier.order
        }
    }
    
    /// Инициализатор для инициализации значения `StateRestorationContoller` с помощью `NSUserActivity`
    /// Используется для создания экземпляра `enum` для восстановления состояния после восстановления сцены
    init?(userActivity: NSUserActivity) {
        /// Проверяем `userActivity` на наличие ключа `controllerIdentifier`, в котором хранится информация
        /// о активности пользователя
        guard let identifier = userActivity.controllerIdentifier else { return nil }
        
        /// Если извелчение прошло успешно, то мы проходимся switch'ом по извлченному идентификатору VC и передаем
        /// состояние, хранимое в `NSUserActivity` в новый экземпляр `StateRestorationController`
        switch identifier {
        case .categories:
            self = .categories
        case .menu:
            if let category = userActivity.menuCategory {
                self = .menu(category: category)
            } else {
                return nil
            }
        case .menuItemDetail:
            if let menuItem = userActivity.menuItem {
                self = .menuItemDetail(menuItem)
            } else {
                return nil
            }
        case .order:
            self = .order
        }
    }
}

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
    
    /// Вычислетельное property для отслеживания того, на каком контроллере в данный момент находится пользователь
    var controllerIdentifier: StateRestorationController.Identifier? {
        get {
            /// Что происходит в `getter`'e:
            /// 1. Проверяется есть ли в словаре `userInfo` ключ `controllerIdentifier` и лежит ли в нем
            ///     значение типа `String`?
            ///     1.1 В случе если нет - возвращается `nil`
            /// 2. В случае если проверка прошла - возвращается идентификатор того контроллера, на котором
            ///     находится пользователь.
            if let controllerIdentifierString = userInfo?["controllerIdentifier"] as? String {
                return StateRestorationController.Identifier(rawValue: controllerIdentifierString)
            } else {
                return nil
            }
        }
        
        set {
            /// В сеттере устанавливаем ключу `controllerIdentifier` значение `Identifier`
            userInfo?["controllerIdentifier"] = newValue?.rawValue
        }
    }
    
    /// Вычислетельное проперти для храения информации о категории меню, в которой находится пользователь
    var menuCategory: String? {
        get {
            return userInfo?["menuCategory"] as? String
        }
        
        set {
            userInfo?["menuCategory"] = newValue
        }
    }
    
    /// Вычислетельное проперти для хранения информации о том элементе меню, которое просматривает пользователь
    var menuItem: MenuItem? {
        get {
            guard let jsonData = userInfo?["menuItem"] as? Data else { return nil }
            
            return try? JSONDecoder().decode(MenuItem.self, from: jsonData)
        }
        
        set {
            if let newValue = newValue, let jsonData = try? JSONEncoder().encode(newValue)
            {
                addUserInfoEntries(from: ["menuItem": jsonData])
            } else {
                userInfo?["menuItem"] = nil
            }
        }
        
    }
}
