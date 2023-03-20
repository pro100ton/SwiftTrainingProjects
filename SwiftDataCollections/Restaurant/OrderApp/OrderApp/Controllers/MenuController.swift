//
//  MenuController.swift
//  OrderApp
//
//  Created by Антон Шалимов on 19.03.2023.
//

import Foundation

/// Перечисление с вариантами ошибок, которые могут возникнуть при выполнении запросов к API меню ресторана
/// В данном случае MenuControllerError является перечислением, которое реализует протокол Error, что позволяет
/// использовать его для обработки ошибок в приложении. Также перечисление реализует протокол LocalizedError,
/// что позволяет задавать локализованное сообщение об ошибке.
enum MenuControllerError: Error, LocalizedError {
    case categoriesNotFound
    case menuItemsNotFound
    case OrderRequestFailed
}

/// Касс-контроллер, абстракция для работы с веб сервером
class MenuController {
    /// Инициализируем базовый URL для запросов информации с сервера
    let baseURL: URL = URL(string: "http://127.0.0.1:8080/")!
    
    /// Функция для получения информации о категориях с сервера.
    /// Предназначена для использования endpoint'a: `/categories`
    /// GET запрос, которому на вход не требуется ничего, а на выходе должен быть получен список из строк, содержащих
    /// категории меню
    /// `async` используется так как функция асинхронная и приостановит выполнение своего кода на моменте вызова ее
    /// с `await` ключевым словом.
    /// Также стоит отметить что `async` используется в первую очередь так как работа с `URLSession` должна быть
    /// асинхронной.
    /// `throws` нужен для отлавливания всех ошибок, которые могут возникнуть во время выполнения и обработки
    /// запроса категория
    func fetchCategories() async throws -> [String] {
        /// Формируем URL для запроса категорий
        let categoriesURL = baseURL.appending(path: "categories")
        
        /// Делаем запрос на свервер для получения категорий меню ресторана
        let (data, response) = try await URLSession.shared.data(from: categoriesURL)
        
        /// Проверяем что ответ пришел с кодом 200, в противном случае кидаем ошибку, связанную с категорией
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MenuControllerError.categoriesNotFound
        }
        
        /// Объявляем JSON decoder для преобразования полученного ответа
        let decoder = JSONDecoder()
        
        /// Пытаемся декодировать полученные данные с исользованем функции `decode(type:from:)`
        let categoriesFromReponse = try decoder.decode(CategoriesResponse.self, from: data)
        
        return categoriesFromReponse.categories
    }
    
    /// Функция для получения элементов меню в зависимости от выбранной категории.
    /// Предназначена для использования endpoint'a: `/menu`
    /// Данный GET запрос должен содержать query параметр - категорию.
    /// JSON который вернется содержит массив словарей, каждый из которых мы должны десериализовать в объект
    /// `MenuItem`.
    /// - Parameter categoryName: Имя категории, по которой требуется вернуть список объектов меню
    /// - Returns: Массив объектов `MenuItem`
    func fetchMenuItems(forCategory categoryName: String) async throws -> [MenuItem] {
        /// Формируем URL для запроса элементов меню
        let baseMenuURL = baseURL.appending(path: "menu")
        
        /// Для добавления `query` параметров можно использовать `URLComponents` чтобы добавть коллекцию
        /// `URLQueryItem` объектов.
        /// Поэтому сначала мы объявляем объект `URLComponents`
        var components = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)!
        
        /// Далее формируем массив объектов `URLQueryItem`'ов
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        
        /// Получаемый итоговый URL, который будет использоваться для получения компонентов меню
        let menuURL = components.url!
        
        /// Делаем запрос на сервер для получения объектов меню
        let (data, response) = try await URLSession.shared.data(from: menuURL)
        
       
        /// Проверяем что ответ пришел с кодом 200, в противном случае кидаем ошибку, связанную с элементом меню
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MenuControllerError.menuItemsNotFound
        }
        
        let decoder = JSONDecoder()
        let menuItemsFromResponse = try decoder.decode(MenuResponse.self, from: data)
        print(menuItemsFromResponse)
        return menuItemsFromResponse.items
    }
    
    /// Type alias для определения того, что должен возвращать метод подтверждения заказа
    typealias MinutesToPrepare = Int
    
    /// Функция для отправки ID элементов меню, выбранных пользователем, и получении в ответе кол-ва минут, которые
    /// потребуются для его приготовления.
    /// POST запрос, который берет на вход массив из ID's объектов меню, который выбрал пользователь.
    /// На выходе должно быть количество минут, которые потруются для его приготовления
    /// - Parameter menuIDs: Массив Int из ID объектов меню
    /// - Returns: Кол-во минут, которое потребуется для приготовления заказа
    func submitOrder(forMenuIDs menuIDs: [Int]) async throws -> MinutesToPrepare {
        /// Формируем URL для подтверждения заказа
        let orderURL = baseURL.appendingPathExtension("order")
        
        /// Формирование POST заросов отличается от формирования GET запросов, поэтому:
        /// Для формирования POST запроса нужно сделать следующее:
        /// 1 - Создать объект `URLRequest` для спецификаций деталей запроса
        /// 2 - Необходимо поменять дефолтное значение `GET` на `POST`
        /// 3 - Обозначить, что на сервер будет отправляться `JSON` объект
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        /// Далее мы сохраняем полученный из аргументов массив ID объектов меню, и помещаем его в словарь с ключем
        /// `menuIds`
        let menuIdsDict = ["menuIds": menuIDs]
        /// Далее мы конвертируем сформированный словарь в объект `JSON`
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(menuIdsDict)
        
        /// Далее необходимо помести
        request.httpBody = jsonData
        
        /// Затем вызывается метод `URLSession.data(for:delegate:)` для осуществления запроса
        let (data, response) = try await URLSession.shared.data(for: request)
        
        /// Проверяем что ответ пришел с кодом 200, в противном случае кидаем ошибку, связанную с элементом меню
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MenuControllerError.OrderRequestFailed
        }
        
        let decoder = JSONDecoder()
        let orderResponse = try decoder.decode(OrderResponse.self, from: data)
        
        return orderResponse.prepTime
    }
}
