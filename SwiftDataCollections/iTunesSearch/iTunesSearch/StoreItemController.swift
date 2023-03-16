//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Антон Шалимов on 16.03.2023.
//

import Foundation

/// ENUM для хранения ошибок, которые могут возникнуть при запросе в iTunes
enum ITunesRequestError: Error, LocalizedError {
    case somethingWentWrong
}

class StoreItemController{
    /// Функция для получения данных iTunes
    /// - Parameter query: Словарь запроса
    /// - Throws: Кейсы ENUM'a `ITunesRequestError`
    /// - Returns: Массив из `StoreItem`'ов
    func fetchItems(matching query: [String:String]) async throws -> [StoreItem] {
        // Создаем search request с помощью класса URLComponents
        var searchRequest = URLComponents(string: "https://itunes.apple.com/search")!
        
        // Задаем query items в соответствии с переданным в аргументе запросом
        searchRequest.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
        
        // Используя метод data делаем веб запрос
        let (data, response) = try await URLSession.shared.data(
            from: searchRequest.url!)
        
        // Проверяем валидность полученного ответа
        // В случае если ответ соответствует HTTPURLResponse и его статус код == 200 - продолжаем
        // выполнение. В противном случае бросам ошибку somethingWentWrong
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ITunesRequestError.somethingWentWrong
        }
        
        
        // Declaring JSON decoder
        let jsonDecoder = JSONDecoder()
        
        // Пытаемся распарсить полученный JSON в объект SearchResponse
        let searchResponse = try jsonDecoder.decode(SearchResponse.self, from: data)
        
        return searchResponse.results
    }
}
